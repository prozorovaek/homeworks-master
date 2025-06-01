CREATE OR REPLACE TRIGGER payment_detail_b_iud_api
  BEFORE INSERT OR UPDATE OR DELETE ON payment_detail
  FOR EACH ROW
BEGIN
  payment_api_pack.is_changes_through_api(); -- проверка на выполнение команды через API
END;
/
