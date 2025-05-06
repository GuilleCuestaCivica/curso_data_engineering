{{
    config(
        materialized='incremental'
    )
}}

SELECT 
    order_item_id, -- PK (definir en YAML con unique + not_null)
    order_id,
    oi.product_id,
    oi.quantity,
    oi.quantity * p.price AS total_price
FROM {{ ref('base_sql_server_dbo__order_items') }} oi
INNER JOIN {{ ref('base_sql_server_dbo__products') }} p
    ON oi.product_id = p.product_id
