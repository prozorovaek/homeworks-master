
CREATE OR REPLACE PACKAGE BODY payment_api_pack IS
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

  FUNCTION create_payment
  (
    p_payment_detail t_payment_detail_array
   ,p_summa          NUMBER
   ,p_currency_id    NUMBER
   ,p_from_client_id NUMBER
   ,p_to_client_id   NUMBER
  ) RETURN payment.payment_id%TYPE IS
    p_create_dtime TIMESTAMP := systimestamp;
    v_payment_id   payment.payment_id%TYPE;
  BEGIN
  
    allow_changes();
  
    INSERT INTO payment
      (payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id)
    VALUES
      (payment_seq.nextval, p_create_dtime, p_summa, p_currency_id, p_from_client_id, p_to_client_id)
    RETURNING payment_id INTO v_payment_id;
  
    payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id     => v_payment_id
                                                           ,p_payment_detail => p_payment_detail);
  
    disallow_changes();
  
    RETURN v_payment_id;
  EXCEPTION
    WHEN OTHERS THEN
      disallow_changes();
      RAISE;
  END;

  PROCEDURE fail_payment
  (
    p_payment_id payment.payment_id%TYPE
   ,p_reason     payment.status_change_reason%TYPE
  ) IS
  BEGIN
    IF p_payment_id IS NULL
    THEN
      raise_application_error(common_pack.c_error_code_invalid_input_parameter
                             ,common_pack.c_msg_id_empty);
    END IF;
    IF p_reason IS NULL
    THEN
      raise_application_error(common_pack.c_error_code_invalid_input_parameter
                             ,common_pack.c_msg_reason_empty);
    END IF;
  
    try_lock_payment(p_payment_id); -- пытаемся заблокировать клиента
  
    allow_changes();
  
    UPDATE payment
       SET status               = c_status_error
          ,status_change_reason = p_reason
     WHERE payment_id = p_payment_id
       AND status = c_status_created;
  
    disallow_changes();
  
  EXCEPTION
    WHEN OTHERS THEN
      disallow_changes();
      RAISE;
  END;

  PROCEDURE cancel_payment
  (
    p_payment_id payment.payment_id%TYPE
   ,p_reason     payment.status_change_reason%TYPE
  ) IS
  BEGIN
    IF p_payment_id IS NULL
    THEN
      raise_application_error(common_pack.c_error_code_invalid_input_parameter
                             ,common_pack.c_msg_id_empty);
    END IF;
  
    try_lock_payment(p_payment_id); -- пытаемся заблокировать клиента
  
    allow_changes();
  
    UPDATE payment
       SET status               = c_status_cancel
          ,status_change_reason = p_reason
     WHERE payment_id = p_payment_id
       AND status = c_status_created;
  
    disallow_changes();
  
  EXCEPTION
    WHEN OTHERS THEN
      disallow_changes();
      RAISE;
  END;

  PROCEDURE successful_finish_payment(p_payment_id payment.payment_id%TYPE) IS
    l_msg VARCHAR2(100) := 'Успешное завершение платежа.';
  BEGIN
    IF p_payment_id IS NULL
    THEN
      raise_application_error(common_pack.c_error_code_invalid_input_parameter
                             ,common_pack.c_msg_id_empty);
    END IF;
  
    try_lock_payment(p_payment_id); -- пытаемся заблокировать клиента
  
    allow_changes();
  
    UPDATE payment
       SET status               = c_status_success
          ,status_change_reason = l_msg
     WHERE payment_id = p_payment_id
       AND status = c_status_created;
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

  PROCEDURE check_client_delete_restriction IS
  BEGIN
    IF NOT common_pack.is_manual_changes_allowed()
    THEN
      raise_application_error(common_pack.c_error_code_delete_forbidden
                             ,common_pack.c_msg_delete_forbidden);
    END IF;
  END;

  PROCEDURE try_lock_payment(p_payment_id payment.payment_id%TYPE) IS
    v_status payment.status%TYPE;
  BEGIN
    SELECT status INTO v_status FROM payment t WHERE t.payment_id = p_payment_id FOR UPDATE NOWAIT;
  
    IF v_status = c_status_success
    THEN
      raise_application_error(common_pack.c_error_code_final_status, common_pack.c_msg_final_status);
    END IF;
  
  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(common_pack.c_error_code_object_no_found
                             ,common_pack.c_msg_object_no_found);
    WHEN common_pack.e_row_locked THEN
      raise_application_error(common_pack.c_error_code_object_blocked
                             ,common_pack.c_msg_object_blocked);
    
  END;

END payment_api_pack;
/