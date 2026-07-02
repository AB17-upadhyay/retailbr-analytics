-- RetailBR Analytics | BigQuery ML — Evaluate ARIMA Model
-- Project: retailbr-analytics | Dataset: rpt_olist

SELECT *
FROM ML.ARIMA_EVALUATE(MODEL `retailbr-analytics.rpt_olist.revenue_forecast_model`);

-- Key metric: AIC (Akaike Information Criterion) — lower is better
-- MAPE (Mean Absolute Percentage Error) — your forecast accuracy %
