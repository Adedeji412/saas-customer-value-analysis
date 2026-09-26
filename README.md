# SaaS Customer Value & Acquisition Analysis (LTV:CAC)

## 📌 Project Overview
![Dashboard Overview](https://github.com/Adedeji412/saas-customer-value-analysis/blob/main/Screenshot%202026-09-26%20173232.png)
This project analyzes the customer lifecycle, acquisition efficiency, and revenue health of a SaaS business. By combining Excel for data auditing, MySQL for relational data modeling, and Power BI for visualization, I built an end-to-end analytics workflow to calculate Customer Lifetime Value (LTV), Customer Acquisition Cost (CAC), and churn dynamics.

The primary objective is to evaluate whether the business is acquiring customers efficiently and retaining them long enough to drive sustainable Monthly Recurring Revenue (MRR).

## 🛠️ Tech Stack & Workflow
* **Excel:** Initial quality control, standardizing date/currency formats, and handling missing values.
* **MySQL:** Database creation, table normalization, and writing Common Table Expressions (CTEs) to extract baseline Average Revenue Per Account (ARPA), churn rates, and LTV metrics.
* **Power BI:** Building a relational data model, engineering DAX measures (Total MRR, Blended CAC, LTV:CAC Ratio), and designing an interactive dashboard.

## 📊 Key Insights (from Dashboard Data)
1. **The "Leaky Bucket" Challenge:** Despite strong MRR growth reaching 11.34M and 390 active customers, the overall business suffers from a massive 70.4% historical churn rate.
2. **Pro Tier Dependency & Risk:** The `Pro` plan is the undisputed cash cow, driving 74.73% (8.47M) of total revenue. However, it also has the highest churn rate across all tiers at 72.5%. 
3. **Hyper-Efficient Acquisition:** The Blended CAC is incredibly low ($237.58) compared to the Average LTV (32.21K), resulting in a staggering 135.59 LTV:CAC ratio. Acquisition channels like Organic Search and Google Ads are bringing in highly valuable customers for almost zero relative cost.

## 💡 Strategic Business Recommendations
* **Pivot from Acquisition to Retention:** The business has solved acquisition (135x LTV:CAC ratio). Marketing spend should be temporarily frozen or maintained, while resources are heavily diverted into Customer Success and onboarding to fix the 70.4% churn rate.
* **Save the Pro Tier:** Since the `Pro` tier generates nearly 75% of the revenue but loses 72.5% of its users, a dedicated 30-day and 90-day retention campaign must be deployed specifically for this segment immediately.
* **Investigate Basic Tier Viability:** The `Basic` tier accounts for minimal revenue and still churns at 68.5%. The business should consider auditing the features of this tier or sunsetting it entirely to focus on `Pro` and `Enterprise` users.
