CREATE OR REPLACE TRIGGER payment_b_iu_api
  BEFORE INSERT OR UPDATE ON payment
  FOR EACH ROW
BEGIN
  payment_api_pack.is_changes_through_api(); -- проверка на выполнение команды через API
END;
