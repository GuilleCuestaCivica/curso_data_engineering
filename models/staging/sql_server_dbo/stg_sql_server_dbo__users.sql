{{
    config(
        materialized='incremental',
        unique_key='user_id'
    )
}}
SELECT 
    {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS USER_ID,
    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(updated_at AS TIMESTAMP_NTZ)) AS updated_at, --UTC +2
    {{ dbt_utils.generate_surrogate_key(['ADDRESS_ID']) }} AS ADDRESS_ID,
    FIRST_NAME,
    LAST_NAME,
    CONVERT_TIMEZONE('Etc/GMT-2', 'UTC', CAST(created_at AS TIMESTAMP_NTZ)) AS created_at, --UTC +2
    {{ validar_telefono('PHONE_NUMBER') }} AS PHONE_NUMBER,
    EMAIL,
    {{ validar_gmail('EMAIL') }} AS VALID_GMAIL

FROM {{ source('sql_server_dbo', 'users') }}
WHERE _FIVETRAN_DELETED IS NULL