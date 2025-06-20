CREATE OR REPLACE PACKAGE common_pack IS

  -- Author  : USER
  -- Created : 10.06.2025 21:07:13
  -- Purpose : ����� �������

  -- ������� �������
  c_status_created CONSTANT payment.status%TYPE := 0;
  c_status_success CONSTANT payment.status%TYPE := 1;
  c_status_error   CONSTANT payment.status%TYPE := 2;
  c_status_cancel  CONSTANT payment.status%TYPE := 3;

  c_msg_id_empty         CONSTANT VARCHAR2(100) := 'ID ������� �� ����� ���� ������';
  c_msg_id_field_empty   CONSTANT VARCHAR2(100) := 'ID ���� �� ����� ���� ������';
  c_msg_reason_empty     CONSTANT VARCHAR2(100) := '������� �� ����� ���� ������';
  c_msg_value_not_empty  CONSTANT VARCHAR2(100) := '�������� � ���� �� ����� ���� ������';
  c_msg_collection_empty CONSTANT VARCHAR2(100) := '��������� �� �������� ������';
  c_msg_delete_forbidden CONSTANT VARCHAR2(100) := '�������� ������� ���������';
  c_msg_manual_changes   CONSTANT VARCHAR2(100) := '��������� ������ ����������� ������ ����� API';

  --���� ������
  c_error_code_invalid_input_parameter CONSTANT NUMBER(10) := -20101;
  c_error_code_delete_forbidden        CONSTANT NUMBER(10) := -20102;
  c_error_code_manual_changes          CONSTANT NUMBER(10) := -20103;

  -- ������� ����������
  e_invalid_input_parameter EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  e_delete_forbidden EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_delete_forbidden, c_error_code_delete_forbidden);
  e_manual_changes EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_manual_changes, c_error_code_manual_changes);

  -- ���������/���������� ���������� ������ ������� ������ ��������
  PROCEDURE enable_manual_changes;
  PROCEDURE disable_manual_changes;

  --��������� �� ������ ��������� �� ���������� ������
  FUNCTION is_manual_changes_allowed RETURN BOOLEAN;

END common_pack;
/