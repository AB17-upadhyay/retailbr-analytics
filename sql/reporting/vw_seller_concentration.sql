-- RetailBR Analytics | rpt_olist.vw_seller_concentration
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE VIEW `retailbr-analytics.rpt_olist.vw_seller_concentration` AS
WITH seller_rev AS (
  SELECT
    fo.seller_id,
    ds.seller_state,
    ds.seller_city,
    COUNT(DISTINCT fo.order_id)    AS total_orders,
    ROUND(SUM(fo.item_price), 2)   AS total_revenue,
    ROUND(AVG(r.review_score), 2)  AS avg_review_score
  FROM `retailbr-analytics.dwh_olist.fact_orders` fo
  INNER JOIN `retailbr-analytics.dwh_olist.dim_sellers` ds
    ON fo.seller_id = ds.seller_id
  LEFT JOIN `retailbr-analytics.dwh_olist.dim_reviews` r
    ON fo.order_id = r.order_id
  WHERE fo.order_status = 'delivered'
  GROUP BY fo.seller_id, ds.seller_state, ds.seller_city
),
grand AS (SELECT SUM(total_revenue) AS total FROM seller_rev)
SELECT
  sr.*,
  ROW_NUMBER() OVER (ORDER BY sr.total_revenue DESC)            AS revenue_rank,
  ROUND(sr.total_revenue / g.total * 100, 3)                    AS revenue_share_pct,
  ROUND(SUM(sr.total_revenue) OVER (
    ORDER BY sr.total_revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) / g.total * 100, 1)                                         AS cumulative_revenue_pct
FROM seller_rev sr
CROSS JOIN grand g
ORDER BY sr.total_revenue DESC;

-- TIP: Export this and filter cumulative_revenue_pct <= 80
-- to find the exact set of sellers that drives 80% of revenue
