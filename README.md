
# Zomato Invoice Analysis

## Project Overview

This project analyzes Zomato invoices for multiple restaurant brands to understand invoice expenses, compare year-over-year trends, and identify the major components contributing to total invoice costs.

The analysis uses Databricks SQL for data analysis and Power BI for interactive visualization.

## Problem Statement

Restaurant businesses incur platform-related expenses such as commission, convenience fees, and GST. Reviewing invoices individually makes it difficult to compare expenses across periods and brands.

The objective of this project is to consolidate invoice summaries, analyze expense trends, compare restaurant brands, and present useful findings through a Power BI dashboard.

## Project Objectives

- Analyze Zomato invoice expenses across multiple years.
- Compare invoice counts and total invoice costs by year.
- Compare expenses across restaurant brands.
- Examine convenience fees, Zomato commissions, taxable amounts, CGST, and SGST.
- Identify the brands contributing the largest share of summarized invoice costs.
- Build a Power BI dashboard to communicate business insights.

## Tools and Technologies

- Databricks SQL
- SQL aggregations and data analysis
- Power BI
- Microsoft Excel (source data preparation)
- GitHub

## Dataset Overview

The original data consists of Zomato invoice records for multiple restaurant brands.

Key fields include:

- Invoice Date
- Trade Name
- Restaurant ID
- Convenience Fee
- Zomato Commission
- Taxable Amount
- CGST
- SGST
- Invoice Total

**Note:** Original invoice files contain business information and are not included in this public repository.

## Analysis Performed

- Consolidated invoice summaries across multiple periods.
- Compared annual and year-to-date invoice costs.
- Analyzed invoice counts by restaurant brand.
- Examined expense components, including commission, fees, and GST.
- Created SQL queries to support business analysis.
- Developed Power BI visualizations for comparing expense trends.

## Key Findings

The summarized analysis produced the following invoice totals:

| Period | Invoice Count | Total Invoice Cost |
|---|---:|---:|
| 2024 | 31 | ₹27,49,350.94 |
| 2025 | 48 | ₹23,02,266.77 |
| 2026 YTD | 27 | ₹8,17,985.48 |

Key observations:

- 2025 had more invoices than 2024, while the summarized total invoice cost was lower.
- 2026 represents year-to-date data and is therefore not directly comparable with a complete year.
- Lemon Leaf contributed the largest summarized invoice total among the brands analyzed in the reviewed periods.
- Commission, convenience fees, and GST are important components to examine when understanding invoice costs.

These findings describe invoice expenses, not restaurant profitability.

## Business Value

This analysis can help restaurant management:

- Monitor platform-related invoice costs.
- Compare expenses across periods and brands.
- Understand the components of total invoice costs.
- Identify periods or brands that may require further investigation.
- Use dashboard insights to support expense monitoring and business decisions.

## Project Structure

```text
zomato-invoice-analysis/
├── README.md
├── sql/
│   └── SQL analysis queries
├── screenshots/
│   └── Power BI dashboard screenshots
└── documentation/
    └── Project documentation PDF
```

## Limitations

- The analysis is based on invoice records available for the selected periods.
- 2026 data is year-to-date and does not represent a complete financial year.
- Invoice costs alone cannot determine net profit or profitability.
- Profit analysis would require additional information such as food costs, salaries, rent, utilities, discounts, and other operating expenses.

## Future Enhancements

- Add more invoice periods as new data becomes available.
- Enhance the Power BI dashboard with additional comparisons and KPIs.
- Include other operating expenses to support a more complete profitability analysis.
- Automate data ingestion and reporting.

## Confidentiality

Original business invoices and confidential source data are excluded from this repository. The repository contains project documentation, SQL analysis, and selected dashboard screenshots only.

## Author

Data Analytics Project — Zomato Invoice Analysis

