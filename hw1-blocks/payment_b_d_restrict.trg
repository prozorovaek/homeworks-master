CREATE OR REPLACE TRIGGER payment_b_d_restrict
  BEFORE DELETE ON payment
  FOR EACH ROW
BEGIN
  payment_api_pack.check_client_delete_restriction;
END;
/
