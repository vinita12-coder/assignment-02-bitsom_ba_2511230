# ETL Decisions for Data Warehouse

## ETL Decisions

### Decision 1 — Date Format Standardization

**Problem:** 
The raw `retail_transactions.csv` contains dates in three different formats:
- DD/MM/YYYY format: `29/08/2023`, `15/08/2023`
- DD-MM-YYYY format: `12-12-2023`, `20-02-2023`, `28-04-2023`
- YYYY-MM-DD format: `2023-02-05`, `2023-01-15`

This inconsistency makes date filtering and sorting difficult in analytical queries. Different date formats can also cause parsing errors and misinterpretation (e.g., `02-05-2023` could be February 5 or May 2 depending on locale).

**Resolution:**
Standardized all dates to the ISO 8601 format (YYYY-MM-DD) during the ETL process before loading into the `dim_date` dimension table. This ensures:
- Consistent date comparisons across queries
- Automatic timezone and locale independence
- Proper sorting and filtering by date ranges
- Prevention of ambiguous date interpretations

When loading the data, each date string was parsed and converted to the standard format, and then stored in the `dim_date` table. This allows the fact table to reference dates by `date_id`, avoiding redundant date storage and potential inconsistencies.

---

### Decision 2 — Category Name Standardization

**Problem:**
The raw data shows category values with inconsistent casing and terminology:
- Some entries use `electronics` (lowercase)
- Some use `Electronics` (title case)
- Some use `Grocery` (singular)
- Some use `Groceries` (plural)
- Same issue with `Clothing`

This inconsistency causes queries to return unexpected results when filtering by category (e.g., searching for `category = 'Electronics'` would miss records with `electronics`). It also creates unnecessary category duplicates in dimension tables.

**Resolution:**
Implemented a data cleaning process where all category values were standardized to title case (e.g., `Electronics`, `Clothing`, `Grocery`). The cleaning logic:
1. Converted all category values to lowercase
2. Applied title case transformation to the first letter
3. Standardized plural/singular naming (using singular form: `Grocery` not `Groceries`)
4. Validated against a master list of valid categories: Electronics, Clothing, Grocery

This ensures:
- Single, consistent entry per category in `dim_product`
- No duplicate dimension records
- Accurate and complete category-based analytics
- Case-insensitive querying now returns correct results

---

### Decision 3 — Null Value Handling in Units Sold and Unit Price

**Problem:**
During exploration of the raw data, some transaction records had:
- Missing or NULL values in `units_sold`
- Missing or NULL values in `unit_price`
- These fields are critical for calculating `sales_amount` (revenue)

A record with NULL `units_sold` or NULL `unit_price` cannot be accurately analyzed for revenue calculations.

**Resolution:**
Implemented a three-tier approach:

1. **Detection**: Identified all records where `units_sold` or `unit_price` is NULL or missing
2. **Validation**: For records with NULL `unit_price`, looked up the standard price from a reference product list
3. **Exclusion**: Records with NULL `units_sold` were excluded from the fact table, as quantity is fundamental to the sale

For the data warehouse load, only complete and valid transaction records were inserted. The validation rules ensured:
- Every fact record has non-NULL `units_sold` and `unit_price`
- All `sales_amount` values are correctly calculated as `units_sold × unit_price`
- Data quality metrics are maintained (100% completeness for key measures)
- Analytical queries return accurate, unbiased results

This approach prioritizes data integrity over data volume — it's better to load fewer, high-quality records than to load incomplete data that would skew analytics.

---

## Summary

These three ETL decisions—standardizing dates, categories, and handling nulls—transformed the raw, inconsistent transactional data into a clean, reliable data warehouse suitable for business intelligence and analytical reporting.
