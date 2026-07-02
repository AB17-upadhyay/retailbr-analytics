-- RetailBR Analytics | rpt_olist.rfm_segments
-- Project: retailbr-analytics | Dataset: rpt_olist

-- Using '2018-10-01' as reference date (day after last order in dataset)
CREATE OR REPLACE TABLE `retailbr-analytics.rpt_olist.rfm_segments` AS

WITH ref AS (SELECT DATE('2018-10-01') AS ref_date),

customer_rfm AS (
  SELECT
    c.customer_unique_id,
    DATE_DIFF(r.ref_date, MAX(fo.order_date), DAY) AS recency_days,
    COUNT(DISTINCT fo.order_id)                     AS frequency,
    ROUND(SUM(fo.item_price), 2)                    AS monetary_value
  FROM `retailbr-analytics.dwh_olist.fact_orders` fo
  INNER JOIN `retailbr-analytics.dwh_olist.dim_customers` c
    ON fo.customer_id = c.customer_id
  CROSS JOIN ref r
  WHERE fo.order_status = 'delivered'
  GROUP BY c.customer_unique_id, r.ref_date
),

rfm_scored AS (
  SELECT
    *,
    NTILE(5) OVER (ORDER BY recency_days DESC)   AS r_score,  -- lower days = more recent = score 5
    NTILE(5) OVER (ORDER BY frequency ASC)        AS f_score,
    NTILE(5) OVER (ORDER BY monetary_value ASC)   AS m_score
  FROM customer_rfm
)

SELECT
  customer_unique_id,
  recency_days,
  frequency,
  monetary_value,
  r_score, f_score, m_score,
  r_score + f_score + m_score AS rfm_total_score,
  CASE
    WHEN r_score >= 4 AND f_score >= 4                          THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 3                          THEN 'Loyal Customers'
    WHEN r_score >= 4 AND f_score = 4         THEN 'High-Value Recent'
    WHEN r_score >= 3 AND f_score = 3                          THEN 'At Risk'
    WHEN r_score = 1  AND f_score >= 3                          THEN 'Cannot Lose Them'
    WHEN r_score <= 2 AND f_score = 1 AND m_score <= 2          THEN 'Lost'
    ELSE                                                             'Need Attention'
  END AS rfm_segment
FROM rfm_scored;
