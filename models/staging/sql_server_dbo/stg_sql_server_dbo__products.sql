WITH products_source AS (

    SELECT 
        *
    FROM {{ source('sql_server_dbo', 'products') }} a INNER JOIN 
    {{ ref('pesos') }} b ON a.name = b.planta
    WHERE _FIVETRAN_DELETED IS NULL

)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} AS product_id,
    price, 
    name,
    inventory,
    peso

FROM products_source
