-- RetailBR Analytics | rpt_olist.vw_payment_analysis
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_payment_analysis` AS
SELECT
  p.primary_payment_type                  AS payment_type,
  COUNT(DISTINCT fo.order_id)             AS total_orders,
  ROUND(SUM(fo.item_price), 2)            AS total_revenue,
  ROUND(AVG(fo.item_price), 2)            AS avg_order_value,
  ROUND(AVG(p.max_installments), 1)       AS avg_installments
FROM `retailbr-analytics.dwh_olist.fact_orders` fo
INNER JOIN `retailbr-analytics.dwh_olist.dim_payments` p
  ON fo.order_id = p.order_id
WHERE fo.order_status = 'delivered'
GROUP BY p.primary_payment_type
ORDER BY total_revenue DESC;
