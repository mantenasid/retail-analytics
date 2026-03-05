with customers as (
    select * from {{ ref('stg_customers') }}
)

select
    customer_unique_id,
    -- a customer can have multiple customer_ids (one per order)
    -- we take the most recent city/state in case they moved
    max(city)   as city,
    max(state)  as state
from customers
group by customer_unique_id
