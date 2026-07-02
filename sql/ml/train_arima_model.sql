-- RetailBR Analytics | BigQuery ML — Train ARIMA Model
-- Project: retailbr-analytics | Dataset: rpt_olist

CREATE OR REPLACE MODEL `retailbr-analytics.rpt_olist.revenue_forecast_model`
OPTIONS (
  model_type       = 'ARIMA_PLUS',
  time_series_timestamp_col = 'order_month_date',
  time_series_data_col      = 'total_revenue',
  auto_arima       = TRUE,        -- BigQuery auto-selects best p,d,q params
  data_frequency   = 'MONTHLY',
  decompose_time_series = TRUE    -- shows trend, seasonality separately
) AS
SELECT
  PARSE_DATE('%Y-%m', year_month) AS order_month_date,
  SUM(item_price)                 AS total_revenue
FROM `retailbr-analytics.dwh_olist.fact_orders`
WHERE order_status = 'delivered'
  AND order_year BETWEEN 2017 AND 2018
GROUP BY year_month
ORDER BY order_month_date;

-- Note: Model training takes 1-3 minutes. You will see it appear
-- under the rpt_olist dataset with a model icon once done.
