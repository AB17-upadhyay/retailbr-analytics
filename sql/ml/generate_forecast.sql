-- RetailBR Analytics | BigQuery ML — Generate 3-month Forecast
-- Project: retailbr-analytics | Dataset: rpt_olist

SELECT
  FORMAT_DATE('%Y-%m', forecast_timestamp)      AS forecast_month,
  ROUND(forecast_value, 2)                       AS forecasted_revenue,
  ROUND(prediction_interval_lower_bound, 2)      AS pessimistic_scenario,
  ROUND(prediction_interval_upper_bound, 2)      AS optimistic_scenario
FROM ML.FORECAST(
  MODEL `retailbr-analytics.rpt_olist.revenue_forecast_model`,
  STRUCT(
    3   AS horizon,           -- 3 months ahead
    0.9 AS confidence_level   -- 90% confidence interval
  )
)
ORDER BY forecast_timestamp;
