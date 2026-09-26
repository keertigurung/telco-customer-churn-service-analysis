-- ============================================================
-- 01_create_cleaned_churn_table.sql
-- Project: Telco Customer Churn & Service Analysis
-- Database: telco_churn
-- Schema: public
-- Grain: 1 row per customer

-- Purpose:
-- Create the cleaned customer-level analytical table used throughout the PostgreSQL analysis and Power BI dashboard.
-- ============================================================

CREATE TABLE telco_customer_churn (
    customer_id VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(20),
    age INTEGER,
    under_30 VARCHAR(10),
    senior_citizen VARCHAR(10),
    married VARCHAR(10),
    dependents VARCHAR(10),
    number_of_dependents INTEGER,
    referred_a_friend VARCHAR(10),
    number_of_referrals INTEGER,
    tenure_in_months INTEGER,
    offer VARCHAR(50),
    phone_service VARCHAR(10),
    avg_monthly_long_distance_charges NUMERIC(10,2),
    multiple_lines VARCHAR(20),
    internet_service VARCHAR(20),
    internet_type VARCHAR(30),
    avg_monthly_gb_download NUMERIC(10,2),
    online_security VARCHAR(20),
    online_backup VARCHAR(20),
    device_protection_plan VARCHAR(20),
    premium_tech_support VARCHAR(20),
    streaming_tv VARCHAR(20),
    streaming_movies VARCHAR(20),
    streaming_music VARCHAR(20),
    unlimited_data VARCHAR(20),
    contract VARCHAR(30),
    paperless_billing VARCHAR(10),
    payment_method VARCHAR(50),
    monthly_charge NUMERIC(10,2),
    total_charges NUMERIC(12,2),
    total_refunds NUMERIC(12,2),
    total_extra_data_charges NUMERIC(12,2),
    total_long_distance_charges NUMERIC(12,2),
    total_revenue NUMERIC(12,2),
    satisfaction_score INTEGER,
    customer_status VARCHAR(20),
    churn_label VARCHAR(10),
    churn_category VARCHAR(50),
    churn_reason VARCHAR(100),
    city VARCHAR(50),
    zip_code VARCHAR(20),
    latitude NUMERIC(10,6),
    longitude NUMERIC(10,6),
    population INTEGER
);

-- ============================================================
-- 1. Row count and unique customer count 
-- ============================================================ 
SELECT COUNT(*) AS total_rows, 
COUNT(DISTINCT customer_id) AS unique_customers 
FROM telco_customer_churn; 

-- ============================================================ 
-- 2. Check for duplicate customer IDs 
-- Expected result: 0 rows 
-- ============================================================
SELECT customer_id, COUNT(*) AS row_count 
FROM telco_customer_churn 
GROUP BY customer_id 
HAVING COUNT(*) > 1; 

-- ============================================================ 
-- 3. Check for NULL customer IDs -- Expected result: 0 
-- ============================================================ 
SELECT COUNT(*) AS null_customer_ids 
FROM telco_customer_churn 
WHERE customer_id IS NULL;


-- ============================================================
-- Add_derived_columns

-- Derived fields:
--   1. age_group
--   2. tenure_group
--   3. service_count
-- ============================================================

-- ============================================================
-- 1. Add age group
-- Groups customers into meaningful age segments for customer-characteristic analysis.
-- ============================================================

ALTER TABLE telco_customer_churn
ADD COLUMN age_group VARCHAR(20);

UPDATE telco_customer_churn
SET age_group =
    CASE
        WHEN age BETWEEN 18 AND 29 THEN '18-29'
        WHEN age BETWEEN 30 AND 44 THEN '30-44'
        WHEN age BETWEEN 45 AND 59 THEN '45-59'
        WHEN age >= 60 THEN '60+'
    END;

-- ============================================================
-- 2. Add tenure group
-- Groups customers into lifecycle stages for churn analysis.
-- ============================================================

ALTER TABLE telco_customer_churn
ADD COLUMN tenure_group VARCHAR(20);

UPDATE telco_customer_churn
SET tenure_group =
    CASE
        WHEN tenure_in_months BETWEEN 0 AND 12
            THEN '0-12 Months'
        WHEN tenure_in_months BETWEEN 13 AND 24
            THEN '13-24 Months'
        WHEN tenure_in_months BETWEEN 25 AND 48
            THEN '25-48 Months'
        WHEN tenure_in_months BETWEEN 49 AND 60
            THEN '49-60 Months'
        WHEN tenure_in_months >= 61
            THEN '61+ Months'
    END;


-- ============================================================
-- 3. Add service count
-- Counts the number of subscribed services for each customer.

-- Internet service type is not counted separately because
-- it describes the type of internet service rather than
-- representing an additional service.
-- ============================================================

ALTER TABLE telco_customer_churn
ADD COLUMN service_count INTEGER;

UPDATE telco_customer_churn
SET service_count =
      CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN device_protection_plan = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN premium_tech_support = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END
    + CASE WHEN streaming_music = 'Yes' THEN 1 ELSE 0 END;


-- ============================================================
-- 1. Check for NULL age groups
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE age_group IS NULL) AS null_age_groups
FROM telco_customer_churn;


-- ============================================================
-- 2. Check age group distribution
-- ============================================================

SELECT
    age_group,
    COUNT(*) AS customer_count
FROM telco_customer_churn
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN '18-29' THEN 1
        WHEN '30-44' THEN 2
        WHEN '45-59' THEN 3
        WHEN '60+' THEN 4
    END;


-- ============================================================
-- 3. Check for NULL tenure groups
-- Expected result: 0
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE tenure_group IS NULL) AS null_tenure_groups
FROM telco_customer_churn;


-- ============================================================
-- 4. Check tenure group distribution
-- ============================================================

SELECT
    tenure_group,
    COUNT(*) AS customer_count
FROM telco_customer_churn
GROUP BY tenure_group
ORDER BY
    CASE tenure_group
        WHEN '0-12 Months' THEN 1
        WHEN '13-24 Months' THEN 2
        WHEN '25-48 Months' THEN 3
        WHEN '49-60 Months' THEN 4
        WHEN '61+ Months' THEN 5
    END;


-- ============================================================
-- 5. Validate service count range
-- Expected:
--   Minimum = 0
--   Maximum = 9
--   NULL = 0
-- ============================================================

SELECT
    MIN(service_count) AS minimum_service_count,
    MAX(service_count) AS maximum_service_count,
    COUNT(*) FILTER (WHERE service_count IS NULL) AS null_service_counts
FROM telco_customer_churn;


-- ============================================================
-- 6. Check for invalid service counts
-- Expected result: 0
-- Valid range: 0 to 9
-- ============================================================

SELECT
    COUNT(*) AS invalid_service_counts
FROM telco_customer_churn
WHERE service_count < 0
   OR service_count > 9;


-- ============================================================
-- 7. Check service count distribution
-- ============================================================

SELECT
    service_count,
    COUNT(*) AS customer_count
FROM telco_customer_churn
GROUP BY service_count
ORDER BY service_count;

