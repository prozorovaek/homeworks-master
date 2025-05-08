/*﻿
Автор: Прозорова Эльвира
Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
*/
---- Пример 1: Создание платежа
DECLARE
  c_created CONSTANT payment.status%TYPE := 0;
  l_msg            VARCHAR2(50) := 'Платеж создан. ';
  v_current_dtime  TIMESTAMP := systimestamp;
  v_payment_id     payment.payment_id%TYPE := 1;
  v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'MobileApp')
                                                                   ,t_payment_detail(2
                                                                                    ,'95.165.24.178')
                                                                   ,t_payment_detail(3
                                                                                    ,'Платеж через браузер Chrome'));
  v_summa          NUMBER(30, 2) := 20000;
  v_currency_id    NUMBER(3) := 643;
  v_from_client_id NUMBER(30) := 1;
  v_to_client_id   NUMBER(30) := 4;
BEGIN

  IF v_payment_detail IS NOT empty
  THEN
    FOR i IN v_payment_detail.first .. v_payment_detail.last
    LOOP
      IF (v_payment_detail(i).field_id IS NULL)
      THEN
        dbms_output.put_line('ID поля не может быть пустым');
      END IF;
    
      IF (v_payment_detail(i).field_value IS NULL)
      THEN
        dbms_output.put_line('Значение в поле не может быть пустым');
      END IF;
    
      dbms_output.put_line('ID: ' || v_payment_detail(i).field_id || '. Value: ' || v_payment_detail(i).field_value);
    END LOOP;
  ELSE
    dbms_output.put_line('Коллекция не содержит данных');
  END IF;

  dbms_output.put_line(l_msg || 'Статус: ' || c_created || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));

  --Создание платежа

  INSERT INTO payment
    (payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id)
  VALUES
    (payment_seq.nextval, systimestamp, v_summa, v_currency_id, v_from_client_id, v_to_client_id)
  RETURNING payment_id INTO v_payment_id;

  dbms_output.put_line('Payment_id of new payment: ' || v_payment_id);

  --Добавление данных по платежу

  INSERT INTO payment_detail
    (payment_id, field_id, field_value)
    SELECT v_payment_id
          ,VALUE       (t).field_id
          ,VALUE       (t).field_value
      FROM TABLE(v_payment_detail) t;

END;
/

---- Пример 2: Сброс платежа в "ошибочный статус" с указанием причины
DECLARE
  c_error CONSTANT payment.status%TYPE := 2;
  v_reason        payment.status_change_reason%TYPE := 'недостаточно средств';
  l_msg           VARCHAR2(100) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
  v_current_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.payment_id%TYPE := 1;
BEGIN

  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;

  IF v_reason IS NULL
  THEN
    dbms_output.put_line('Причина не может быть пустой');
  END IF;

  dbms_output.put_line(l_msg || ' Статус: ' || c_error || '. Причина: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));

  /*  
    2) В блоках сброс, отмена, успешное проведение платежа добавьте UPDATE таблицы payment.
  Используйте соответствующие константы статусов и “причину” (если есть) для обновлений.
  Обновление возможно только, если статус у платежа “0” - “создан”.*/

  -- Обновление платежа
  UPDATE payment p
     SET p.status               = c_status_2
        ,p.status_change_reason = v_reason
   WHERE p.payment_id = v_payment_id
     AND p.status = 0;

END;
/

---- Пример 3: Отмена платежа из-за ошибки пользователя
DECLARE
  c_cancel CONSTANT payment.status%TYPE := 3;
  v_reason        payment.status_change_reason%TYPE := 'ошибка пользователя';
  l_msg           VARCHAR2(100) := 'Отмена платежа с указанием причины.';
  v_current_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.payment_id%TYPE := 1;

BEGIN

  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;

  dbms_output.put_line(l_msg || ' Статус: ' || c_cancel || '. Причина: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
  
    -- Обновление платежа
  UPDATE payment p
     SET p.status               = c_status_3
        ,p.status_change_reason = v_reason
   WHERE p.payment_id = v_payment_id
     AND p.status = 0;
END;
/

---- Пример 4: Успешное завершение платежа
DECLARE
  c_success CONSTANT payment.status%TYPE := 1;
  l_msg           VARCHAR2(100) := 'Успешное завершение платежа.';
  v_current_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.payment_id%TYPE := 1;
BEGIN

  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line(l_msg || ' Статус: ' || c_success || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));

  -- Обновление платежа
  UPDATE payment p
     SET p.status = c_status_1
   WHERE p.payment_id = v_payment_id
     AND p.status = 0;
END;
/

---- Пример 5: Добавление или обновление платежа по списку id_поля/значение
DECLARE
  l_msg            VARCHAR2(200) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
  v_current_dtime  DATE := SYSDATE;
  v_payment_id     payment.payment_id%TYPE := 1;
  v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(2
                                                                                    ,'178.234.89.201')
                                                                   ,t_payment_detail(4
                                                                                    ,'Проверен 2024-03-15T14:22:41, риск 0.02%'));
BEGIN

  IF v_payment_detail IS NOT empty
  THEN
    FOR i IN v_payment_detail.first .. v_payment_detail.last
    LOOP
      IF (v_payment_detail(i).field_id IS NULL)
      THEN
        dbms_output.put_line('ID поля не может быть пустым');
      END IF;
    
      IF (v_payment_detail(i).field_value IS NULL)
      THEN
        dbms_output.put_line('Значение в поле не может быть пустым');
      END IF;
    
      dbms_output.put_line('ID: ' || v_payment_detail(i).field_id || '. Value: ' || v_payment_detail(i).field_value);
    END LOOP;
  ELSE
    dbms_output.put_line('Коллекция не содержит данных');
  END IF;

  dbms_output.put_line(l_msg || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss'));

  -- вставка и обновление данных
  MERGE INTO payment_detail p
  USING (SELECT v_payment_id payment_id
               ,VALUE       (t).field_id        field_id
               ,VALUE       (t).field_value        field_value
           FROM TABLE(v_payment_detail) t) n
  ON (p.payment_id = n.payment_id AND p.field_id = n.field_id)
  WHEN MATCHED THEN
    UPDATE SET p.field_value = n.field_value
  WHEN NOT MATCHED THEN
    INSERT (payment_id, field_id, field_value) VALUES (n.payment_id, n.field_id, n.field_value);
END;
/

---- Пример 6: Удаление платежа по списку id_полей
DECLARE
  l_msg              VARCHAR2(100) := 'Детали платежа удалены по списку id_полей';
  v_current_dtime    DATE := SYSDATE;
  v_payment_id       payment.payment_id%TYPE := 1;
  v_delete_field_ids t_number_array := t_number_array(2, 3);
BEGIN

  IF v_delete_field_ids IS NOT empty
  THEN
    dbms_output.put_line('Коллекция не содержит данных');
  END IF;

  dbms_output.put_line(l_msg || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss'));
  dbms_output.put_line('Количесвто удаленных полей: ' || v_delete_field_ids.count());

  DELETE payment_detail d
   WHERE d.payment_id = v_payment_id
     AND d.field_id IN (SELECT VALUE(t) FROM TABLE(v_delete_field_ids) t);
END;
/
