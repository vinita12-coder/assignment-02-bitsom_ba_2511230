## ETL Decisions 
### Decision 1 — Standardize Date Formats
Problem: Input dates were inconsistent: DD/MM/YYYY (105 rows), DD-MM-YYYY (83 rows), and YYYY-MM-DD (112 rows). Keeping mixed formats would break chronological sorting and date calculations in analytics.

Solution: Convert all dates to YYYY-MM-DD before loading into dim_date. Create date_key as YYYYMMDD (e.g., 20230829) and use it as the join key between fact_sales and dim_date.


### Decision 2 — Normalize Category Casing
Problem: Category values were inconsistent; e.g., "Electronics" and "electronics" treated as separate, "Grocery" and "Groceries" were semantically same but split. This causes bad grouping in revenue reports.

Solution: Normalize category text to consistent title case and naming ("electronics" → "Electronics", "Grocery" → "Groceries"), then load cleaned values into dim_product.


### Decision 3 — Impute NULL store_city
Problem: 19 records had empty store_city. Since store-level reporting relies on city, leaving NULL would exclude those records from city-grouped queries.

Solution: Use store_name (always present) and known store-city mapping from non-null rows to fill missing store_city. Example: all Mumbai Central rows were assigned Mumbai.
