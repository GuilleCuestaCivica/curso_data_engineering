select 
    {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as PROMO_ID,
	DISCOUNT as DISCOUNT_EUROS ,
	STATUS ,
    PROMO_ID as DESC_PROMO
FROM {{ source('sql_server_dbo', 'promos') }}
WHERE _FIVETRAN_DELETED IS NULL

UNION ALL

select 
    {{ dbt_utils.generate_surrogate_key(["''"]) }} as promo_id,
    0 as DISCOUNT_EUROS,
    '' as status,
    '' as desc_promo
    