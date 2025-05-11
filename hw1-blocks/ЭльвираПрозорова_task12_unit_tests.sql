 --��������� ��� unit-������ 

 --�������� "�������� �������"
   
DECLARE
  v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'MobileApp')
                                                                   ,t_payment_detail(2
                                                                                    ,'95.165.24.178')
                                                                   ,t_payment_detail(3
                                                                                    ,'������ ����� ������� Chrome'));
  v_payment_id     payment.payment_id%TYPE;
BEGIN
  v_payment_id := create_payment(p_payment_detail => v_payment_detail
                                ,p_summa          => 10000
                                ,p_currency_id    => 643
                                ,p_from_client_id => 1
                                ,p_to_client_id   => 4);
  dbms_output.put_line('Payment_id: ' || v_payment_id);
  COMMIT;
END;
/

SELECT * FROM payment a WHERE a.payment_id = 44;
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;


--�������� "����� ������� � "��������� ������" � ��������� �������"
DECLARE
  v_reason     payment.status_change_reason%TYPE := '������������ ������� �� �����';
  v_payment_id payment.payment_id%TYPE := 44;
BEGIN
  fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
  COMMIT;
END;
/
SELECT * FROM payment a WHERE a.payment_id = 44;
SELECT * FROM payment_detail a WHERE a.payment_id =44 ORDER BY a.field_id;



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


   
   
