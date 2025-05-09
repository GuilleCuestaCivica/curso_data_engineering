WITH
    users AS (
        SELECT
            user_id,
            updated_at,  -- UTC +2
            address_id,
            first_name,
            last_name,
            created_at,  -- UTC +2
            phone_number,
            email,
            valid_gmail
        FROM {{ ref("stg_sql_server_dbo__users") }}
    ),

    orders AS (
        SELECT 
            user_id,
            order_id,
            order_total
        FROM {{ ref("stg_sql_server_dbo__orders") }}
    ),

    aggregated_orders AS (
        SELECT
            user_id,
            COUNT(order_id) AS total_pedidos_usuario,
            SUM(order_total) AS total_gastado_usuario
        FROM orders
        GROUP BY user_id
    ),

    joined_data AS (
        SELECT
            u.user_id,
            u.updated_at,
            u.address_id,
            u.first_name,
            u.last_name,
            u.created_at,
            u.phone_number,
            u.email,
            u.valid_gmail,
            ao.total_pedidos_usuario,
            ao.total_gastado_usuario
        FROM users u
        LEFT JOIN aggregated_orders ao ON u.user_id = ao.user_id
    )

SELECT *
FROM joined_data
ORDER BY user_id
