/*﻿
Автор: Прозорова Эльвира
Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
*/
---- Пример 1: Создание платежа

CREATE OR REPLACE FUNCTION create_payment
(
  p_payment_detail t_payment_detail_array
 ,p_summa          NUMBER
 ,p_currency_id    NUMBER
 ,p_from_client_id NUMBER
 ,p_to_client_id   NUMBER
) RETURN payment.payment_id%TYPE IS
  c_created CONSTANT payment.status%TYPE := 0;
  l_msg           VARCHAR2(50) := 'Платеж создан. ';
  p_create_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.payment_id%TYPE;
BEGIN
  IF p_payment_detail IS NOT empty
  THEN
    FOR i IN p_payment_detail.first .. p_payment_detail.last
    LOOP
      IF p_payment_detail(i).field_id IS NULL
      THEN
        dbms_output.put_line('ID поля не может быть пустым');
      END IF;
    
      IF p_payment_detail(i).field_value IS NULL
      THEN
        dbms_output.put_line('Значение в поле не может быть пустым');
      END IF;
    
      dbms_output.put_line('ID: ' || p_payment_detail(i).field_id || '. Value: ' || p_payment_detail(i).field_value);
    END LOOP;
  ELSE
    dbms_output.put_line('Коллекция не содержит данных');
  END IF;

  dbms_output.put_line(l_msg || 'Статус: ' || c_created);
  dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));

  -- Создание платежа
  INSERT INTO payment
    (payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id)
  VALUES
    (payment_seq.nextval, p_create_dtime, p_summa, p_currency_id, p_from_client_id, p_to_client_id)
  RETURNING payment_id INTO v_payment_id;

  dbms_output.put_line('Payment_id of new payment: ' || v_payment_id);

  -- Добавление данных по платежу
  INSERT INTO payment_detail
    (payment_id, field_id, field_value)
    SELECT v_payment_id
          ,VALUE       (t).field_id
          ,VALUE       (t).field_value
      FROM TABLE(p_payment_detail) t;

  RETURN v_payment_id;
END;
/

---- Пример 2: Сброс платежа в "ошибочный статус" с указанием причины
CREATE OR REPLACE PROCEDURE fail_payment
(
  p_payment_id payment.payment_id%TYPE
 ,p_reason     payment.status_change_reason%TYPE
) IS
  c_error CONSTANT payment.status%TYPE := 2;
  l_msg           VARCHAR2(100) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
  p_create_dtime TIMESTAMP := systimestamp;

BEGIN

  IF p_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;

  IF p_reason IS NULL
  THEN
    dbms_output.put_line('Причина не может быть пустой');
  END IF;

  dbms_output.put_line(l_msg || ' Статус: ' || c_error || '. Причина: ' || p_reason || '. ID: ' ||
                       p_payment_id);
  dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));

  -- Обновление платежа
  UPDATE payment p
     SET p.status               = c_error
        ,p.status_change_reason = p_reason
   WHERE p.payment_id = p_payment_id
     AND p.status = 0;

END;
/

  ---- Пример 3: Отмена платежа из-за ошибки пользователя
CREATE OR REPLACE PROCEDURE cancel_payment
(
  p_payment_id payment.payment_id%TYPE
 ,p_reason     payment.status_change_reason%TYPE
) IS
  c_cancel CONSTANT payment.status%TYPE := 3;
  l_msg           VARCHAR2(100) := 'Отмена платежа с указанием причины.';
  p_create_dtime TIMESTAMP := systimestamp;

BEGIN

  IF p_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;

  dbms_output.put_line(l_msg || ' Статус: ' || c_cancel || '. Причина: ' || p_reason || '. ID: ' ||
                       p_payment_id);
  dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));

  -- Обновление платежа
  UPDATE payment p
     SET p.status               = c_cancel
        ,p.status_change_reason = p_reason
   WHERE p.payment_id = p_payment_id
     AND p.status = 0;
END;
/

---- Пример 4: Успешное завершение платежа
CREATE OR REPLACE PROCEDURE successful_finish_payment(p_payment_id payment.payment_id%TYPE) IS
  c_success CONSTANT payment.status%TYPE := 1;
  l_msg           VARCHAR2(100) := 'Успешное завершение платежа.';
  p_create_dtime TIMESTAMP := systimestamp;
BEGIN

  IF p_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line(l_msg || ' Статус: ' || c_success || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));

  -- Обновление платежа
  UPDATE payment p
     SET p.status               = c_success
        ,p.status_change_reason = l_msg
   WHERE p.payment_id = p_payment_id
     AND p.status = 0;
END;
/

---- Пример 5: Добавление или обновление платежа по списку id_поля/значение
CREATE OR REPLACE PROCEDURE insert_or_update_payment_detail
(
  p_payment_id     payment.payment_id%TYPE
 ,p_payment_detail t_payment_detail_array
) IS
  l_msg           VARCHAR2(200) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
  p_create_dtime DATE := SYSDATE;

BEGIN

  IF p_payment_detail IS NOT empty
  THEN
    FOR i IN p_payment_detail.first .. p_payment_detail.last
    LOOP
      IF (p_payment_detail(i).field_id IS NULL)
      THEN
        dbms_output.put_line('ID поля не может быть пустым');
      END IF;
    
      IF (p_payment_detail(i).field_value IS NULL)
      THEN
        dbms_output.put_line('Значение в поле не может быть пустым');
      END IF;
    
      dbms_output.put_line('ID: ' || p_payment_detail(i).field_id || '. Value: ' || p_payment_detail(i).field_value);
    END LOOP;
  ELSE
    dbms_output.put_line('Коллекция не содержит данных');
  END IF;

  dbms_output.put_line(l_msg || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss'));

  -- вставка и обновление данных
  MERGE INTO payment_detail p
  USING (SELECT p_payment_id payment_id
               ,VALUE       (t).field_id        field_id
               ,VALUE       (t).field_value        field_value
           FROM TABLE(p_payment_detail) t) n
  ON (p.payment_id = n.payment_id AND p.field_id = n.field_id)
  WHEN MATCHED THEN
    UPDATE SET p.field_value = n.field_value
  WHEN NOT MATCHED THEN
    INSERT (payment_id, field_id, field_value) VALUES (n.payment_id, n.field_id, n.field_value);
END;
/

---- Пример 6: Удаление платежа по списку id_полей
CREATE OR REPLACE PROCEDURE delete_payment_detail
(
  p_payment_id       payment.payment_id%TYPE
 ,p_delete_field_ids t_number_array
) IS
  l_msg           VARCHAR2(100) := 'Детали платежа удалены по списку id_полей';
  p_create_dtime DATE := SYSDATE;

BEGIN

  IF p_delete_field_ids IS NOT empty
  THEN
    dbms_output.put_line('Коллекция не содержит данных');
  END IF;

  dbms_output.put_line(l_msg || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss'));
  dbms_output.put_line('Количесвто удаленных полей: ' || p_delete_field_ids.count());

  DELETE payment_detail d
   WHERE d.payment_id = p_payment_id
     AND d.field_id IN (SELECT VALUE(t) FROM TABLE(p_delete_field_ids) t);
END;
/
