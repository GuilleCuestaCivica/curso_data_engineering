select 
    address_id,
    zipcode, 
    country, --todos en el mismo idioma
    address,
    state
    --macro para fivetram_deleted.
from {{source('sql_server_dbo', 'addresses')}}