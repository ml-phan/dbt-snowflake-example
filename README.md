# Snowflake Data Warehouse with dbt

## Overview

This project builds a small analytical data warehouse in **Snowflake** using **dbt**.
It ingests raw CSV data, transforms it into an analytics-ready table, validates data quality, and provides SQL queries answering business questions.

The workflow follows a layered architecture:

```
CSV files → RAW (seed) → TRANSFORMED (dbt model) → Analytical Queries
```

---

## Project Structure
These are the relevant files and folders in the project:

```
data/
  customers.csv
  sales.csv

dbt_banxware_assignment/
  models/              dbt transformation models
  seeds/               raw input tables
  tests/               data tests
  queries/             analytical SQL answers
  dbt_project.yml
```

---

## Requirements

* Python 3.13+
* Snowflake account (trial is sufficient)
* Python library: dbt-snowflake

---

## Setup Instructions

### 1) Create Python environment

Recommended using conda 

```bash
conda create -n dbt-env python=3.13
conda activate dbt-env
```
or venv.
```bash
python -m venv venv
venv\Scripts\activate      # Windows
# source venv/bin/activate # Mac/Linux
```

Install dbt Snowflake adapter:

```bash
pip install dbt-snowflake
```

---

### 2) Configure Snowflake

Create a database in Snowflake:

```sql
CREATE DATABASE HOME_ASSIGNMENT;
```

---

### 3) Configure dbt profile

Create the file:

```
C:\Users\<your_user>\.dbt\profiles.yml
```

Example configuration:

```yaml
banxware_assignment:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <account_identifier>
      user: <username>
      password: <password>
      role: ACCOUNTADMIN
      warehouse: COMPUTE_WH
      database: HOME_ASSIGNMENT
      schema: PUBLIC
      threads: 4
```

Validate connection:

```bash
dbt debug
```

---

## Running the Pipeline

Execute the following commands inside the `dbt_banxware_assignment` folder.

### 1) Ingest raw data

Creates raw tables in Snowflake

```bash
dbt seed
```
Two tables will be created.
```
HOME_ASSIGNMENT.PUBLIC.RAW_CUSTOMERS_DATA
HOME_ASSIGNMENT.PUBLIC.RAW_SALES_DATA
```
### 2) Run transformations

Builds analytics tables.

```bash
dbt run
```

### 3) Validate data quality

Runs uniqueness and null checks.

```bash
dbt test
```

After these steps the transformed table will be created:

```
HOME_ASSIGNMENT.PUBLIC.TRANSFORMED_SALES_DATA
```

---

## Running Analytical Queries

The `queries/` folder contains SQL files answering the business questions.

Open Snowflake → Worksheets and run each file manually against:

```
HOME_ASSIGNMENT.ANALYTICS.TRANSFORMED_SALES_DATA
```

These queries are intentionally written as plain SQL (not dbt models) to allow direct execution by analysts.

---

## Reproducibility

From a fresh clone, the entire project can be built with:

```bash
dbt seed
dbt run
dbt test
```

No manual table creation or data uploads are required.

---

## Notes

* Raw data remains unchanged during ingestion
* Transformations are handled in dbt models
* Data assumptions are enforced using tests
* Queries are separated from transformation

---

## Author

Manh Linh Phan
