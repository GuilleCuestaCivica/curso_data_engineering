{{
    config(
        materialized='incremental'
    )
}}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS shipping_id,
    shipping_service,
    shipping_cost,
    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(created_at AS TIMESTAMP_NTZ)) AS created_at, --UTC +2
    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(ESTIMATED_DELIVERY_AT AS TIMESTAMP_NTZ)) AS ESTIMATED_DELIVERY_AT, --UTC +2
    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(DELIVERED_AT AS TIMESTAMP_NTZ)) AS DELIVERED_AT, --UTC +2
    -- DATEDIFF(day, created_at_utc, delivered_at_utc) AS days_to_deliver, ver si se hace ya o en gold.
    {{ dbt_utils.generate_surrogate_key(['tracking_id']) }} AS tracking_id,
    status
FROM {{ source('sql_server_dbo', 'orders') }}