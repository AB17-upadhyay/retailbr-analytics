-- RetailBR Analytics | rpt_olist.vw_category_revenue
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_category_revenue` AS
WITH totals AS (
  SELECT SUM(item_price) AS grand_total
  FROM `retailbr-analytics.dwh_olist.fact_orders`
  WHERE order_status = 'delivered'
)
SELECT
  dp.product_category_english             AS category,
  COUNT(DISTINCT fo.order_id)             AS total_orders,
  COUNT(DISTINCT fo.seller_id)            AS active_sellers,
  ROUND(SUM(fo.item_price), 2)            AS total_revenue,
  ROUND(AVG(fo.item_price), 2)            AS avg_item_price,
  ROUND(SUM(fo.item_price)
        / t.grand_total * 100, 2)         AS revenue_share_pct,
  ROUND(AVG(r.review_score), 2)           AS avg_review_score
FROM `retailbr-analytics.dwh_olist.fact_orders` fo
INNER JOIN `retailbr-analytics.dwh_olist.dim_products` dp
  ON fo.product_id = dp.product_id
LEFT JOIN `retailbr-analytics.dwh_olist.dim_reviews` r
  ON fo.order_id = r.order_id
CROSS JOIN totals t
WHERE fo.order_status = 'delivered'
  AND dp.product_category_english IS NOT NULL
GROUP BY dp.product_category_english, t.grand_total
ORDER BY total_revenue DESC;
