
select 
    {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as PROMO_ID,
    DISCOUNT as DISCOUNT_EUROS ,
    STATUS ,
    PROMO_ID as DESC_PROMO
FROM {{ source('sql_server_dbo', 'promos') }}

UNION ALL

select 
    {{ dbt_utils.generate_surrogate_key(["''"]) }} as PROMO_ID,
    0 as DISCOUNT_EUROS,
    'inactive' as STATUS,
    'Nothing' as DESC_PROMO

