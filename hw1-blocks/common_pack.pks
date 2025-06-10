CREATE OR REPLACE PACKAGE common_pack IS

  -- Author  : USER
  -- Created : 10.06.2025 21:07:13
  -- Purpose : Общие объекты

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

  -- Включение/отключения разрешения менять вручную данные объектов
  PROCEDURE enable_manual_changes;
  PROCEDURE disable_manual_changes;

  --Разрешены ли ручные изменения на глобальном уровне
  FUNCTION is_manual_changes_allowed RETURN BOOLEAN;

END common_pack;
/