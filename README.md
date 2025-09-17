# snowflake-dbt-assessment


This repo contains a dbt project that reads Snowflake TPCH sample data and builds two models:


- `stg_orders` (silver): orders + customer name + order_year
- `customer_revenue` (gold): revenue per customer


## How to run


1. Ensure Snowflake setup: run the SQL in `setup_sql.sql` (or the commands below) to create `MAIDSCC_DB` and `ANALYTICS` schema and `DEV_WH` warehouse.
2. Update `~/.dbt/profiles.yml` with your Snowflake credentials (account, user, password). Use the profile name `maidscc`.
3. Activate Python virtualenv and install dbt:


```bash
python -m venv venv
venv\Scripts\activate # Windows
pip install --upgrade pip
pip install dbt-core dbt-snowflake
```


4. From project root run:


```bash
dbt debug
dbt deps
dbt run --select stg_orders customer_revenue
dbt test
dbt docs generate
dbt docs serve
```


## Deliverables
- Models: `models/staging/stg_orders.sql`, `models/marts/customer_revenue.sql`
- Source & tests: `models/schema.yml`
- README


## Assumptions
- Snowflake account: `RQXDWNP-QC05241` 
- Target DB/schema: `MAIDSCC_DB.ANALYTICS`
- Warehouse: `DEV_WH`