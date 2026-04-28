-- ============================================================
-- LOAN DEFAULT RISK ANALYSIS
-- Author: Sejal Kukkar
-- Tool: MySQL / PostgreSQL
-- Dataset: Bank Loan Default Dataset (Kaggle)
-- Description: SQL queries to identify high-risk customer
--              segments and support risk-based lending decisions
-- ============================================================


-- ============================================================
-- SECTION 1: DATA EXPLORATION
-- ============================================================

-- 1.1 Total records and basic overview
SELECT 
    COUNT(*) AS total_loans,
    SUM(default_flag) AS total_defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS overall_default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(annual_income), 2) AS avg_annual_income,
    ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loans;


-- 1.2 Check for missing values in key columns
SELECT
    SUM(CASE WHEN loan_amount IS NULL THEN 1 ELSE 0 END) AS missing_loan_amount,
    SUM(CASE WHEN annual_income IS NULL THEN 1 ELSE 0 END) AS missing_income,
    SUM(CASE WHEN default_flag IS NULL THEN 1 ELSE 0 END) AS missing_default_flag,
    SUM(CASE WHEN loan_purpose IS NULL THEN 1 ELSE 0 END) AS missing_loan_purpose,
    SUM(CASE WHEN loan_tenure_months IS NULL THEN 1 ELSE 0 END) AS missing_tenure
FROM loans;


-- 1.3 Distribution of loan purposes
SELECT 
    loan_purpose,
    COUNT(*) AS total_loans,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM loans
GROUP BY loan_purpose
ORDER BY total_loans DESC;


-- ============================================================
-- SECTION 2: DEFAULT RATE ANALYSIS
-- ============================================================

-- 2.1 Default rate by loan purpose
SELECT 
    loan_purpose,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS total_defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY loan_purpose
ORDER BY default_rate_pct DESC;


-- 2.2 Default rate by income bracket
SELECT 
    CASE 
        WHEN annual_income < 300000  THEN 'Low Income (< 3L)'
        WHEN annual_income BETWEEN 300000 AND 700000 THEN 'Mid Income (3L - 7L)'
        WHEN annual_income BETWEEN 700001 AND 1200000 THEN 'Upper-Mid Income (7L - 12L)'
        ELSE 'High Income (> 12L)'
    END AS income_bracket,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loans
GROUP BY income_bracket
ORDER BY default_rate_pct DESC;


-- 2.3 Default rate by loan tenure bucket
SELECT 
    CASE 
        WHEN loan_tenure_months <= 12  THEN 'Short-term (≤ 1 year)'
        WHEN loan_tenure_months <= 36  THEN 'Medium-term (1–3 years)'
        WHEN loan_tenure_months <= 60  THEN 'Long-term (3–5 years)'
        ELSE 'Extended (> 5 years)'
    END AS tenure_bucket,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY tenure_bucket
ORDER BY default_rate_pct DESC;


-- 2.4 Default rate by loan amount bucket
SELECT 
    CASE 
        WHEN loan_amount < 100000  THEN 'Small (< 1L)'
        WHEN loan_amount BETWEEN 100000 AND 300000 THEN 'Medium (1L – 3L)'
        WHEN loan_amount BETWEEN 300001 AND 500000 THEN 'Large (3L – 5L)'
        ELSE 'Very Large (> 5L)'
    END AS loan_size_bucket,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY loan_size_bucket
ORDER BY default_rate_pct DESC;


-- ============================================================
-- SECTION 3: COMPARATIVE ANALYSIS
-- ============================================================

-- 3.1 Defaulters vs Non-Defaulters: Key metric comparison
SELECT 
    CASE WHEN default_flag = 1 THEN 'Defaulter' ELSE 'Non-Defaulter' END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(annual_income), 2) AS avg_annual_income,
    ROUND(AVG(interest_rate), 2) AS avg_interest_rate,
    ROUND(AVG(loan_tenure_months), 0) AS avg_tenure_months
FROM loans
GROUP BY default_flag;


-- 3.2 Interest rate bands vs default rate
SELECT 
    CASE 
        WHEN interest_rate < 8   THEN 'Low Rate (< 8%)'
        WHEN interest_rate BETWEEN 8 AND 12  THEN 'Standard Rate (8–12%)'
        WHEN interest_rate BETWEEN 12 AND 18 THEN 'High Rate (12–18%)'
        ELSE 'Very High Rate (> 18%)'
    END AS rate_band,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY rate_band
ORDER BY default_rate_pct DESC;


-- 3.3 Cross-segment analysis: Income bracket + Loan purpose
SELECT 
    loan_purpose,
    CASE 
        WHEN annual_income < 300000 THEN 'Low Income'
        WHEN annual_income BETWEEN 300000 AND 700000 THEN 'Mid Income'
        ELSE 'High Income'
    END AS income_bracket,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY loan_purpose, income_bracket
HAVING COUNT(*) > 20  -- filter out very small segments
ORDER BY default_rate_pct DESC
LIMIT 10;


-- ============================================================
-- SECTION 4: TREND ANALYSIS
-- ============================================================

-- 4.1 Month-wise loan disbursement and default trend
SELECT 
    DATE_FORMAT(issue_date, '%Y-%m') AS month,
    COUNT(*) AS loans_issued,
    SUM(loan_amount) AS total_amount_disbursed,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS monthly_default_rate_pct
FROM loans
GROUP BY month
ORDER BY month;


-- 4.2 Quarterly default trend
SELECT 
    YEAR(issue_date) AS year,
    QUARTER(issue_date) AS quarter,
    COUNT(*) AS loans_issued,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY year, quarter
ORDER BY year, quarter;


-- ============================================================
-- SECTION 5: HIGH-RISK SEGMENT IDENTIFICATION
-- ============================================================

-- 5.1 Top 5 highest-risk customer profiles
SELECT 
    loan_purpose,
    CASE 
        WHEN annual_income < 300000 THEN 'Low Income'
        WHEN annual_income BETWEEN 300000 AND 700000 THEN 'Mid Income'
        ELSE 'High Income'
    END AS income_bracket,
    CASE 
        WHEN loan_tenure_months <= 12 THEN 'Short-term'
        WHEN loan_tenure_months <= 36 THEN 'Medium-term'
        ELSE 'Long-term'
    END AS tenure_bucket,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY loan_purpose, income_bracket, tenure_bucket
HAVING COUNT(*) > 15
ORDER BY default_rate_pct DESC
LIMIT 5;


-- 5.2 Flag high-risk loans based on multiple criteria
SELECT 
    loan_id,
    customer_id,
    loan_amount,
    annual_income,
    interest_rate,
    loan_purpose,
    loan_tenure_months,
    default_flag,
    CASE 
        WHEN annual_income < 300000 
             AND interest_rate > 15 
             AND loan_tenure_months > 36 THEN 'HIGH RISK'
        WHEN annual_income BETWEEN 300000 AND 700000 
             AND interest_rate > 12 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_category
FROM loans
ORDER BY risk_category, default_rate_pct DESC;


-- ============================================================
-- SECTION 6: BUSINESS SUMMARY VIEW
-- (Can be saved as a view for dashboard use)
-- ============================================================

CREATE VIEW loan_risk_summary AS
SELECT 
    loan_purpose,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_portfolio_value,
    SUM(default_flag) AS total_defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(annual_income), 2) AS avg_borrower_income,
    ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loans
GROUP BY loan_purpose;
