--Create payment
DECLARE
  v_payment_id   payment.payment_id%TYPE;
  v_detail_array t_payment_detail_array := t_payment_detail_array();
BEGIN
  v_payment_id := payment_api_pack.create_payment(p_payment_detail => v_detail_array
                                                 ,p_summa          => 1000
                                                 ,p_currency_id    => 1
                                                 ,p_from_client_id => 101
                                                 ,p_to_client_id   => 202);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Создание клиента. Исключение возбуждено успешно. Ошибка: ' || SQLERRM);
END;
/

DECLARE
  v_payment_id   payment.payment_id%TYPE;
  v_detail_array t_payment_detail_array := t_payment_detail_array(t_payment_detail(NULL, 'Тест'));
BEGIN
  v_payment_id := payment_api_pack.create_payment(p_payment_detail => v_detail_array
                                                 ,p_summa          => 1000
                                                 ,p_currency_id    => 1
                                                 ,p_from_client_id => 101
                                                 ,p_to_client_id   => 202);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Создание клиента: Пустое ID поля. Ошибка: ' || SQLERRM);
END;
/

DECLARE
  v_payment_id   payment.payment_id%TYPE;
  v_detail_array t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, NULL));
BEGIN
  v_payment_id := payment_api_pack.create_payment(p_payment_detail => v_detail_array
                                                 ,p_summa          => 1000
                                                 ,p_currency_id    => 1
                                                 ,p_from_client_id => 101
                                                 ,p_to_client_id   => 202);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Создание клиента: Пустое значение ID поля. Ошибка: ' || SQLERRM);
END;
/

BEGIN
  payment_api_pack.fail_payment(p_payment_id => NULL, p_reason => 'Причина тест');
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Ошибка платежа: Пустое ID объекта. Ошибка: ' || SQLERRM);
END;
/

BEGIN
  payment_api_pack.fail_payment(p_payment_id => 1, p_reason => NULL);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Ошибка платежа: Пустая причина. Ошибка: ' || SQLERRM);
END;
/

BEGIN
  payment_api_pack.cancel_payment(p_payment_id => NULL, p_reason => 'Тест причина');
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Отмена платежа: пустой ID. Ошибка: ' || SQLERRM);
END;
/

BEGIN
  payment_api_pack.successful_finish_payment(p_payment_id => NULL);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Успех платежа: Пустой ID. Ошибка: ' || SQLERRM);
END;
/
---Detail payment
DECLARE
  v_payment_id   payment.payment_id%TYPE := 1;
  v_detail_array t_payment_detail_array := t_payment_detail_array(t_payment_detail(NULL, 'Тест'));
BEGIN
  payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id     => v_payment_id
                                                         ,p_payment_detail => v_detail_array);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_detail_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Insert/Update Payment Detail: ID пустой. Ошибка: ' ||
                         SQLERRM);
END;
/

DECLARE
  v_payment_id   payment.payment_id%TYPE := 1;
  v_detail_array t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, NULL));
BEGIN
  payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id     => v_payment_id
                                                         ,p_payment_detail => v_detail_array);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_detail_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Insert/Update Payment Detail: Значение пустое. Ошибка: ' || SQLERRM);
END;
/

DECLARE
  v_payment_id payment.payment_id%TYPE := 1;
  v_field_ids  t_number_array := t_number_array();
BEGIN
  payment_detail_api_pack.delete_payment_detail(p_payment_id       => v_payment_id
                                               ,p_delete_field_ids => v_field_ids);
  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
EXCEPTION
  WHEN payment_detail_api_pack.e_invalid_input_parameter THEN
    dbms_output.put_line('Delete Payment Detail: Коллекция пустая. Ошибка: ' || SQLERRM);
END;
/
