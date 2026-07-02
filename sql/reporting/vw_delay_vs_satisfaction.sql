-- RetailBR Analytics | rpt_olist.vw_delay_vs_satisfaction
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_delay_vs_satisfaction` AS
SELECT
  fo.delivery_status,
  COUNT(DISTINCT fo.order_id)            AS order_count,
  ROUND(AVG(r.review_score), 2)          AS avg_review_score,
  ROUND(AVG(fo.delivery_delay_days), 1)  AS avg_delay_days,
  ROUND(AVG(fo.actual_delivery_days), 1) AS avg_actual_delivery_days
FROM `retailbr-analytics.dwh_olist.fact_orders` fo
INNER JOIN `retailbr-analytics.dwh_olist.dim_reviews` r
  ON fo.order_id = r.order_id
WHERE fo.delivery_status IN ('On Time', 'Late')
GROUP BY fo.delivery_status
ORDER BY avg_review_score DESC;

-- Expected insight: On Time orders avg ~4.2 stars; Late orders avg ~2.5 stars
-- This is your data-proven answer to Problem 1
