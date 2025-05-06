select 
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} AS product_id,
    price, --pasar de comas a puntos y ver si la moneda es la misma
    name,
    inventory
    --macro para fivetram_deleted.
from {{source('sql_server_dbo', 'products')}}