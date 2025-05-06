{{
    config(
        materialized='incremental'
    )
}}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS shipping_id, --preguntar
    {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id,
    -- CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(created_at AS TIMESTAMP_NTZ)) AS created_at, --UTC +2
    --fecha y hora como tal
    {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
    {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id
FROM {{ source('sql_server_dbo', 'orders') }}