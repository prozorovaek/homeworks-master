CREATE OR REPLACE PACKAGE common_pack IS

  -- Author  : USER
  -- Created : 10.06.2025 21:07:13
  -- Purpose : Общие объекты

  c_msg_id_empty         CONSTANT VARCHAR2(100) := 'ID объекта не может быть пустым';
  c_msg_id_field_empty   CONSTANT VARCHAR2(100) := 'ID поля не может быть пустым';
  c_msg_reason_empty     CONSTANT VARCHAR2(100) := 'Причина не может быть пустой';
  c_msg_value_not_empty  CONSTANT VARCHAR2(100) := 'Значение в поле не может быть пустым';
  c_msg_collection_empty CONSTANT VARCHAR2(100) := 'Коллекция не содержит данных';
  c_msg_delete_forbidden CONSTANT VARCHAR2(100) := 'Удаление объекта запрещено';
  c_msg_manual_changes   CONSTANT VARCHAR2(100) := 'Изменения должны выполняться только через API';
  c_msg_final_status     CONSTANT VARCHAR2(100) := 'Объект в конечном статусе. Изменения невозможны';
  c_msg_object_no_found  CONSTANT VARCHAR2(100) := 'Объект не найден';
  c_msg_object_blocked   CONSTANT VARCHAR2(100) := 'Объект уже заблокирован';

  --Коды ошибок
  c_error_code_invalid_input_parameter CONSTANT NUMBER(10) := -20101;
  c_error_code_delete_forbidden        CONSTANT NUMBER(10) := -20102;
  c_error_code_manual_changes          CONSTANT NUMBER(10) := -20103;
  c_error_code_final_status            CONSTANT NUMBER(10) := -20104;
  c_error_code_object_no_found         CONSTANT NUMBER(10) := -20105;
  c_error_code_object_blocked          CONSTANT NUMBER(10) := -20106;

  -- Объекты исключений
  e_invalid_input_parameter EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  e_delete_forbidden EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_delete_forbidden, c_error_code_delete_forbidden);
  e_manual_changes EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_manual_changes, c_error_code_manual_changes);
  e_final_status EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_final_status, c_error_code_final_status);
  e_object_no_found EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_object_no_found, c_error_code_object_no_found);
  e_row_locked EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_row_locked, -00054);
  e_object_blocked EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_object_blocked, c_error_code_object_blocked);

  -- Включение/отключения разрешения менять вручную данные объектов
  PROCEDURE enable_manual_changes;
  PROCEDURE disable_manual_changes;

  --Разрешены ли ручные изменения на глобальном уровне
  FUNCTION is_manual_changes_allowed RETURN BOOLEAN;

END common_pack;
/
