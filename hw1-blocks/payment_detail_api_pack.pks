CREATE OR REPLACE PACKAGE payment_detail_api_pack IS
  /*﻿
  Автор: Прозорова Эльвира
  Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
  */

  c_msg_id_field_empty   CONSTANT VARCHAR2(100) := 'ID поля не может быть пустым';
  c_msg_value_not_empty  CONSTANT VARCHAR2(100) := 'Значение в поле не может быть пустым';
  c_msg_collection_empty CONSTANT VARCHAR2(100) := 'Коллекция не содержит данных';

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