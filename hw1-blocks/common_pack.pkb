CREATE OR REPLACE PACKAGE BODY common_pack IS

  g_enabled_manual_changes BOOLEAN := FALSE;
  -- Включение/отключения разрешения менять вручную данные объектов
  PROCEDURE enable_manual_changes IS
  BEGIN
    g_enabled_manual_changes := TRUE;
  END;

  PROCEDURE disable_manual_changes IS
  BEGIN
    g_enabled_manual_changes := FALSE;
  END;

  --Разрешены ли ручные изменения на глобальном уровне
  FUNCTION is_manual_changes_allowed RETURN BOOLEAN IS
  BEGIN
    RETURN g_enabled_manual_changes;
  END;

END common_pack;
/
