 --Заготовка для unit-тестов 

 --Проверка "Создание платежа"
   
DECLARE
  v_payment_detail    t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'MobileApp')
                                                                      ,t_payment_detail(2
                                                                                       ,'95.165.24.178')
                                                                      ,t_payment_detail(3
                                                                                       ,'Платеж через браузер Chrome'));
  v_payment_id        payment.payment_id%TYPE;
  v_create_dtime_tech payment.create_dtime_tech%TYPE;
  v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
  v_payment_id := create_payment(p_payment_detail => v_payment_detail
                                ,p_summa          => 10000
                                ,p_currency_id    => 643
                                ,p_from_client_id => 1
                                ,p_to_client_id   => 4);
  dbms_output.put_line('Payment_id: ' || v_payment_id);

  SELECT create_dtime_tech
        ,update_dtime_tech
    INTO v_create_dtime_tech
        ,v_update_dtime_tech
    FROM payment
   WHERE payment_id = v_payment_id;

  IF v_create_dtime_tech != v_update_dtime_tech
  THEN
    raise_application_error(-20999, 'Технические даты разные');
  END IF;

  COMMIT;
END;
/

SELECT * FROM payment a WHERE a.payment_id = 85;
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;


--Проверка "Сброс платежа в "ошибочный статус" с указанием причины"
DECLARE
  v_reason            payment.status_change_reason%TYPE := 'Недостаточно средств на счете';
  v_payment_id        payment.payment_id%TYPE := 85;
  v_create_dtime_tech payment.create_dtime_tech%TYPE;
  v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
  fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
  
  SELECT create_dtime_tech
        ,update_dtime_tech
    INTO v_create_dtime_tech
        ,v_update_dtime_tech
    FROM payment
   WHERE payment_id = v_payment_id;

  IF v_create_dtime_tech = v_update_dtime_tech
  THEN
    raise_application_error(-20999, 'Технические даты разные');
  END IF;
  COMMIT;
END;
/
SELECT * FROM payment a WHERE a.payment_id = 85;
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;


--Проверка запрета удаления платежа через delete
DECLARE
  v_payment_id payment.payment_id%TYPE := 85;
BEGIN
  DELETE payment a WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_delete_forbidden THEN
    dbms_output.put_line('Удаление платежа. Исключение возбуждено успешно. Ошибка: ' || SQLERRM);
END;
/

--Проверка запрета вставки платежа не через API
DECLARE
  v_payment_id payment.payment_id%TYPE := 85;
BEGIN
  INSERT INTO payment
    (payment_id, status, summa, currency_id, from_client_id, to_client_id)
  VALUES
    (v_payment_id, payment_api_pack.c_status_success, 15000, 643, 1, 4);

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_manual_changes THEN
    dbms_output.put_line('Вставка в таблицу client не через API. Исключение возбуждено успешно. Ошибка: ' || SQLERRM);
END;
/

--Проверка запрета обновления платежа не через API
DECLARE
  v_payment_id payment.payment_id%TYPE := 85;
BEGIN
  UPDATE payment a SET a.status = a.status WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_manual_changes THEN
    dbms_output.put_line('Обновление таблицы client не через API. Исключение возбуждено успешно. Ошибка: ' || SQLERRM);
END;
/
--Проверка запрета вставки платежа не через API
DECLARE
  v_payment_id payment_detail.payment_id%TYPE := 85;
BEGIN
  INSERT INTO payment_detail
    (payment_id, field_id, field_value)
  VALUES
    (v_payment_id, 1, 'TestMobile');

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_detail_api_pack.e_manual_changes THEN
    dbms_output.put_line('Вставка в таблицу payment_detail не через API. Исключение возбуждено успешно. Ошибка: ' ||
                         SQLERRM);
END;
/

--Проверка запрета обновления платежа не через API
DECLARE
  v_payment_id payment_detail.payment_id%TYPE := 85;
BEGIN
  UPDATE payment_detail a SET a.field_value = 'App' WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_detail_api_pack.e_manual_changes THEN
    dbms_output.put_line('Обновление таблицы payment_detail не через API. Исключение возбуждено успешно. Ошибка: ' ||
                         SQLERRM);
END;
/

--Проверка запрета удаления платежа через delete
DECLARE
  v_payment_id payment_detail.payment_id%TYPE := 85;
BEGIN
  DELETE payment_detail a WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_detail_api_pack.e_manual_changes THEN
    dbms_output.put_line('Удаление платежа таблицы payment_detail не через API. Исключение возбуждено успешно. Ошибка: ' ||
                         SQLERRM);
END;
/

--Проверка "Отмена платежа из-за ошибки пользователя"
DECLARE
  v_reason     payment.status_change_reason%TYPE := 'Ошибка пользователя';
  v_payment_id payment.payment_id%TYPE := 44;
BEGIN
  cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
  COMMIT;
END;
/
SELECT * FROM payment a WHERE a.payment_id = 44;
SELECT * FROM payment_detail a WHERE a.payment_id = 44 ORDER BY a.field_id;


--Проверка "Успешное завершение платежа"
DECLARE
  v_payment_id payment.payment_id%TYPE := 44;
BEGIN
  successful_finish_payment(p_payment_id => v_payment_id);
  COMMIT;
END;
/
SELECT * FROM payment a WHERE a.payment_id = 44;
SELECT * FROM payment_detail a WHERE a.payment_id = 44 ORDER BY a.field_id;

--Проверка "Добавление или обновление платежа по списку id_поля/значение"

DECLARE
  v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(2
                                                                                    ,'178.234.89.201')
                                                                   ,t_payment_detail(4
                                                                                    ,'Проверен 2025-05-11T14:22:44, риск 0.5%'));
  v_payment_id     payment.payment_id%TYPE := 44;
BEGIN
  insert_or_update_payment_detail(p_payment_id => v_payment_id, p_payment_detail => v_payment_detail);
  COMMIT;
END;
/
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;

--Проверка "Удаление платежа по списку id_полей"

DECLARE
  v_delete_field_ids t_number_array := t_number_array(2, 3);
  v_payment_id       payment.payment_id%TYPE := 44;
BEGIN
  delete_payment_detail(p_payment_id => v_payment_id, p_delete_field_ids => v_delete_field_ids);
  COMMIT;
END;
/
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;


SELECT * FROM payment a WHERE a.payment_id = -1;
SELECT * FROM payment_detail a WHERE a.payment_id = 44 ORDER BY a.field_id;


      
