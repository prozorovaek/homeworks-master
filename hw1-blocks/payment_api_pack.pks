CREATE OR REPLACE PACKAGE payment_api_pack IS

  /*﻿
  Автор: Прозорова Эльвира
  Описание скрипта: API для сущностей "Платеж" и "Детали платежа"
  */

  -- Создание платежа
  FUNCTION create_payment
  (
    p_payment_detail t_payment_detail_array
   ,p_summa          NUMBER
   ,p_currency_id    NUMBER
   ,p_from_client_id NUMBER
   ,p_to_client_id   NUMBER
  ) RETURN payment.payment_id%TYPE;

  -- Сброс платежа в "ошибочный статус" с указанием причины
  PROCEDURE fail_payment
  (
    p_payment_id payment.payment_id%TYPE
   ,p_reason     payment.status_change_reason%TYPE
  );

  -- Отмена платежа из-за ошибки пользователя
  PROCEDURE cancel_payment
  (
    p_payment_id payment.payment_id%TYPE
   ,p_reason     payment.status_change_reason%TYPE
  );

  -- Успешное завершение платежа
  PROCEDURE successful_finish_payment(p_payment_id payment.payment_id%TYPE);

  --Триггеры

  --Проверка, вызываемая из триггера
  PROCEDURE is_changes_through_api;

  --Проверка на возможность удалять данные
  PROCEDURE check_client_delete_restriction;

END payment_api_pack;
/