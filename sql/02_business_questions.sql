-- ============================================================
-- Project: Telco Customer Churn & Service Analysis
-- Grain:1 row per customer
-- ============================================================


/*
Q1: How does churn vary across age groups?
*/

SELECT
    age_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN '18-29' THEN 1
        WHEN '30-44' THEN 2
        WHEN '45-59' THEN 3
        WHEN '60+' THEN 4
    END;


/*
Q2: How is churn associated with marital and dependent status?
*/

SELECT
    married,
    dependents,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY married, dependents
ORDER BY churn_rate_percentage DESC;


/*
Q3: How is customer referral engagement associated with churn?
*/

WITH referral_groups AS (
    SELECT
        CASE
            WHEN number_of_referrals = 0 THEN '0 Referrals'
            WHEN number_of_referrals BETWEEN 1 AND 2 THEN '1-2 Referrals'
            WHEN number_of_referrals BETWEEN 3 AND 5 THEN '3-5 Referrals'
            WHEN number_of_referrals >= 6 THEN '6+ Referrals'
        END AS referral_group,
        churn_label
    FROM telco_customer_churn
)
SELECT
    referral_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM referral_groups
GROUP BY referral_group
ORDER BY
    CASE referral_group
        WHEN '0 Referrals' THEN 1
        WHEN '1-2 Referrals' THEN 2
        WHEN '3-5 Referrals' THEN 3
        WHEN '6+ Referrals' THEN 4
    END;


/*
Q4: How does churn vary with the number of services subscribed to?
*/

SELECT
    service_count,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY service_count
ORDER BY service_count;


/*
Q5: How does churn differ across internet service types?
*/

SELECT
    internet_type,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY internet_type
ORDER BY churn_rate_percentage DESC;


/*
Q6: At what tenure stage is churn most concentrated?
*/

SELECT
    tenure_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
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


/*
Q7: How does churn vary by contract type?
*/

SELECT
    contract,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY contract
ORDER BY churn_rate_percentage DESC;


/*
Q8: How does contract type relate to churn across different
    tenure stages?
*/

SELECT
    tenure_group,
    contract,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churned_customers,
    COUNT(*) FILTER (WHERE churn_label = 'No') AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_label = 'Yes')
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY tenure_group, contract
ORDER BY
    CASE tenure_group
        WHEN '0-12 Months' THEN 1
        WHEN '13-24 Months' THEN 2
        WHEN '25-48 Months' THEN 3
        WHEN '49-60 Months' THEN 4
        WHEN '61+ Months' THEN 5
    END,
    churn_rate_percentage DESC;

