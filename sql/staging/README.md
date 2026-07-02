# Staging Layer — stg_olist

This folder documents how to load the 9 Olist CSV files into BigQuery's staging dataset.

## Steps

1. Download all 9 CSV files from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Upload to your GCS bucket under `raw/olist/` — one subfolder per file
3. In BigQuery, create a dataset named `stg_olist` (region: us-central1)
4. For each CSV, go to BigQuery → Create Table:
   - Source: Google Cloud Storage
   - File format: CSV
   - Enable **Auto-detect schema**
   - Enable **Header rows to skip: 1**
5. For `olist_order_reviews_dataset.csv` specifically: expand **Advanced options** and enable **Quoted newlines** before loading

## Files to Load

| CSV File | Target Table | Notes |
|----------|-------------|-------|
| olist_orders_dataset.csv | stg_olist.olist_orders_dataset | ~99K rows |
| olist_order_items_dataset.csv | stg_olist.olist_order_items_dataset | ~112K rows |
| olist_order_payments_dataset.csv | stg_olist.olist_order_payments_dataset | ~103K rows |
| olist_order_reviews_dataset.csv | stg_olist.olist_order_reviews_dataset | Enable Quoted Newlines |
| olist_customers_dataset.csv | stg_olist.olist_customers_dataset | ~99K rows |
| olist_products_dataset.csv | stg_olist.olist_products_dataset | ~32K rows |
| olist_sellers_dataset.csv | stg_olist.olist_sellers_dataset | ~3K rows |
| olist_geolocation_dataset.csv | stg_olist.olist_geolocation_dataset | ~1M rows |
| product_category_name_translation.csv | stg_olist.product_category_name_translation | ~71 rows |

## Verify Row Counts

```sql
SELECT 'orders'         AS tbl, COUNT(*) AS rows FROM `your-project.stg_olist.olist_orders_dataset`
UNION ALL
SELECT 'order_items',            COUNT(*) FROM `your-project.stg_olist.olist_order_items_dataset`
UNION ALL
SELECT 'order_payments',         COUNT(*) FROM `your-project.stg_olist.olist_order_payments_dataset`
UNION ALL
SELECT 'order_reviews',          COUNT(*) FROM `your-project.stg_olist.olist_order_reviews_dataset`
UNION ALL
SELECT 'customers',              COUNT(*) FROM `your-project.stg_olist.olist_customers_dataset`
UNION ALL
SELECT 'products',               COUNT(*) FROM `your-project.stg_olist.olist_products_dataset`
UNION ALL
SELECT 'sellers',                COUNT(*) FROM `your-project.stg_olist.olist_sellers_dataset`
UNION ALL
SELECT 'geolocation',            COUNT(*) FROM `your-project.stg_olist.olist_geolocation_dataset`
UNION ALL
SELECT 'category_translation',   COUNT(*) FROM `your-project.stg_olist.product_category_name_translation`;
```
