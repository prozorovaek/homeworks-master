CREATE OR REPLACE TRIGGER payment_b_d_restrict
  BEFORE DELETE ON payment
  FOR EACH ROW
BEGIN
  raise_application_error(payment_api_pack.c_error_code_delete_forbidden
                         ,payment_api_pack.c_msg_delete_forbidden);
END;
/
