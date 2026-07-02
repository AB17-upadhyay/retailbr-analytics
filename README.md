# RetailBR Analytics — GCP End-to-End Data Pipeline

![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=flat&logo=google-cloud&logoColor=white)
![Looker Studio](https://img.shields.io/badge/Looker_Studio-4285F4?style=flat&logo=google&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-336791?style=flat&logoColor=white)
![BigQuery ML](https://img.shields.io/badge/BigQuery_ML-34A853?style=flat&logo=google-cloud&logoColor=white)

An end-to-end cloud data analytics project built on Google Cloud Platform using real Brazilian e-commerce data from Olist (~100K orders, 2016–2018). The project covers data ingestion, transformation, KPI modelling, interactive dashboarding, and revenue forecasting with BigQuery ML ARIMA.

---

## 🔗 Live Dashboard

**[View the Looker Studio Dashboard →](docs/dashboard_link.md)**
https://datastudio.google.com/reporting/feea05dd-e588-44a2-a84d-7c189202e951

---

## 🏗 Architecture

```
Kaggle CSV Files (9 files, ~44MB)
        ↓
Google Cloud Storage — raw bucket (retailbr-raw-adarsh2026)
        ↓
BigQuery — stg_olist    (staging: raw tables, auto-detected schema)
        ↓
BigQuery — dwh_olist    (warehouse: fact_orders + 5 dim tables, star schema)
        ↓
BigQuery — rpt_olist    (reporting: 12 KPI views + RFM segments + ML model)
        ↓
Looker Studio           (5-page executive dashboard)
        ↓
BigQuery ML ARIMA_PLUS  (3-month revenue forecast)
```

---

## 🎯 Business Problems Solved

| # | Business Problem | Analytical Approach |
|---|-----------------|---------------------|
| 1 | Declining customer satisfaction — is delivery the root cause? | Delivery delay vs review score correlation |
| 2 | Revenue concentration — how dependent are we on a small number of sellers? | Pareto analysis with cumulative window functions |
| 3 | No customer retention strategy — who are our best customers? | RFM segmentation — 8 behavioral customer groups |

---

## 📊 Key Findings

- **Late deliveries score 2.5★ vs 4.2★ on-time** — delivery is the #1 driver of customer satisfaction
- **Top 17% of sellers generate 80% of revenue** — more concentrated than the classic 80/20 Pareto rule
- **~97% of customers never returned** — repeat purchase rate of only ~3%
- **Credit card dominates (74% of orders)** — avg 3.6 installments per transaction
- **São Paulo drives ~42% of total GMV** — significant geographic concentration

---

## 🛠 Tech Stack

| Tool | Role | Comparable To |
|------|------|---------------|
| Google Cloud Storage | Raw data lake | Local file system / S3 |
| BigQuery | Cloud data warehouse | SQL Server / Snowflake |
| BigQuery ML | In-database ML forecasting | Python statsmodels / scikit-learn |
| Looker Studio | BI dashboard & visualization | Power BI / Tableau |
| gsutil / Cloud Shell | CLI data loading | SSMS / command line |

---

## 📁 Repository Structure

```
retailbr-analytics/
├── README.md
├── sql/
│   ├── staging/
│   │   └── README.md            # Instructions for loading CSVs into stg_olist
│   ├── dwh/
│   │   ├── fact_orders.sql      # Central fact table with delivery metrics
│   │   ├── dim_customers.sql
│   │   ├── dim_products.sql     # Includes English category translation
│   │   ├── dim_sellers.sql
│   │   ├── dim_reviews.sql      # Includes sentiment classification
│   │   └── dim_payments.sql
│   ├── reporting/
│   │   ├── vw_monthly_revenue.sql
│   │   ├── vw_monthly_satisfaction.sql
│   │   ├── vw_delay_vs_satisfaction.sql
│   │   ├── vw_category_satisfaction.sql
│   │   ├── vw_delivery_performance.sql
│   │   ├── vw_category_revenue.sql
│   │   ├── vw_seller_concentration.sql
│   │   ├── vw_customer_retention.sql
│   │   ├── rfm_segments.sql
│   │   ├── vw_rfm_summary.sql
│   │   ├── vw_revenue_by_state.sql
│   │   └── vw_payment_analysis.sql
│   └── ml/
│       ├── train_arima_model.sql
│       ├── evaluate_model.sql
│       └── generate_forecast.sql
└── docs/
    ├── findings.md              # Key business insights
    ├── architecture.md          # Architecture notes
    └── dashboard_link.md        # Live Looker Studio URL
```

---

## 🗃 Dataset

**Brazilian E-Commerce Public Dataset by Olist** (Kaggle)
- Source: [kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- 9 CSV files · ~100K orders · 2016–2018
- Real marketplace data — Brazil's largest department store platform

---

## 🚀 How to Reproduce

1. Download the Olist dataset from Kaggle (link above)
2. Create a GCP project and enable BigQuery + Cloud Storage APIs
3. Upload all 9 CSVs to a GCS bucket under `raw/olist/`
4. Load each CSV into `stg_olist` dataset in BigQuery (enable "Quoted newlines" for order_reviews)
5. Run SQL files in order: `sql/dwh/` → `sql/reporting/` → `sql/ml/`
6. Connect `rpt_olist` dataset to Looker Studio at lookerstudio.google.com

---

## 👤 Author

**Adarsh Upadhyay** — Data Analyst | M.S. Econometrics, Arizona State University (W. P. Carey School of Business)

---

*Dataset licensed under CC BY-NC-SA 4.0 by Olist. Project code MIT licensed.*
