-- RetailBR Analytics | rpt_olist.vw_monthly_satisfaction
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_monthly_satisfaction` AS
SELECT
  fo.year_month,
  fo.order_year,
  fo.order_month,
  ROUND(AVG(r.review_score), 2)                            AS avg_review_score,
  COUNT(DISTINCT fo.order_id)                              AS total_orders_reviewed,
  COUNTIF(r.review_score >= 4)                             AS positive_count,
  COUNTIF(r.review_score = 3)                              AS neutral_count,
  COUNTIF(r.review_score = 4) / COUNT(*) * 100, 1) AS positive_pct,
  ROUND(COUNTIF(r.review_score <= 2) / COUNT(*) * 100, 1) AS negative_pct
FROM `retailbr-analytics.dwh_olist.fact_orders` fo
INNER JOIN `retailbr-analytics.dwh_olist.dim_reviews` r
  ON fo.order_id = r.order_id
WHERE fo.order_year BETWEEN 2017 AND 2018
GROUP BY fo.year_month, fo.order_year, fo.order_month
ORDER BY fo.year_month;
