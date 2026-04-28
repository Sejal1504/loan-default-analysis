# loan-default-analysis
> Identifying high-risk customer segments using SQL to help banks reduce loan default rates and improve lending decisions.
---------
## 📌 Project Overview

Loan defaults are one of the biggest financial risks for banks and NBFCs. This project analyzes a real-world banking dataset to uncover **which customer segments are most likely to default**, using SQL-based exploratory and comparative analysis.

The findings are translated into **actionable business recommendations** for risk teams and credit analysts.
---------
## 🎯 Objectives

- Identify customer profiles with the highest default risk
- Analyze how income, loan purpose, tenure, and interest rate affect default behavior
- Detect trends in loan disbursement and default rates over time
- Build a reusable SQL view for dashboard integration
---------
## 🗂️ Repository Structure

```
loan-default-analysis/
│
├── README.md                   ← You are here
├── data/
│   └── loan_data.csv           ← Dataset (source: Kaggle)
├── sql/
│   └── analysis_queries.sql    ← All SQL queries (6 sections)
├── excel/
│   └── dashboard.xlsx          ← Charts and visual summary
└── insights/
    └── key_findings.md         ← Written summary of findings
```
---
## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| MySQL / PostgreSQL | Data extraction, aggregation, segmentation |
| Microsoft Excel | Dashboard, charts, trend visualization |
| GitHub | Version control and project documentation |
----
## 📊 Dataset

- **Source:** [Kaggle — Bank Loan Default Dataset](https://www.kaggle.com/)
- **Rows:** ~10,000 loan records
- **Key Columns:** `loan_id`, `customer_id`, `loan_amount`, `annual_income`, `interest_rate`, `loan_purpose`, `loan_tenure_months`, `issue_date`, `default_flag`
- --
## 🔍 Analysis Sections (SQL)

The `analysis_queries.sql` file is organized into 6 sections:

1. **Data Exploration** — Record counts, null checks, loan purpose distribution
2. **Default Rate Analysis** — Breakdown by income bracket, loan purpose, tenure, and loan size
3. **Comparative Analysis** — Defaulters vs. non-defaulters across key metrics; interest rate band analysis; cross-segment analysis
4. **Trend Analysis** — Monthly and quarterly loan disbursement and default trends
5. **High-Risk Segment Identification** — Top 5 riskiest customer profiles; individual loan risk flagging
6. **Business Summary View** — SQL VIEW created for dashboard integration

---
## 📈 Key Findings

### 1. Income is the Strongest Default Predictor
Customers earning below ₹3 lakh annually show a **~34% higher default rate** compared to high-income borrowers. Low-income borrowers taking large loans (>₹3L) are the most vulnerable segment.

### 2. Personal Loans Default at 2x the Rate of Home Loans
Personal loans carry the highest default rate across all loan purposes, likely due to the absence of collateral and weaker repayment intent tracking.

### 3. Long Tenure + High Interest Rate = Danger Zone
Loans with tenure > 3 years and interest rates above 15% show significantly elevated default risk — especially for mid- and low-income borrowers.

### 4. Small Loan Amounts Are Misleading
Loans under ₹1 lakh have a higher default rate than medium-sized loans (₹1L–₹3L), suggesting that very small borrowers may have weaker credit profiles.

---
## 💡 Business Recommendations

| # | Recommendation | Segment Targeted |
|---|---------------|-----------------|
| 1 | Apply stricter income verification for personal loans under ₹3L income threshold | Low-income personal loan applicants |
| 2 | Offer shorter tenure options with lower interest to reduce long-term default exposure | Extended tenure borrowers |
| 3 | Introduce risk-tiered interest rates based on income bracket and loan purpose | All segments |

---
## 🚀 How to Run

1. Download the dataset from Kaggle and load it into MySQL or PostgreSQL as a table named `loans`
2. Open `sql/analysis_queries.sql` in your SQL client
3. Run each section sequentially
4. Use query outputs to populate the Excel dashboard
----
## 👩💻 About Me

**Sejal Kukkar** — Civil Engineering graduate with a strong interest in data and business analytics. Experienced in SQL-based data analysis, financial reporting, and translating data into business insights.

📧 sejalkukkar2@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/sejal-kukkar-3b61621b7/)

---
## 📄 License

This project is for educational and portfolio purposes. Dataset credit goes to the original publisher on Kaggle.


