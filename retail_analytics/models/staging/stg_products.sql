with source as (
    select * from {{ source('raw', 'raw_products') }}
),

translation as (
    select * from {{ source('raw', 'raw_product_category_translation') }}
),

renamed as (
    select
        p.product_id,
        p.product_category_name                     as category,
        t.product_category_name_english             as category_english,
        p.product_name_lenght                       as name_length,
        p.product_description_lenght                as description_length,
        p.product_photos_qty                        as photos_count,
        p.product_weight_g                          as weight_grams,
        p.product_length_cm                         as length_cm,
        p.product_height_cm                         as height_cm,
        p.product_width_cm                          as width_cm
    from source p
    left join translation t
        on p.product_category_name = t.product_category_name
)

select * from renamed