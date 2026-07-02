-- RetailBR Analytics | dwh_olist.dim_products
-- Project: retailbr-analytics | Dataset: dwh_olist

CREATE OR REPLACE TABLE `retailbr-analytics.dwh_olist.dim_products` AS
SELECT
  p.product_id,
  COALESCE(ct._col1, p.product_category_name, 'uncategorized') AS product_category_english,
  p.product_category_name                  AS product_category_portuguese,
  p.product_weight_g,
  p.product_length_cm,
  p.product_height_cm,
  p.product_width_cm,
  -- Derived: volumetric weight (common in logistics)
  ROUND(
    (p.product_length_cm * p.product_height_cm * p.product_width_cm) / 5000.0, 2
  ) AS volumetric_weight_kg
FROM `retailbr-analytics.stg_olist.products` p
LEFT JOIN `retailbr-analytics.stg_olist.category_translation` ct
  ON p.product_category_name = ct._col0;

-- NOTE: The category_translation CSV has no headers, so BigQuery auto-names
-- them _col0 (Portuguese) and _col1 (English). If auto-detect used different
-- names, check your table schema and adjust accordingly.
