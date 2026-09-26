# Telco Customer Churn & Service Analysis

## Project Overview

This project analyzes customer churn in a telecommunications company to identify patterns across customer characteristics, service engagement, and customer lifecycle.

The analysis follows an end-to-end data analytics workflow using Python for data preparation and exploration, PostgreSQL for business analysis, and Power BI for interactive visualization.

## Business Problem

A telecommunications company is experiencing customer churn but lacks a clear understanding of which customer, service, and lifecycle characteristics are associated with customers leaving.

This analysis examines these patterns to provide an evidence-based view of where churn is most concentrated and which areas may require further investigation.

## Key Business Questions

1. Which customer characteristics are associated with higher churn?
2. How is customer service engagement associated with churn?
3. At what stage of the customer lifecycle is churn most concentrated, and how does contract type relate to this pattern?

## Dataset Overview

The project uses five source datasets.

| Dataset | Rows | Columns | Purpose |
|---|---:|---:|---|
| Demographics | 7,043 | 9 | Customer demographic characteristics |
| Services | 7,043 | 31 | Service usage, tenure, contracts and billing information |
| Status | 7,043 | 12 | Customer status and churn information |
| Location | 7,043 | 10 | Customer geographic information |
| Population | 1,671 | 3 | Geographic population information |

The five datasets were integrated using `customer_id` and `zip_code` to create a single customer-level analytical dataset.

The final analytical dataset contains **7,043 customers**.

## Tools & Technologies

- **Python** – Data Exploration, Cleaning and Integration
- **PostgreSQL** – Storage of cleaned customer-level dataset and SQL-based Business Analysis
- **Power BI** – Interactive Dashboard and Visualization

## Analytical Workflow

The project follows an end-to-end data analytics workflow:

**Raw Datas → Data Cleaning & Integration → Exploratory Data Analysis → PostgreSQL Analysis → Power BI Dashboard → Findings & Recommendations**

## Methodology

The analysis followed a structured approach to identify patterns associated with customer churn:

1. **Data Preparation** – Profiled, cleaned and validated the five source datasets.
2. **Data Integration** – Combined customer-level data using `customer_id` and linked population data using `zip_code`.
3. **Feature Preparation** – Created analytical fields such as `age_group`, `tenure_group` and `service_count`.
4. **Churn Analysis** – Compared churn rates across customer characteristics, service engagement, tenure and contract type.
5. **Business Analysis** – Reproduced and extended the analysis in PostgreSQL using business-focused SQL queries.
6. **Visualization** – Presented key findings through an interactive Power BI dashboard.
   
## Data Cleaning & Integration

The five source datasets were cleaned and validated before being integrated into a single customer-level analytical dataset.

- Standardized column names and removed unnecessary fields.
- Checked customer IDs, duplicates, missing values, and data types.
- Handled expected missing values in service and churn-related fields.
- Converted population values to numeric format.
- Validated ZIP-code relationships between customer and population data.
- Joined customer-level datasets using `customer_id` and population data using `zip_code`.
- Final analytical dataset contains **7,043 customers** with one row per customer.

## Derived Analytical Fields

Three analytical fields were created in PostgreSQL to support the business questions.

### Age Group

Customers were grouped into four age segments:

- 18-29
- 30-44
- 45-59
- 60+

### Tenure Group

Customers were grouped into five customer lifecycle stages:

- 0-12 Months
- 13-24 Months
- 25-48 Months
- 49-60 Months
- 61+ Months

### Service Count

`service_count` represents the number of applicable services subscribed to by each customer.

The count ranges from 0 to 9.

Internet service type was not counted separately because it represents the type of internet service rather than an additional service category.

## Key Findings

### Customer Characteristics

- Customers aged **60+** had the highest observed churn rate at **35.41%**, compared with **21.70%** among customers aged 18-29.
- Churn varied substantially across household characteristics, with customers who were married with dependents showing **4.2%** churn compared with **34.4%** among customers who were neither married nor had dependents.
- Churn was 40.3% for customers with 1-2 referrals, but only 1.8% for customers with 6+ referrals, showing a non-linear relationship.

### Service Engagement

- Churn varied across service adoption, ranging from **43.8%** among customers with 0 services to **4.9%** among customers with 9 services.
- **Fiber Optic** customers had the highest observed churn rate among internet service types at **40.72%**.
- The 0-service group contained only **73 customers**, so this result should be interpreted with caution.

### Customer Lifecycle & Contract

- Churn was highest during the **0-12 month** tenure stage at **47.44%** and declined to **6.6%** among customers with **61+ months** of tenure.
- Month-to-month customers had **45.84%** churn, compared with **10.71%** for one-year and **2.55%** for two-year contracts.
- Month-to-month customers had the highest observed churn across every tenure stage, reaching 53.53% during the first 12 months.

## Power BI Dashboard

The Power BI dashboard presents the key churn patterns across customer characteristics, service engagement, tenure, and contract type.

[View Power BI Dashboard](powerbi/telco_customer_churn_dashboard.pbix)

## Business Recommendations

Based on the observed churn patterns:

1. **Investigate early-tenure customers**, particularly during the first 12 months, through stronger onboarding and engagement.

2. **Investigate month-to-month customers**, as this segment shows substantially higher observed churn across tenure stages.

3. **Investigate high-churn service segments**, particularly Fiber Optic customers, to understand potential service or experience-related factors.

4. **Use customer segmentation** based on age, household status, referrals, services, tenure and contract type to identify groups requiring further investigation.

## Limitations

- The dataset does not explain why customers churn beyond the available customer and service attributes.
- Some service-related fields contain expected missing values.
- The analysis does not measure the financial impact or cost of potential retention actions.
- The analysis is observational and does not establish that the identified characteristics cause churn.

## Repository Structure

| Folder/File | Description |
|---|---|
| `data/raw/` | Original five source datasets |
| `data/processed/` | Final integrated customer-level dataset |
| `notebooks/` | Python/Jupyter Notebook for data preparation and analysis |
| `sql/` | PostgreSQL table creation and business analysis queries |
| `powerbi/` | Power BI dashboard file |
| `report/` | Detailed project report |
| `presentation/` | Project presentation |
| `README.md` | Project overview, methodology, findings and documentation |

## Conclusion

The analysis of **7,043 customers** identified the strongest observed churn patterns around **early customer tenure** and **month-to-month contracts**.

Churn also varied across customer characteristics, service adoption, and internet service type. The findings provide a clear basis for identifying customer and service segments that warrant further investigation.
