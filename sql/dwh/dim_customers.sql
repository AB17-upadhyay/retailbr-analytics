-- RetailBR Analytics | dwh_olist.dim_customers
-- Project: retailbr-analytics | Dataset: dwh_olist

CREATE OR REPLACE TABLE `retailbr-analytics.dwh_olist.dim_customers` AS
SELECT
  customer_id,
  customer_unique_id,   -- this is the true unique customer (one person can have multiple customer_ids)
  customer_zip_code_prefix,
  customer_city,
  customer_state
FROM `retailbr-analytics.stg_olist.customers`;
