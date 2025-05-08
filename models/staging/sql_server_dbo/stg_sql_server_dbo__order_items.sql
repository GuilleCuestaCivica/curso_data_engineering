{{
    config(
        materialized='incremental'
    )
}}

WITH order_items_source AS (

    SELECT 
        *
    FROM {{ source('sql_server_dbo', 'order_items') }}
    WHERE _FIVETRAN_DELETED IS NULL

)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
    quantity
FROM order_items_source
