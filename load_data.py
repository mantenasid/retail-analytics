import pandas as pd
from sqlalchemy import create_engine
import os

# Connection to PostgreSQL
engine = create_engine('postgresql://sidhanthmantena@localhost:5432/retail_analytics')

# Path to your CSV files
data_path = os.path.expanduser('~/Downloads/archive')

# Map of CSV files to table names
files = {
    'olist_customers_dataset.csv': 'raw_customers',
    'olist_geolocation_dataset.csv': 'raw_geolocation',
    'olist_order_items_dataset.csv': 'raw_order_items',
    'olist_order_payments_dataset.csv': 'raw_order_payments',
    'olist_order_reviews_dataset.csv': 'raw_order_reviews',
    'olist_orders_dataset.csv': 'raw_orders',
    'olist_products_dataset.csv': 'raw_products',
    'olist_sellers_dataset.csv': 'raw_sellers',
    'product_category_name_translation.csv': 'raw_product_category_translation'
}

# Load each CSV into PostgreSQL
for filename, table_name in files.items():
    filepath = os.path.join(data_path, filename)
    print(f'Loading {filename} into {table_name}...')
    df = pd.read_csv(filepath)
    df.to_sql(table_name, engine, schema='raw', if_exists='replace', index=False)
    print(f'Done — {len(df)} rows loaded')

print('All files loaded successfully!')