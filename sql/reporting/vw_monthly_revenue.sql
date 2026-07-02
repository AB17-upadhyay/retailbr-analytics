-- RetailBR Analytics | rpt_olist.vw_monthly_revenue
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_monthly_revenue` AS
SELECT
  year_month,
  order_year,
  order_month,
  COUNT(DISTINCT order_id)            AS total_orders,
  COUNT(DISTINCT customer_id)         AS unique_customers,
  COUNT(*)                            AS total_items_sold,
  ROUND(SUM(item_price), 2)           AS gross_merchandise_value,
  ROUND(SUM(freight_value), 2)        AS total_freight_revenue,
  ROUND(SUM(total_item_value), 2)     AS total_revenue_incl_freight,
  ROUND(AVG(item_price), 2)           AS avg_item_price,
  ROUND(SUM(item_price)
        / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM `retailbr-analytics.dwh_olist.fact_orders`
WHERE order_status = 'delivered'
  AND order_year BETWEEN 2017 AND 2018
GROUP BY year_month, order_year, order_month
ORDER BY year_month;
