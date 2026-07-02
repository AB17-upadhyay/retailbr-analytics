# Key Business Findings — RetailBR Analytics

Analysis of ~100,000 Brazilian e-commerce orders (Olist, 2016–2018) across three business problems.

---

## Problem 1: Customer Satisfaction & Delivery Performance

**Finding:** Late deliveries are the primary driver of poor customer reviews.

- On-time orders average **4.1–4.3 stars**; late orders average **2.4–2.6 stars** — a ~1.7 star gap
- Delivery delay is measurable, operational, and directly actionable
- Categories with the highest late delivery rates also have the lowest average review scores

**Recommendation:** Enforce logistics SLA standards for the top 10 revenue-generating categories. Even modest improvements in delivery accuracy would materially lift overall satisfaction scores.

---

## Problem 2: Revenue Concentration (Seller Pareto Analysis)

**Finding:** Revenue is highly concentrated in a small number of sellers.

- The **top ~500 sellers (17% of ~3,000)** generate **80% of total revenue**
- This is more concentrated than the classic 80/20 Pareto rule
- São Paulo-based sellers dominate both order volume and GMV

**Recommendation:** Seller diversification program targeting the 500–1,500 rank tier — onboarding support, reduced commission tiers, or dedicated account management to grow mid-tier sellers into consistent revenue contributors.

---

## Problem 3: Customer Retention & RFM Segmentation

**Finding:** The platform has a severe repeat purchase problem.

- **~97% of customers made only one purchase** — repeat rate of approximately 3%
- Champions and Loyal segments are small by count but generate disproportionately high lifetime value
- The largest customer group by count is "Lost" — bought once, long ago, unlikely to return without intervention

**Recommendation:** Prioritize re-engagement campaigns for the "At Risk" and "Cannot Lose Them" RFM segments — customers with proven purchase history who are showing signs of churn. Do not allocate re-engagement budget to the "Lost" segment; focus instead on retention of active customers.

---

## Revenue Forecast (BigQuery ML ARIMA_PLUS)

- **Model:** ARIMA_PLUS with auto_arima=TRUE, monthly granularity
- **Training data:** Monthly GMV from January 2016 to August 2018
- **Forecast horizon:** 3 months (Oct–Dec 2018)
- **Model selection:** AIC ~500 across candidate models — consistent, stable model selection
- **Trend:** See live dashboard for 3-month forecast with 90% confidence intervals

---

*Analysis conducted on the Olist Brazilian E-Commerce Public Dataset (CC BY-NC-SA 4.0)*
