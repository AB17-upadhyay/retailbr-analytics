# Architecture — RetailBR Analytics

## Pipeline Overview

```
[Source]          Kaggle — Brazilian E-Commerce Dataset (Olist)
                  9 CSV files, ~44MB ZIP, ~100K orders, 2016–2018

[Data Lake]       Google Cloud Storage
                  Bucket: retailbr-raw-[name]-2026
                  Path:   raw/olist/{table_name}/

[Staging]         BigQuery — stg_olist
                  9 raw tables, auto-detected schema
                  No transformations — exact copy of source

[Warehouse]       BigQuery — dwh_olist
                  Star schema:
                  └── fact_orders        (central fact, ~112K rows)
                  └── dim_customers      (~99K rows)
                  └── dim_products       (~32K rows, English categories)
                  └── dim_sellers        (~3K rows)
                  └── dim_reviews        (~99K rows, sentiment flag)
                  └── dim_payments       (~103K rows)

[Reporting]       BigQuery — rpt_olist
                  12 KPI views (satisfaction, revenue, RFM, geography, payments)
                  1 physical table (rfm_segments — NTILE scoring)
                  1 ML model (revenue_forecast_model — ARIMA_PLUS)

[Dashboard]       Looker Studio
                  5 pages: Executive Summary | Delivery & Satisfaction |
                           Revenue & Sellers | Customer Segments |
                           Geography & Payments

[Forecasting]     BigQuery ML ARIMA_PLUS
                  3-month revenue forecast with 90% confidence intervals
```

## Design Principles

**Medallion Architecture (Bronze → Silver → Gold)**
Each dataset layer has a single responsibility. Staging is write-once raw data.
The warehouse contains all business logic. Reporting is read-optimized for dashboards.

**Star Schema**
Fact table holds numeric measures and foreign keys. Dimensions hold descriptive attributes.
No business logic in dimension tables — transformations happen in fact_orders.

**Views vs Tables in Reporting**
Most reporting objects are views (always current, no storage cost).
rfm_segments is a physical table because NTILE window functions over 99K customers
are expensive to recompute on every dashboard load.

## GCP Services Used

| Service | Tier | Cost |
|---------|------|------|
| Cloud Storage | Standard | ~$0 (under 5GB free tier) |
| BigQuery | On-demand | ~$0 (under 1TB/month free tier) |
| BigQuery ML | On-demand | Minimal (small dataset) |
| Looker Studio | Free | Always free |
