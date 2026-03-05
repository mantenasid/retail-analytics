# Retail Analytics Pipeline

An end-to-end data engineering project built on the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Raw retail data is ingested, cleaned, modeled into a star schema, and visualized in a dashboard.

---

## Stack

| Layer | Tool |
|---|---|
| Database | PostgreSQL |
| Transformation | dbt |
| Ingestion | Python (pandas, SQLAlchemy) |
| Exploration | Jupyter Notebook |
| Visualization | Power BI |

---

## Pipeline Architecture

```
Raw CSVs (9 files)
    ↓ Python (load_data.py)
PostgreSQL — raw schema
    ↓ dbt staging models
PostgreSQL — staging schema (views)
    ↓ dbt marts models
PostgreSQL — marts schema (tables)
    ↓ Power BI
Dashboard
```

---

## Project Structure

```
retail-analytics/
├── load_data.py                        # Loads CSV files into PostgreSQL raw schema
├── retail_analytics/                   # dbt project
│   ├── dbt_project.yml                 # Project config, materialization settings
│   ├── models/
│   │   ├── staging/                    # 1-to-1 cleaned views of raw tables
│   │   │   ├── sources.yml             # Raw source table declarations
│   │   │   ├── stg_customers.sql
│   │   │   ├── stg_orders.sql
│   │   │   ├── stg_order_items.sql
│   │   │   ├── stg_order_payments.sql
│   │   │   ├── stg_order_reviews.sql
│   │   │   ├── stg_products.sql        # Includes English category translation
│   │   │   └── stg_sellers.sql
│   │   └── marts/                      # Star schema, analysis-ready tables
│   │       ├── dim_customers.sql
│   │       ├── dim_products.sql
│   │       ├── dim_sellers.sql
│   │       └── fct_order_items.sql     # Fact table at order-item grain
│   └── data_exploration.ipynb          # EDA notebook
```

---

## Data Model

### Star Schema

```
dim_customers ──┐
dim_products  ──┼──→ fct_order_items
dim_sellers   ──┘
```

**`fct_order_items`** — one row per order item (112,650 rows)
- Keys: `order_id`, `product_id`, `seller_id`, `customer_unique_id`
- Measures: `price`, `freight`, `item_total`, `total_payment_amount`
- Attributes: `status`, all order timestamps, `delivery_delay_days`, `payment_type`

**`dim_customers`** — 96,096 unique customers

**`dim_products`** — 32,951 products with English category names

**`dim_sellers`** — 3,095 sellers

---

## Setup

**Prerequisites:** PostgreSQL, Python 3.8+, dbt-postgres

```bash
# 1. Create conda environment
conda create -n retail-analytics python=3.10
conda activate retail-analytics
pip install pandas sqlalchemy psycopg2-binary dbt-postgres jupyter

# 2. Create PostgreSQL database
createdb retail_analytics

# 3. Load raw data
python load_data.py

# 4. Run dbt models
cd retail_analytics
dbt run
```

---

## Process

1. **Environment setup** — conda environment, PostgreSQL, dbt, Python packages
2. **Data ingestion** — load 9 raw CSV files into PostgreSQL via Python
3. **Exploratory analysis** — understand the data shape, nulls, relationships, and edge cases
4. **Staging layer** — clean and standardize each raw table into consistent views
5. **Dimensional modeling** — build a star schema optimized for reporting
6. **Data quality tests** — automated checks for nulls, uniqueness, and referential integrity
7. **Documentation** — describe every model and column, generate lineage graph
8. **Dashboard** — connect Power BI to the marts layer and build visualizations
