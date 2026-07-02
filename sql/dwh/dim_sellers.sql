-- RetailBR Analytics | dwh_olist.dim_sellers
-- Project: retailbr-analytics | Dataset: dwh_olist

CREATE OR REPLACE TABLE `retailbr-analytics.dwh_olist.dim_sellers` AS
SELECT
  seller_id,
  seller_zip_code_prefix,
  seller_city,
  seller_state
FROM `retailbr-analytics.stg_olist.sellers`;
