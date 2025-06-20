CREATE OR REPLACE PACKAGE payment_detail_api_pack IS
  /*﻿
  Автор: Прозорова Эльвира
  Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
  */

  c_msg_id_field_empty   CONSTANT VARCHAR2(100) := 'ID поля не может быть пустым';
  c_msg_value_not_empty  CONSTANT VARCHAR2(100) := 'Значение в поле не может быть пустым';
  c_msg_collection_empty CONSTANT VARCHAR2(100) := 'Коллекция не содержит данных';

  --Коды ошибок
  c_error_code_invalid_input_parameter CONSTANT NUMBER(10) := -20101;

  -- Объекты исключений
  e_invalid_input_parameter EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_invalid_input_parameter, c_error_code_invalid_input_parameter);

  PROCEDURE insert_or_update_payment_detail
  (
    p_payment_id     payment.payment_id%TYPE
   ,p_payment_detail t_payment_detail_array
  );

  PROCEDURE delete_payment_detail
  (
    p_payment_id       payment.payment_id%TYPE
   ,p_delete_field_ids t_number_array
  );
END payment_detail_api_pack;
/