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
    l_msg          VARCHAR2(50) := 'Платеж создан. ';
  BEGIN
    IF p_payment_detail IS NOT empty
    THEN
      FOR i IN p_payment_detail.first .. p_payment_detail.last
      LOOP
        IF p_payment_detail(i).field_id IS NULL
        THEN
          raise_application_error(c_error_code_invalid_input_parameter, c_msg_id_field_empty);
        END IF;
        IF p_payment_detail(i).field_value IS NULL
        THEN
          raise_application_error(c_error_code_invalid_input_parameter, c_msg_value_not_empty);
        END IF;
        dbms_output.put_line('ID: ' || p_payment_detail(i).field_id || '. Value: ' || p_payment_detail(i).field_value);
      END LOOP;
    ELSE
      raise_application_error(c_error_code_invalid_input_parameter, c_msg_collection_empty);
    END IF;
  
    dbms_output.put_line(l_msg || ' Статус: ' || c_status_created);
    dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
  
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
    l_msg          VARCHAR2(100) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
    p_create_dtime TIMESTAMP := systimestamp;
  BEGIN
    IF p_payment_id IS NULL
    THEN
      raise_application_error(c_error_code_invalid_input_parameter, c_msg_id_empty);
    END IF;
    IF p_reason IS NULL
    THEN
      raise_application_error(c_error_code_invalid_input_parameter, c_msg_reason_empty);
    END IF;
  
    allow_changes();
  
    dbms_output.put_line(l_msg || ' Статус: ' || c_status_error || '. Причина: ' || p_reason ||
                         '. ID: ' || p_payment_id);
    dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
  
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
    l_msg          VARCHAR2(100) := 'Отмена платежа с указанием причины.';
    p_create_dtime TIMESTAMP := systimestamp;
  BEGIN
    IF p_payment_id IS NULL
    THEN
      raise_application_error(c_error_code_invalid_input_parameter, c_msg_id_empty);
    END IF;
  
    dbms_output.put_line(l_msg || ' Статус: ' || c_status_cancel || '. Причина: ' || p_reason ||
                         '. ID: ' || p_payment_id);
    dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
  
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
    l_msg          VARCHAR2(100) := 'Успешное завершение платежа.';
    p_create_dtime TIMESTAMP := systimestamp;
  BEGIN
    IF p_payment_id IS NULL
    THEN
      raise_application_error(c_error_code_invalid_input_parameter, c_msg_id_empty);
    END IF;
  
    dbms_output.put_line(l_msg || ' Статус: ' || c_status_success || '. ID: ' || p_payment_id);
    dbms_output.put_line(to_char(p_create_dtime, 'dd.mm.yyyy hh24:mi:ss.ff'));
  
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
    THEN
      raise_application_error(c_error_code_manual_changes, c_msg_manual_changes);
    END IF;
  
  END;

END payment_api_pack;
/
