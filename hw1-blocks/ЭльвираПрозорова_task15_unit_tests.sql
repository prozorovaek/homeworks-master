 --��������� ��� unit-������ 

 --�������� "�������� �������"
   
DECLARE
  v_payment_detail    t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'MobileApp')
                                                                      ,t_payment_detail(2
                                                                                       ,'95.165.24.178')
                                                                      ,t_payment_detail(3
                                                                                       ,'������ ����� ������� Chrome'));
  v_payment_id        payment.payment_id%TYPE;
  v_create_dtime_tech payment.create_dtime_tech%TYPE;
  v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
  v_payment_id := create_payment(p_payment_detail => v_payment_detail
                                ,p_summa          => 10000
                                ,p_currency_id    => 643
                                ,p_from_client_id => 1
                                ,p_to_client_id   => 4);
  dbms_output.put_line('Payment_id: ' || v_payment_id);

  SELECT create_dtime_tech
        ,update_dtime_tech
    INTO v_create_dtime_tech
        ,v_update_dtime_tech
    FROM payment
   WHERE payment_id = v_payment_id;

  IF v_create_dtime_tech != v_update_dtime_tech
  THEN
    raise_application_error(-20999, '����������� ���� ������');
  END IF;

  COMMIT;
END;
/

SELECT * FROM payment a WHERE a.payment_id = 85;
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;


--�������� "����� ������� � "��������� ������" � ��������� �������"
DECLARE
  v_reason            payment.status_change_reason%TYPE := '������������ ������� �� �����';
  v_payment_id        payment.payment_id%TYPE := 85;
  v_create_dtime_tech payment.create_dtime_tech%TYPE;
  v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
  fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
  
  SELECT create_dtime_tech
        ,update_dtime_tech
    INTO v_create_dtime_tech
        ,v_update_dtime_tech
    FROM payment
   WHERE payment_id = v_payment_id;

  IF v_create_dtime_tech = v_update_dtime_tech
  THEN
    raise_application_error(-20999, '����������� ���� ������');
  END IF;
  COMMIT;
END;
/
SELECT * FROM payment a WHERE a.payment_id = 85;
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;


--�������� ������� �������� ������� ����� delete
DECLARE
  v_payment_id payment.payment_id%TYPE := 85;
BEGIN
  DELETE payment a WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-���� ��� API ��������� �� �����');
EXCEPTION
  WHEN payment_api_pack.e_delete_forbidden THEN
    dbms_output.put_line('�������� �������. ���������� ���������� �������. ������: ' || SQLERRM);
END;
/

--�������� ������� ������� ������� �� ����� API
DECLARE
  v_payment_id payment.payment_id%TYPE := 85;
BEGIN
  INSERT INTO payment
    (payment_id, status, summa, currency_id, from_client_id, to_client_id)
  VALUES
    (v_payment_id, payment_api_pack.c_status_success, 15000, 643, 1, 4);

  raise_application_error(-20999, 'Unit-���� ��� API ��������� �� �����');
EXCEPTION
  WHEN payment_api_pack.e_manual_changes THEN
    dbms_output.put_line('������� � ������� client �� ����� API. ���������� ���������� �������. ������: ' || SQLERRM);
END;
/

--�������� ������� ���������� ������� �� ����� API
DECLARE
  v_payment_id payment.payment_id%TYPE := 85;
BEGIN
  UPDATE payment a SET a.status = a.status WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-���� ��� API ��������� �� �����');
EXCEPTION
  WHEN payment_api_pack.e_manual_changes THEN
    dbms_output.put_line('���������� ������� client �� ����� API. ���������� ���������� �������. ������: ' || SQLERRM);
END;
/
--�������� ������� ������� ������� �� ����� API
DECLARE
  v_payment_id payment_detail.payment_id%TYPE := 85;
BEGIN
  INSERT INTO payment_detail
    (payment_id, field_id, field_value)
  VALUES
    (v_payment_id, 1, 'TestMobile');

  raise_application_error(-20999, 'Unit-���� ��� API ��������� �� �����');
EXCEPTION
  WHEN payment_detail_api_pack.e_manual_changes THEN
    dbms_output.put_line('������� � ������� payment_detail �� ����� API. ���������� ���������� �������. ������: ' ||
                         SQLERRM);
END;
/

--�������� ������� ���������� ������� �� ����� API
DECLARE
  v_payment_id payment_detail.payment_id%TYPE := 85;
BEGIN
  UPDATE payment_detail a SET a.field_value = 'App' WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-���� ��� API ��������� �� �����');
EXCEPTION
  WHEN payment_detail_api_pack.e_manual_changes THEN
    dbms_output.put_line('���������� ������� payment_detail �� ����� API. ���������� ���������� �������. ������: ' ||
                         SQLERRM);
END;
/

--�������� ������� �������� ������� ����� delete
DECLARE
  v_payment_id payment_detail.payment_id%TYPE := 85;
BEGIN
  DELETE payment_detail a WHERE a.payment_id = v_payment_id;

  raise_application_error(-20999, 'Unit-���� ��� API ��������� �� �����');
EXCEPTION
  WHEN payment_detail_api_pack.e_manual_changes THEN
    dbms_output.put_line('�������� ������� ������� payment_detail �� ����� API. ���������� ���������� �������. ������: ' ||
                         SQLERRM);
END;
/

--�������� "������ ������� ��-�� ������ ������������"
DECLARE
  v_reason     payment.status_change_reason%TYPE := '������ ������������';
  v_payment_id payment.payment_id%TYPE := 44;
BEGIN
  cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
  COMMIT;
END;
/
SELECT * FROM payment a WHERE a.payment_id = 44;
SELECT * FROM payment_detail a WHERE a.payment_id = 44 ORDER BY a.field_id;


--�������� "�������� ���������� �������"
DECLARE
  v_payment_id payment.payment_id%TYPE := 44;
BEGIN
  successful_finish_payment(p_payment_id => v_payment_id);
  COMMIT;
END;
/
SELECT * FROM payment a WHERE a.payment_id = 44;
SELECT * FROM payment_detail a WHERE a.payment_id = 44 ORDER BY a.field_id;

--�������� "���������� ��� ���������� ������� �� ������ id_����/��������"

DECLARE
  v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(2
                                                                                    ,'178.234.89.201')
                                                                   ,t_payment_detail(4
                                                                                    ,'�������� 2025-05-11T14:22:44, ���� 0.5%'));
  v_payment_id     payment.payment_id%TYPE := 44;
BEGIN
  insert_or_update_payment_detail(p_payment_id => v_payment_id, p_payment_detail => v_payment_detail);
  COMMIT;
END;
/
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;

--�������� "�������� ������� �� ������ id_�����"

DECLARE
  v_delete_field_ids t_number_array := t_number_array(2, 3);
  v_payment_id       payment.payment_id%TYPE := 44;
BEGIN
  delete_payment_detail(p_payment_id => v_payment_id, p_delete_field_ids => v_delete_field_ids);
  COMMIT;
END;
/
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;


SELECT * FROM payment a WHERE a.payment_id = -1;
SELECT * FROM payment_detail a WHERE a.payment_id = 44 ORDER BY a.field_id;


      
