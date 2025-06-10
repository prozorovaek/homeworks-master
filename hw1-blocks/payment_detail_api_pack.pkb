CREATE OR REPLACE PACKAGE BODY payment_detail_api_pack IS
  g_is_api BOOLEAN := FALSE; -- признак, выполняется ли изменение через API

  --разрешение менять данные
  PROCEDURE allow_changes IS
  BEGIN
    g_is_api := TRUE;
  END;
  --запрет менять данные
  PROCEDURE disallow_changes IS
  BEGIN
    g_is_api := FALSE;
  END;

  PROCEDURE insert_or_update_payment_detail
  (
    p_payment_id     payment.payment_id%TYPE
   ,p_payment_detail t_payment_detail_array
  ) IS
  BEGIN
    IF p_payment_detail IS NOT empty
    THEN
      FOR i IN p_payment_detail.first .. p_payment_detail.last
      LOOP
        IF p_payment_detail(i).field_id IS NULL
        THEN
          raise_application_error(common_pack.c_error_code_invalid_input_parameter
                                 ,common_pack.c_msg_id_field_empty);
        END IF;
        IF p_payment_detail(i).field_value IS NULL
        THEN
          raise_application_error(common_pack.c_error_code_invalid_input_parameter
                                 ,common_pack.c_msg_value_not_empty);
        END IF;
      END LOOP;
    ELSE
      raise_application_error(common_pack.c_error_code_invalid_input_parameter
                             ,common_pack.c_msg_value_not_empty);
    END IF;
  
    allow_changes();
  
    MERGE INTO payment_detail p
    USING (SELECT p_payment_id payment_id
                 ,VALUE       (t).field_id        field_id
                 ,VALUE       (t).field_value        field_value
             FROM TABLE(p_payment_detail) t) n
    ON (p.payment_id = n.payment_id AND p.field_id = n.field_id)
    WHEN MATCHED THEN
      UPDATE SET p.field_value = n.field_value
    WHEN NOT MATCHED THEN
      INSERT (payment_id, field_id, field_value) VALUES (n.payment_id, n.field_id, n.field_value);
  
    disallow_changes();
  
  EXCEPTION
    WHEN OTHERS THEN
      disallow_changes();
      RAISE;
    
  END;

  PROCEDURE delete_payment_detail
  (
    p_payment_id       payment.payment_id%TYPE
   ,p_delete_field_ids t_number_array
  ) IS
  BEGIN
    IF p_delete_field_ids IS empty
    THEN
      raise_application_error(common_pack.c_error_code_invalid_input_parameter
                             ,common_pack.c_msg_collection_empty);
    END IF;
  
    allow_changes();
  
    DELETE FROM payment_detail
     WHERE payment_id = p_payment_id
       AND field_id IN (SELECT VALUE(t) FROM TABLE(p_delete_field_ids) t);
  
    disallow_changes();
  
  EXCEPTION
    WHEN OTHERS THEN
      disallow_changes();
      RAISE;
  END;

  PROCEDURE is_changes_through_api IS
  BEGIN
    IF NOT g_is_api
       AND NOT common_pack.is_manual_changes_allowed()
    THEN
      raise_application_error(common_pack.c_error_code_manual_changes
                             ,common_pack.c_msg_manual_changes);
    END IF;
  
  END;
END payment_detail_api_pack;
/