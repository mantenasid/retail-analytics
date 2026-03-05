with products as (
    select * from {{ ref('stg_products') }}
)

select
    product_id,
    category,
    category_english,
    name_length,
    description_length,
    photos_count,
    weight_grams,
    length_cm,
    height_cm,
    width_cm
from products
