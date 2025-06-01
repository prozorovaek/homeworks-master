DECLARE
  v_payment_detail t_payment_detail_array := t_payment_detail_array(
    t_payment_detail(1, 'MobileApp'),
    t_payment_detail(2, '95.165.24.178'),
    t_payment_detail(3, '������ ����� ������� Chrome')
  );
  v_updated_detail t_payment_detail_array := t_payment_detail_array(
    t_payment_detail(2, '178.234.89.201'),
    t_payment_detail(4, '�������� 2025-05-11T14:22:44, ���� 0.5%')
  );
  v_delete_field_ids t_number_array := t_number_array(2, 3);
  v_payment_id payment.payment_id%TYPE;
  v_reason payment.status_change_reason%TYPE;
BEGIN
  -- �������� �������
  v_payment_id := payment_api_pack.create_payment(
    p_payment_detail => v_payment_detail,
    p_summa          => 10000,
    p_currency_id    => 643,
    p_from_client_id => 1,
    p_to_client_id   => 4
  );

  -- ����� � ��������� ������
  v_reason := '������������ ������� �� �����';
  payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);

  -- ������ �������
  v_reason := '������ ������������';
  payment_api_pack.cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);

  -- �������� ����������
  payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);

  -- ���������� �������
  payment_detail_api_pack.insert_or_update_payment_detail(
    p_payment_id => v_payment_id,
    p_payment_detail => v_updated_detail
  );

  -- �������� ��������� �����
  payment_detail_api_pack.delete_payment_detail(
    p_payment_id => v_payment_id,
    p_delete_field_ids => v_delete_field_ids
  );

END;
/
