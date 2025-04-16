---- Пример 1
BEGIN
  dbms_output.put_line('Платеж создан. Статус: 0');
END;
/

---- Пример 2
DECLARE
l_status NUMBER := 2;
l_reason VARCHAR2(50) := 'недостаточно средств';
BEGIN
  dbms_output.put_line('Сброс платежа в "ошибочный статус" с указанием причины. Статус: ' || l_status || '. Причина: ' || l_reason);
END;
/

---- Пример 3
DECLARE
l_status NUMBER := 3;
l_reason VARCHAR2(50) := 'ошибка пользователя';
l_result NUMBER;
BEGIN
  dbms_output.put_line('Отмена платежа с указанием причины. Статус: ' || l_status || '. Причина: ' || l_reason);
  l_result := 10 / 0;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Ошибка при отмене платежа: ' || SQLERRM);
END;
/

---- Пример 4
DECLARE
l_status NUMBER := 1;
BEGIN
  dbms_output.put_line('Успешное завершение платежа. Статус: ' || l_status);
END;
/

---- Пример 5
BEGIN
  dbms_output.put_line('Данные платежа добавлены или обновлены по списку id_поля/значение');
END;
/

---- Пример 6
BEGIN
  dbms_output.put_line('Детали платежа удалены по списку id_полей');
END;
/
