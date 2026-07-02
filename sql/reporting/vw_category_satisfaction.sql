-- RetailBR Analytics | rpt_olist.vw_category_satisfaction
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_category_satisfaction` AS
SELECT
  dp.product_category_english              AS category,
  COUNT(DISTINCT fo.order_id)              AS total_orders,
  ROUND(AVG(r.review_score), 2)            AS avg_review_score,
  ROUND(AVG(fo.actual_delivery_days), 1)   AS avg_delivery_days,
  ROUND(AVG(fo.delivery_delay_days), 1)    AS avg_delay_days,
  ROUND(COUNTIF(fo.delivery_status='Late')
        / COUNT(*) * 100, 1)               AS late_delivery_pct
FROM `retailbr-analytics.dwh_olist.fact_orders` fo
INNER JOIN `retailbr-analytics.dwh_olist.dim_products` dp
  ON fo.product_id = dp.product_id
INNER JOIN `retailbr-analytics.dwh_olist.dim_reviews` r
  ON fo.order_id = r.order_id
WHERE dp.product_category_english IS NOT NULL
  AND fo.delivery_status IN ('On Time', 'Late')
GROUP BY dp.product_category_english
HAVING COUNT(DISTINCT fo.order_id) >= 50    -- minimum sample size
ORDER BY avg_review_score ASC;
