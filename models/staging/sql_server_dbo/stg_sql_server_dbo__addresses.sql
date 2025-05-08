{{
    config(
        materialized='incremental'
    )
}}

WITH addresses_source AS (

    SELECT 
        *
    FROM {{ source('sql_server_dbo', 'addresses') }}
    WHERE _FIVETRAN_DELETED IS NULL

)

SELECT 
    address_id,
    zipcode,  --ver en gmail el csv con las ciudades y añadir la columna
                --preguntar si poner el csv como seed o como hacerlo
    country, 
    address,
    state

FROM addresses_source
