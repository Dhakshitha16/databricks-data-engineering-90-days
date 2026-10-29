Zomato Invoice Analysis

1. COMPARING THREE YEARS DATA



SELECT
    '2024' AS financial_year,
    COUNT(*) AS brand_rows,
    SUM(invoice_count) AS total_invoices,
    ROUND(SUM(convenience_fee), 2) AS convenience_fee,
    ROUND(SUM(zomato_commission), 2) AS zomato_commission,
    ROUND(SUM(taxable_amount), 2) AS taxable_amount,
    ROUND(SUM(cgst), 2) AS cgst,
    ROUND(SUM(sgst), 2) AS sgst,
    ROUND(SUM(invoice_total), 2) AS invoice_total
FROM mixed_brand_2024_clean

UNION ALL

SELECT
    '2025' AS financial_year,
    COUNT(*) AS brand_rows,
    SUM(invoice_count) AS total_invoices,
    ROUND(SUM(convenience_fee), 2) AS convenience_fee,
    ROUND(SUM(zomato_commission), 2) AS zomato_commission,
    ROUND(SUM(taxable_amount), 2) AS taxable_amount,
    ROUND(SUM(cgst), 2) AS cgst,
    ROUND(SUM(sgst), 2) AS sgst,
    ROUND(SUM(invoice_total), 2) AS invoice_total
FROM mixed_brand_2025_clean

UNION ALL

SELECT
    '2026 YTD' AS financial_year,
    COUNT(*) AS brand_rows,
    SUM(invoice_count) AS total_invoices,
    ROUND(SUM(convenience_fee), 2) AS convenience_fee,
    ROUND(SUM(zomato_commission), 2) AS zomato_commission,
    ROUND(SUM(taxable_amount), 2) AS taxable_amount,
    ROUND(SUM(cgst), 2) AS cgst,
    ROUND(SUM(sgst), 2) AS sgst,
    ROUND(SUM(invoice_total), 2) AS invoice_total
FROM mixed_brand_2026_ytd_clean;




2. COMPARE EXPENSES BRAND BY BRAND




SELECT
    '2024' AS period,
    trade_name,
    invoice_count,
    ROUND(convenience_fee, 2) AS convenience_fee,
    ROUND(zomato_commission, 2) AS zomato_commission,
    ROUND(taxable_amount, 2) AS taxable_amount,
    ROUND(invoice_total, 2) AS invoice_total
FROM mixed_brand_2024_clean

UNION ALL

SELECT
    '2025' AS period,
    trade_name,
    invoice_count,
    ROUND(convenience_fee, 2),
    ROUND(zomato_commission, 2),
    ROUND(taxable_amount, 2),
    ROUND(invoice_total, 2)
FROM mixed_brand_2025_clean

UNION ALL

SELECT
    '2026 YTD' AS period,
    trade_name,
    invoice_count,
    ROUND(convenience_fee, 2),
    ROUND(zomato_commission, 2),
    ROUND(taxable_amount, 2),
    ROUND(invoice_total, 2)
FROM mixed_brand_2026_ytd_clean

ORDER BY trade_name, period;






3.Calculate the average cost per invoice




SELECT
    '2024' AS period,
    trade_name,
    invoice_count,
    ROUND(invoice_total / invoice_count, 2) AS avg_invoice_total
FROM mixed_brand_2024_clean

UNION ALL

SELECT
    '2025',
    trade_name,
    invoice_count,
    ROUND(invoice_total / invoice_count, 2)
FROM mixed_brand_2025_clean

UNION ALL

SELECT
    '2026 YTD',
    trade_name,
    invoice_count,
    ROUND(invoice_total / invoice_count, 2)
FROM mixed_brand_2026_ytd_clean

ORDER BY trade_name, period;








4.Find each brand’s contribution to total Zomato expenses





WITH all_periods AS (
    SELECT '2024' AS period, trade_name, invoice_total
    FROM mixed_brand_2024_clean

    UNION ALL

    SELECT '2025', trade_name, invoice_total
    FROM mixed_brand_2025_clean

    UNION ALL

    SELECT '2026 YTD', trade_name, invoice_total
    FROM mixed_brand_2026_ytd_clean
),
brand_contribution AS (
    SELECT
        period,
        trade_name,
        invoice_total,
        ROUND(
            100.0 * invoice_total /
            SUM(invoice_total) OVER (PARTITION BY period),
            2
        ) AS expense_contribution_pct
    FROM all_periods
)
SELECT
    period,
    trade_name,
    invoice_total,
    expense_contribution_pct,
    DENSE_RANK() OVER (
        PARTITION BY period
        ORDER BY invoice_total DESC
    ) AS expense_rank
FROM brand_contribution
ORDER BY
    CASE period
        WHEN '2024' THEN 1
        WHEN '2025' THEN 2
        WHEN '2026 YTD' THEN 3
    END,
    expense_rank;





5.Monthly expense trends






SELECT
    YEAR(`Invoice Date`) AS invoice_year,
    MONTH(`Invoice Date`) AS invoice_month,
    ROUND(SUM(`Invoice Total (₹)`), 2) AS total_expenses,
    ROUND(SUM(`Zomato Commission (₹)`), 2) AS total_commission,
    ROUND(SUM(`Convenience Fee (₹)`), 2) AS total_convenience_fee
FROM mixed_invoice_2024
GROUP BY
    YEAR(`Invoice Date`),
    MONTH(`Invoice Date`)
ORDER BY
    invoice_year,
    invoice_month;





6.Year-over-year expense changes




WITH yearly_expenses AS (
    SELECT
        '2024' AS period,
        SUM(invoice_total) AS total_expenses
    FROM mixed_brand_2024_clean

    UNION ALL

    SELECT
        '2025',
        SUM(invoice_total)
    FROM mixed_brand_2025_clean

    UNION ALL

    SELECT
        '2026 YTD',
        SUM(invoice_total)
    FROM mixed_brand_2026_ytd_clean
),
comparison AS (
    SELECT
        period,
        total_expenses,
        LAG(total_expenses) OVER (
            ORDER BY CASE period
                WHEN '2024' THEN 1
                WHEN '2025' THEN 2
                WHEN '2026 YTD' THEN 3
            END
        ) AS previous_period_expenses
    FROM yearly_expenses
)
SELECT
    period,
    ROUND(total_expenses, 2) AS total_expenses,
    ROUND(previous_period_expenses, 2) AS previous_period_expenses,
    ROUND(total_expenses - previous_period_expenses, 2) AS expense_change,
    ROUND(
        100.0 * (total_expenses - previous_period_expenses)
        / NULLIF(previous_period_expenses, 0),
        2
    ) AS expense_change_pct
FROM comparison
ORDER BY CASE period
    WHEN '2024' THEN 1
    WHEN '2025' THEN 2
    WHEN '2026 YTD' THEN 3
END;







Brand-level summaries rather than individual invoice records


WITH combined_data AS (
    SELECT
        '2024' AS period,
        1 AS period_order,
        trade_name,
        invoice_count,
        convenience_fee,
        zomato_commission,
        taxable_amount,
        cgst,
        sgst,
        invoice_total
    FROM mixed_brand_2024_clean

    UNION ALL

    SELECT
        '2025',
        2,
        trade_name,
        invoice_count,
        convenience_fee,
        zomato_commission,
        taxable_amount,
        cgst,
        sgst,
        invoice_total
    FROM mixed_brand_2025_clean

    UNION ALL

    SELECT
        '2026 YTD',
        3,
        trade_name,
        invoice_count,
        convenience_fee,
        zomato_commission,
        taxable_amount,
        cgst,
        sgst,
        invoice_total
    FROM mixed_brand_2026_ytd_clean
),

brand_analysis AS (
    SELECT
        *,
        SUM(invoice_total) OVER (
            PARTITION BY period
        ) AS period_total_expenses,

        LAG(invoice_total) OVER (
            PARTITION BY trade_name
            ORDER BY period_order
        ) AS previous_brand_expenses,

        LAG(invoice_count) OVER (
            PARTITION BY trade_name
            ORDER BY period_order
        ) AS previous_invoice_count
    FROM combined_data
)

SELECT
    period,
    trade_name,

    -- 1. Expense and invoice comparison
    invoice_count,
    ROUND(invoice_total, 2) AS invoice_total,
    ROUND(
        invoice_total / NULLIF(invoice_count, 0), 2
    ) AS average_invoice_total,

    -- 2. Period-over-period expense changes
    ROUND(previous_brand_expenses, 2)
        AS previous_period_brand_expenses,

    ROUND(
        invoice_total - previous_brand_expenses, 2
    ) AS expense_change,

    ROUND(
        100.0 * (invoice_total - previous_brand_expenses)
        / NULLIF(previous_brand_expenses, 0), 2
    ) AS expense_change_pct,

    -- 3. Brand contribution
    ROUND(
        100.0 * invoice_total
        / NULLIF(period_total_expenses, 0), 2
    ) AS expense_contribution_pct,

    DENSE_RANK() OVER (
        PARTITION BY period
        ORDER BY invoice_total DESC
    ) AS expense_rank,

    -- 4. Fee composition
    ROUND(zomato_commission, 2) AS zomato_commission,
    ROUND(convenience_fee, 2) AS convenience_fee,

    ROUND(
        100.0 * zomato_commission
        / NULLIF(taxable_amount, 0), 2
    ) AS commission_pct_of_taxable,

    ROUND(
        100.0 * convenience_fee
        / NULLIF(taxable_amount, 0), 2
    ) AS convenience_fee_pct_of_taxable,

    ROUND(taxable_amount, 2) AS taxable_amount,
    ROUND(cgst + sgst, 2) AS total_gst,

    ROUND(
        taxable_amount - zomato_commission - convenience_fee, 2
    ) AS taxable_difference,

    ROUND(
        invoice_total - taxable_amount - cgst - sgst, 2
    ) AS invoice_total_difference,

    -- 5. Summary-level data-quality checks
    CASE
        WHEN invoice_count IS NULL OR invoice_count <= 0
            THEN 'Check invoice count'
        WHEN invoice_total IS NULL
          OR taxable_amount IS NULL
          OR cgst IS NULL
          OR sgst IS NULL
            THEN 'Missing financial value'
        WHEN ABS(
            invoice_total - taxable_amount - cgst - sgst
        ) > 0.05
            THEN 'Check invoice total'
        WHEN ABS(
            taxable_amount - zomato_commission - convenience_fee
        ) > 0.05
            THEN 'Check taxable components'
        ELSE 'Summary checks passed'
    END AS summary_validation_status

FROM brand_analysis
ORDER BY period_order, expense_rank;



This single query gives :-
- Expense trends: total and average invoice amounts by brand and period.
- Expense changes: absolute and percentage changes from the preceding period for each brand.
- Brand contribution: percentage of each period's invoice total contributed by each brand, plus expense ranking.
- Fee composition: commission, convenience fee, GST, and reconciliation differences.
- Summary validation: flags suspicious or incomplete summary values.
