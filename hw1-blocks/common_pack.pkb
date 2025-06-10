CREATE OR REPLACE PACKAGE BODY common_pack IS

  g_enabled_manual_changes BOOLEAN := FALSE;
  -- ���������/���������� ���������� ������ ������� ������ ��������
  PROCEDURE enable_manual_changes IS
  BEGIN
    g_enabled_manual_changes := TRUE;
  END;

  PROCEDURE disable_manual_changes IS
  BEGIN
    g_enabled_manual_changes := FALSE;
  END;

  --��������� �� ������ ��������� �� ���������� ������
  FUNCTION is_manual_changes_allowed RETURN BOOLEAN IS
  BEGIN
    RETURN g_enabled_manual_changes;
  END;

END common_pack;
/
