with sellers as (
    select * from {{ ref('stg_sellers') }}
)

select
    seller_id,
    city,
    state,
    zip_code
from sellers
