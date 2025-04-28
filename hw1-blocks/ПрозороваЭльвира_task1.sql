/*
Автор: Прозорова Эльвира
Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
*/
---- Пример 1: Создание платежа
DECLARE
  c_status        payment.status%TYPE := 0;
  l_msg           VARCHAR2(50) := 'Платеж создан. ';
  v_current_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.payment_id%TYPE := 1;
BEGIN
  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line(l_msg || 'Статус: ' || c_status || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
END;
/

---- Пример 2: Сброс платежа в "ошибочный статус" с указанием причины
DECLARE
  c_status        payment.status%TYPE := 2;
  v_reason        payment.status_change_reason%TYPE := 'недостаточно средств';
  l_msg           VARCHAR2(100) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
  v_current_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.status%TYPE := 1;
BEGIN
  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  
    IF v_reason IS NULL
  THEN
    dbms_output.put_line('Причина не может быть пустой');
  END IF;
  
  dbms_output.put_line(l_msg || ' Статус: ' || c_status || '. Причина: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
END;
/

---- Пример 3: Отмена платежа из-за ошибки пользователя
DECLARE
  c_status        payment.status%TYPE := 3;
  v_reason        VARCHAR2(200 CHAR) := 'ошибка пользователя';
  l_msg           VARCHAR2(100) := 'Отмена платежа с указанием причины.';
  v_current_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.status%TYPE := 1;
BEGIN
  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  
  dbms_output.put_line(l_msg || ' Статус: ' || c_status || '. Причина: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
END;
/

---- Пример 4: Успешное завершение платежа
DECLARE
  c_status        payment.status%TYPE := 1;
  l_msg           VARCHAR2(100) := 'Успешное завершение платежа.';
  v_current_dtime TIMESTAMP := systimestamp;
  v_payment_id    payment.status%TYPE := 1;
BEGIN
  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line(l_msg || ' Статус: ' || c_status || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
END;
/

---- Пример 5: Добавление или обновление платежа по списку id_поля/значение
DECLARE
  l_msg           VARCHAR2(200) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
  v_current_dtime DATE := SYSDATE;
  v_payment_id    payment.status%TYPE := 1;
BEGIN
  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line(l_msg || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss'));
END;
/

---- Пример 6: Удаление платежа по списку id_полей
DECLARE
  l_msg           VARCHAR2(100) := 'Детали платежа удалены по списку id_полей';
  v_current_dtime DATE := SYSDATE;
  v_payment_id    payment.status%TYPE := 1;
BEGIN
  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line('Детали платежа удалены по списку id_полей' || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss'));
END;
/
