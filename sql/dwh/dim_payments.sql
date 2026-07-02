-- RetailBR Analytics | dwh_olist.dim_payments
-- Project: retailbr-analytics | Dataset: dwh_olist

CREATE OR REPLACE TABLE `retailbr-analytics.dwh_olist.dim_payments` AS
SELECT
  order_id,
  -- Primary payment type (when an order has multiple payment rows, take most common)
  ARRAY_AGG(payment_type ORDER BY payment_value DESC LIMIT 1)[OFFSET(0)] AS primary_payment_type,
  SUM(payment_value)         AS total_payment_value,
  MAX(payment_installments)  AS max_installments,
  COUNT(*)                   AS payment_row_count
FROM `retailbr-analytics.stg_olist.order_payments`
GROUP BY order_id;
