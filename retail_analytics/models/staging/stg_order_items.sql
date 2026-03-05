with source as (
    select * from {{ source('raw', 'raw_order_items') }}
),

renamed as (
    select
        order_id,
        order_item_id                       as item_sequence,
        product_id,
        seller_id,
        shipping_limit_date::timestamp      as shipping_deadline,
        price,
        freight_value                       as freight
    from source
)

select * from renamed
