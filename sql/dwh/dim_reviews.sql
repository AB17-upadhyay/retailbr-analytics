-- RetailBR Analytics | dwh_olist.dim_reviews
-- Project: retailbr-analytics | Dataset: dwh_olist

CREATE OR REPLACE TABLE `retailbr-analytics.dwh_olist.dim_reviews` AS
SELECT
  review_id,
  order_id,
  review_score,
  CASE
    WHEN review_score >= 4 THEN 'Positive'
    WHEN review_score = 3  THEN 'Neutral'
    ELSE                        'Negative'
  END AS review_sentiment,
  DATE(review_creation_date)    AS review_date,
  DATE(review_answer_timestamp) AS review_answered_date
FROM `retailbr-analytics.stg_olist.order_reviews`;
