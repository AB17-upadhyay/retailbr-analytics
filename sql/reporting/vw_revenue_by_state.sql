-- RetailBR Analytics | rpt_olist.vw_revenue_by_state
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_revenue_by_state` AS
SELECT
  c.customer_state,
  COUNT(DISTINCT fo.order_id)              AS total_orders,
  COUNT(DISTINCT c.customer_unique_id)     AS unique_customers,
  ROUND(SUM(fo.item_price), 2)             AS total_revenue,
  ROUND(AVG(fo.item_price), 2)             AS avg_order_value,
  ROUND(AVG(r.review_score), 2)            AS avg_review_score,
  ROUND(AVG(fo.actual_delivery_days), 1)   AS avg_delivery_days
FROM `retailbr-analytics.dwh_olist.fact_orders` fo
INNER JOIN `retailbr-analytics.dwh_olist.dim_customers` c
  ON fo.customer_id = c.customer_id
LEFT JOIN `retailbr-analytics.dwh_olist.dim_reviews` r
  ON fo.order_id = r.order_id
WHERE fo.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
