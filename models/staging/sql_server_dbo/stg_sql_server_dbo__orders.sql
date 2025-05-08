{{
    config(
        materialized='incremental'
    )
}}

WITH orders_source AS (

    SELECT 
        *
    FROM {{ source('sql_server_dbo', 'orders') }}
    WHERE _FIVETRAN_DELETED IS NULL

)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
    {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id,

    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(created_at AS TIMESTAMP_NTZ)) AS created_at,
    TO_DATE(CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(created_at AS TIMESTAMP_NTZ))) AS created_date, 
    TO_CHAR(CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(created_at AS TIMESTAMP_NTZ)), 'HH24:MI:SS') AS created_time,
    

    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(ESTIMATED_DELIVERY_AT AS TIMESTAMP_NTZ)) AS estimated_delivery_at,
    TO_DATE(CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(ESTIMATED_DELIVERY_AT AS TIMESTAMP_NTZ))) AS estimated_delivery_date, 
    TO_CHAR(CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(ESTIMATED_DELIVERY_AT AS TIMESTAMP_NTZ)), 'HH24:MI:SS') AS estimated_delivery_time,

    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(DELIVERED_AT AS TIMESTAMP_NTZ)) AS delivered_at,
    TO_DATE(CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(DELIVERED_AT AS TIMESTAMP_NTZ))) AS delivered_at_date, 
    TO_CHAR(CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(DELIVERED_AT AS TIMESTAMP_NTZ)), 'HH24:MI:SS') AS delivered_at_time,

    {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
    {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id,
    {{ dbt_utils.generate_surrogate_key(['tracking_id']) }} AS tracking_id,

    shipping_service,
    shipping_cost,
    status

FROM orders_source
