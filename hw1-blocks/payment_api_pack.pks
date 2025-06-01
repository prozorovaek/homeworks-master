CREATE OR REPLACE PACKAGE payment_api_pack IS

  /*﻿
  Автор: Прозорова Эльвира
  Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
  */
  -- Статусы платежа
  c_status_created CONSTANT payment.status%TYPE := 0;
  c_status_success CONSTANT payment.status%TYPE := 1;
  c_status_error   CONSTANT payment.status%TYPE := 2;
  c_status_cancel  CONSTANT payment.status%TYPE := 3;

  c_msg_id_empty         CONSTANT VARCHAR2(100) := 'ID объекта не может быть пустым';
  c_msg_id_field_empty   CONSTANT VARCHAR2(100) := 'ID поля не может быть пустым';
  c_msg_reason_empty     CONSTANT VARCHAR2(100) := 'Причина не может быть пустой';
  c_msg_value_not_empty  CONSTANT VARCHAR2(100) := 'Значение в поле не может быть пустым';
  c_msg_collection_empty CONSTANT VARCHAR2(100) := 'Коллекция не содержит данных';
  c_msg_delete_forbidden CONSTANT VARCHAR2(100) := 'Удаление объекта запрещено';
  c_msg_manual_changes   CONSTANT VARCHAR2(100) := 'Изменения должны выполняться только через API';

  --Коды ошибок
  c_error_code_invalid_input_parameter CONSTANT NUMBER(10) := -20101;
  c_error_code_delete_forbidden        CONSTANT NUMBER(10) := -20102;
  c_error_code_manual_changes          CONSTANT NUMBER(10) := -20103;

  -- Объекты исключений
  e_invalid_input_parameter EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  e_delete_forbidden EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_delete_forbidden, c_error_code_delete_forbidden);
  e_manual_changes EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_manual_changes, c_error_code_manual_changes);

  -- Создание платежа
  FUNCTION create_payment
  (
    p_payment_detail t_payment_detail_array
   ,p_summa          NUMBER
   ,p_currency_id    NUMBER
   ,p_from_client_id NUMBER
   ,p_to_client_id   NUMBER
  ) RETURN payment.payment_id%TYPE;

  -- Сброс платежа в "ошибочный статус" с указанием причины
  PROCEDURE fail_payment
  (
    p_payment_id payment.payment_id%TYPE
   ,p_reason     payment.status_change_reason%TYPE
  );

  -- Отмена платежа из-за ошибки пользователя
  PROCEDURE cancel_payment
  (
    p_payment_id payment.payment_id%TYPE
   ,p_reason     payment.status_change_reason%TYPE
  );

  -- Успешное завершение платежа
  PROCEDURE successful_finish_payment(p_payment_id payment.payment_id%TYPE);

  --Проверка, вызываемая из триггера
  PROCEDURE is_changes_through_api;

END payment_api_pack;
/