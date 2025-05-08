WITH products_source AS (

    SELECT 
        *
    FROM {{ source('sql_server_dbo', 'products') }}
    WHERE _FIVETRAN_DELETED IS NULL

)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} AS product_id,
    price, --pasar de comas a puntos y ver si la moneda es la misma
    name,
    inventory

FROM products_source
