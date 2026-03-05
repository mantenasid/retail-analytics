with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

-- collapse payments to one row per order
payments as (
    select
        order_id,
        sum(amount)                                             as total_payment_amount,
        -- primary payment type = the one with the highest value
        max(payment_type) filter (
            where amount = (
                select max(p2.amount)
                from {{ ref('stg_order_payments') }} p2
                where p2.order_id = stg_order_payments.order_id
            )
        )                                                       as payment_type
    from {{ ref('stg_order_payments') }}
    group by order_id
),

final as (
    select
        -- keys
        oi.order_id,
        oi.item_sequence,
        oi.product_id,
        oi.seller_id,
        c.customer_unique_id,

        -- order status (filterable in dashboard)
        o.status,

        -- timestamps
        o.ordered_at,
        o.approved_at,
        o.shipped_at,
        o.delivered_at,
        o.estimated_delivery_at,
        oi.shipping_deadline,

        -- financials
        oi.price,
        oi.freight,
        oi.price + oi.freight                                   as item_total,
        p.total_payment_amount,
        p.payment_type,

        -- delivery metrics
        case
            when o.delivered_at is not null and o.estimated_delivery_at is not null
            then extract(day from o.delivered_at - o.estimated_delivery_at)
        end                                                     as delivery_delay_days

    from order_items oi
    left join orders o
        on oi.order_id = o.order_id
    left join customers c
        on o.customer_id = c.customer_id
    left join payments p
        on oi.order_id = p.order_id
)

select * from final
