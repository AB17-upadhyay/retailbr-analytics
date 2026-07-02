-- RetailBR Analytics | rpt_olist.vw_delivery_performance
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_delivery_performance` AS
SELECT
  year_month,
  COUNT(DISTINCT order_id)                                         AS delivered_orders,
  ROUND(AVG(actual_delivery_days), 1)                              AS avg_actual_days,
  ROUND(AVG(promised_delivery_days), 1)                            AS avg_promised_days,
  ROUND(COUNTIF(delivery_status = 'On Time') / COUNT(*) * 100, 1) AS on_time_pct,
  ROUND(COUNTIF(delivery_status = 'Late')    / COUNT(*) * 100, 1) AS late_pct,
  ROUND(AVG(CASE WHEN delivery_status = 'Late' THEN delivery_delay_days END), 1) AS avg_days_late_when_late
FROM `retailbr-analytics.dwh_olist.fact_orders`
WHERE order_status = 'delivered'
  AND actual_delivery_days IS NOT NULL
GROUP BY year_month
ORDER BY year_month;
