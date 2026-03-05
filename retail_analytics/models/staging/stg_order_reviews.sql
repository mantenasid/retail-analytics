with source as (
    select * from {{ source('raw', 'raw_order_reviews') }}
),

renamed as (
    select
        review_id,
        order_id,
        review_score                        as score,
        review_comment_title                as title,
        review_comment_message              as message,
        review_creation_date::timestamp     as created_at,
        review_answer_timestamp::timestamp  as answered_at
    from source
)

select * from renamed