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
BEGIN

  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line(l_msg || 'Статус: ' || c_created || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
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
  l_msg              VARCHAR2(100) := 'Детали платежа удалены по списку id_полей';
  v_current_dtime    DATE := SYSDATE;
  v_payment_id       payment.payment_id%TYPE := 1;
  v_delete_field_ids t_number_array := t_number_array(2, 3);
BEGIN
  IF v_payment_id IS NULL
  THEN
    dbms_output.put_line('ID объекта не может быть пустым');
  END IF;
  dbms_output.put_line(l_msg || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_dtime, 'dd.mm.yyyy hh24:mi:ss'));
END;
/
