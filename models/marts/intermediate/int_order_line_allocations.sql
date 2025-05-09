{{ config(materialized="incremental", unique_key="order_item_id") }}

with
    order_items as (
        select order_id, product_id, quantity
        from {{ ref("stg_sql_server_dbo__order_items") }}
    ),

    orders as (
        select
            order_id,
            address_id,
            promo_id,
            user_id,
            shipping_service,
            shipping_cost,
            created_at,
            estimated_delivery_at,
            delivered_at,
            tracking_id,
            status,
            order_cost,
            order_total
        from {{ ref("stg_sql_server_dbo__orders") }}
    ),

    products as (
        select 
            product_id, 
            name as product_name, 
            price, 
            inventory, 
            peso 
        from {{ ref("stg_sql_server_dbo__products") }}
    ),

    joined_data as (
        select
            {{ dbt_utils.generate_surrogate_key(["oi.order_id", "oi.product_id"]) }} as order_item_id,

            -- Fact fields
            oi.order_id,
            oi.product_id,
            oi.quantity,

            -- Order data
            o.address_id,
            o.promo_id,
            o.user_id,
            o.shipping_service,
            o.shipping_cost,
            o.created_at,
            o.estimated_delivery_at,
            o.delivered_at,
            o.tracking_id,
            o.status,
            o.order_cost,
            o.order_total,

            -- Product data
            p.product_name,
            p.price,
            p.inventory,
            p.peso,

            -- Reparto shipping_cost
            p.peso * oi.quantity as peso_item,
            sum(peso_item) over (partition by oi.order_id) as peso_total_pedido,
            round(
                (peso_item)
                / nullif(sum(peso_item) over (partition by oi.order_id), 0)
                * o.shipping_cost,
                2
            ) as shipping_cost_proporcional,

            -- Reparto descuento
            round((o.order_cost + o.shipping_cost) - o.order_total, 2) as promo_discount,
            round(
                oi.quantity
                / nullif(sum(oi.quantity) over (partition by oi.order_id), 0)
                * round((o.order_cost + o.shipping_cost) - o.order_total, 2),
                2
            ) as promo_discount_proporcional

        from order_items oi
        left join orders o on oi.order_id = o.order_id
        left join products p on oi.product_id = p.product_id
    )

select *
from joined_data
order by order_id
