{{
    config(
        materialized='incremental',
        unique_key='order_item_id'
    )
}}

WITH order_items_source AS (

    SELECT 
        *
    FROM {{ source('sql_server_dbo', 'order_items') }}
    WHERE _FIVETRAN_DELETED IS NULL

)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} AS order_item_id,
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
    quantity,
    _fivetran_synced
FROM order_items_source

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}