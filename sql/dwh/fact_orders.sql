-- RetailBR Analytics | dwh_olist.fact_orders
-- Project: retailbr-analytics | Dataset: dwh_olist

CREATE OR REPLACE TABLE `retailbr-analytics.dwh_olist.fact_orders` AS

SELECT
  -- Keys
  o.order_id,
  o.customer_id,
  oi.seller_id,
  oi.product_id,
  oi.order_item_id,

  -- Status
  o.order_status,

  -- Dates (properly cast from string/timestamp to DATE)
  DATE(o.order_purchase_timestamp)        AS order_date,
  DATE(o.order_approved_at)               AS approved_date,
  DATE(o.order_delivered_carrier_date)    AS shipped_date,
  DATE(o.order_delivered_customer_date)   AS delivered_date,
  DATE(o.order_estimated_delivery_date)   AS estimated_delivery_date,

  -- Time dimensions for grouping
  EXTRACT(YEAR  FROM o.order_purchase_timestamp) AS order_year,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
  FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp)) AS year_month,
  FORMAT_DATE('%Y-Q%Q', DATE(o.order_purchase_timestamp)) AS year_quarter,

  -- Revenue metrics
  oi.price                                AS item_price,
  oi.freight_value,
  oi.price + oi.freight_value             AS total_item_value,

  -- Delivery performance metrics
  DATE_DIFF(
    DATE(o.order_delivered_customer_date),
    DATE(o.order_purchase_timestamp),
    DAY
  ) AS actual_delivery_days,

  DATE_DIFF(
    DATE(o.order_estimated_delivery_date),
    DATE(o.order_purchase_timestamp),
    DAY
  ) AS promised_delivery_days,

  DATE_DIFF(
    DATE(o.order_delivered_customer_date),
    DATE(o.order_estimated_delivery_date),
    DAY
  ) AS delivery_delay_days,  -- NEGATIVE = arrived early, POSITIVE = arrived late

  -- Delivery status flag
  CASE
    WHEN o.order_delivered_customer_date IS NULL                           THEN 'Not Delivered'
    WHEN DATE(o.order_delivered_customer_date)
         <= DATE(o.order_estimated_delivery_date)                          THEN 'On Time'
    ELSE 'Late'
  END AS delivery_status

FROM `retailbr-analytics.stg_olist.orders` o
INNER JOIN `retailbr-analytics.stg_olist.order_items` oi
  ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
  AND oi.price IS NOT NULL;
