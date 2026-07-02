-- RetailBR Analytics | rpt_olist.vw_customer_retention
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_customer_retention` AS
WITH cust_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(DISTINCT fo.order_id)       AS order_count,
    MIN(fo.order_date)                AS first_order_date,
    MAX(fo.order_date)                AS last_order_date,
    ROUND(SUM(fo.item_price), 2)      AS lifetime_value,
    DATE_DIFF(MAX(fo.order_date), MIN(fo.order_date), DAY) AS days_as_customer
  FROM `retailbr-analytics.dwh_olist.fact_orders` fo
  INNER JOIN `retailbr-analytics.dwh_olist.dim_customers` c
    ON fo.customer_id = c.customer_id
  WHERE fo.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT
  COUNT(*)                                               AS total_unique_customers,
  COUNTIF(order_count = 1)                               AS one_time_buyers,
  COUNTIF(order_count = 2)                               AS two_time_buyers,
  COUNTIF(order_count >= 3)                              AS loyal_buyers,
  ROUND(COUNTIF(order_count >= 2) / COUNT(*) * 100, 2)  AS repeat_purchase_rate_pct,
  ROUND(AVG(lifetime_value), 2)                          AS avg_customer_ltv,
  ROUND(AVG(CASE WHEN order_count >= 2 THEN lifetime_value END), 2) AS avg_repeat_customer_ltv
FROM cust_orders;
