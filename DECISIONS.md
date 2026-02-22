# DECISIONS.md

## Overview

The goal of this assignment is to ingest raw CSV data into Snowflake, transform it using dbt, and provide analytical queries answering business questions.

## Data Ingestion

The provided CSV files were ingested using **dbt seeds**.

## Tables

Raw tables: `raw_sales_data`, `raw_customer_data`

Transformed table: `transformed_sales_data`

## Handling Data Types

The raw dataset contains `ORDER_DATE` as `TEXT`.

The raw data was intentionally **not modified during ingestion**.
Instead, type casting was performed during transformation. This allows:

* A faithful representation of the source in the raw layer
* Easier debugging when source data issues occur

Transformation step:

```
TEXT → DATE using try_to_date()
```

## Data Transformation

### Staging logic

* Parse dates
* Ensure correct column types

### Final model (`transformed_sales_data`)

* Extract `year`, `month`, `day` to separate columns `order_year`, `order_month`, `order_day`.
* Compute `total_amount = quantity * price`

The dataset was verified to have **one row per order_id**, therefore aggregation per order was unnecessary.

---

## Data Quality Checks

Assumptions about the dataset were encoded as tests in sources.yml and transformed.yml in models.

### Raw data tests

`order_id` must be unique and not null.

Reason:
The correctness of monetary calculations depends on one row per order.

### Transformed data tests

* not_null constraints on key columns
* uniqueness validation on primary key

This prevents silent data corruption if upstream ingestion changes.

## 8. Reproducibility

The project can be executed with:

```
dbt seed
dbt run
dbt test
```

No manual database manipulation is required.

## Conclusion

The implementation prioritizes:

* reproducibility
* correctness
* traceability
* maintainability

The resulting warehouse structure follows modern dbt data engineering standards while remaining simple enough for a small dataset.
