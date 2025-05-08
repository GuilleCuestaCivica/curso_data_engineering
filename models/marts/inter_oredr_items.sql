{{
    config(
        materialized='incremental'
    )
}}

WITH join_order AS (

    SELECT 
       a.product_id, b.*,c.*
    FROM {{ ref('stg_sql_server_dbo__order_items') }} a
    FULL JOIN {{ ref('stg_sql_server_dbo__orders') }} b 
        ON a.order_id = b.order_id
    FULL JOIN {{ ref('stg_sql_server_dbo__products') }} c 
        ON a.product_id = c.product_id
    

)

SELECT 
*
FROM join_order
order by order_id


   
    

