WITH promos_source AS (

    SELECT 
        {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} AS PROMO_ID,
        DISCOUNT AS DISCOUNT_EUROS,
        STATUS,
        PROMO_ID AS DESC_PROMO
    FROM {{ source('sql_server_dbo', 'promos') }}
    WHERE _FIVETRAN_DELETED IS NULL

),

no_promo_row AS (

    SELECT 
        {{ dbt_utils.generate_surrogate_key(["''"]) }} AS PROMO_ID,
        0 AS DISCOUNT_EUROS,
        '' AS STATUS,
        '' AS DESC_PROMO
)

SELECT * FROM promos_source

UNION ALL

SELECT * FROM no_promo_row
