-- RetailBR Analytics | rpt_olist.vw_rfm_summary
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_rfm_summary` AS
SELECT
  rfm_segment,
  COUNT(*)                        AS customer_count,
  ROUND(AVG(recency_days), 0)     AS avg_recency_days,
  ROUND(AVG(frequency), 1)        AS avg_order_frequency,
  ROUND(AVG(monetary_value), 2)   AS avg_ltv,
  ROUND(SUM(monetary_value), 2)   AS total_segment_revenue
FROM `retailbr-analytics.rpt_olist.rfm_segments`
GROUP BY rfm_segment
ORDER BY total_segment_revenue DESC;
