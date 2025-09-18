# Snowflake-dbt-Assessment

This repo contains a dbt project that reads Snowflake "TPCH sample data" and builds models across staging (silver) and marts (gold) layers. All model and column documentation is stored in `models/schema.yml` and can be viewed interactively using dbt Docs.

## Models

stg_orders (silver)  
Sources data from `orders` and `customer` tables. Adds `customer_name`. Derives `order_year` (from `o_orderdate`). Keeps `total_price` column. Tested for "unique + not null" on `o_orderkey`.

customer_revenue (gold)  
Joins `orders` and `lineitem`. Computes total revenue per customer: SUM(l_extendedprice * (1 - l_discount)). Groups by `c_custkey` and includes `customer_name`. Tested for "not null" on primary key.

customer_revenue_by_year (gold)  
Aggregates yearly revenue per customer (`order_year`). Demonstrates grouping by both customer and year.

---

## How to Run

### 1. Snowflake setup
Ensure you have a warehouse `DEV_WH`, database `MAIDSCC_DB`, and schema `ANALYTICS`. Example:

```sql
CREATE WAREHOUSE DEV_WH WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
CREATE DATABASE MAIDSCC_DB;
CREATE SCHEMA MAIDSCC_DB.ANALYTICS;
````

### 2. Configure dbt profile

Add to `~/.dbt/profiles.yml`:

```yaml
snowflake_tpch_demo:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: RQXDWNP-QC05241
      user: <YOUR_USER>
      password: <YOUR_PASSWORD>
      role: ACCOUNTADMIN
      database: MAIDSCC_DB
      warehouse: DEV_WH
      schema: ANALYTICS
      threads: 4
```

### 3. Install dbt

```bash
python -m venv venv
venv\Scripts\activate   # Windows
pip install --upgrade pip
pip install dbt-core dbt-snowflake
```

### 4. Run dbt

```bash
dbt debug
dbt deps
dbt run
dbt test
dbt docs generate
dbt docs serve
```

> **Interactive Documentation:** The interactive documentation opened by `dbt docs serve` runs locally on your machine at `http://localhost:8080`. It renders all models, columns, tests, and sources defined in `schema.yml`. Anyone cloning this repo can generate and serve the docs themselves.

---

## Deliverables

**Models:**

* `models/staging/stg_orders.sql`
* `models/marts/customer_revenue.sql`
* `models/marts/customer_revenue_by_year.sql`

**Sources & Tests:** `models/schema.yml`

**Sources:** `customer`, `orders`, `lineitem`
**Tests:**

* `unique + not_null` on `o_orderkey`
* `not_null` on `c_custkey`
* Referential integrity: `orders.c_custkey` → `customer.c_custkey`

**Documentation:** All models, columns, and tests are documented in `schema.yml` and can be viewed using dbt Docs.

---

## Enhancements

* Referential integrity tests between customers and orders.
* dbt Cloud job scheduling (optional): configure a daily run job to keep models refreshed.

---

## Assumptions

* Snowflake account: `RQXDWNP-QC05241`
* Target DB/schema: `MAIDSCC_DB.ANALYTICS`
* Warehouse: `DEV_WH`

