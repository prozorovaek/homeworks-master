CREATE OR REPLACE PACKAGE payment_detail_api_pack IS
  /*﻿
  Автор: Прозорова Эльвира
  Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
  */

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

  --Проверка, вызываемая из триггера
  PROCEDURE is_changes_through_api;
END payment_detail_api_pack;
/