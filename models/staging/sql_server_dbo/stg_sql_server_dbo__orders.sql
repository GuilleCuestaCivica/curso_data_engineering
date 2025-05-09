{{ config(materialized="incremental", unique_key="order_id") }}

with
    orders_source as (

        select *
        from {{ source("sql_server_dbo", "orders") }}
        where _fivetran_deleted is null

    )

select
    {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as order_id,
    {{ dbt_utils.generate_surrogate_key(["address_id"]) }} as address_id,

    convert_timezone(
        'Etc/GMT-2', 'UTC', cast(created_at as timestamp_ntz)
    ) as created_at,
    to_date(
        convert_timezone('Etc/GMT-2', 'UTC', cast(created_at as timestamp_ntz))
    ) as created_date,
    to_char(
        convert_timezone('Etc/GMT-2', 'UTC', cast(created_at as timestamp_ntz)),
        'HH24:MI:SS'
    ) as created_time,

    convert_timezone(
        'Etc/GMT-2', 'UTC', cast(estimated_delivery_at as timestamp_ntz)
    ) as estimated_delivery_at,
    to_date(
        convert_timezone(
            'Etc/GMT-2', 'UTC', cast(estimated_delivery_at as timestamp_ntz)
        )
    ) as estimated_delivery_date,
    to_char(
        convert_timezone(
            'Etc/GMT-2', 'UTC', cast(estimated_delivery_at as timestamp_ntz)
        ),
        'HH24:MI:SS'
    ) as estimated_delivery_time,

    convert_timezone(
        'Etc/GMT-2', 'UTC', cast(delivered_at as timestamp_ntz)
    ) as delivered_at,
    to_date(
        convert_timezone('Etc/GMT-2', 'UTC', cast(delivered_at as timestamp_ntz))
    ) as delivered_at_date,
    to_char(
        convert_timezone('Etc/GMT-2', 'UTC', cast(delivered_at as timestamp_ntz)),
        'HH24:MI:SS'
    ) as delivered_at_time,

    {{ dbt_utils.generate_surrogate_key(["promo_id"]) }} as promo_id,
    {{ dbt_utils.generate_surrogate_key(["user_id"]) }} as user_id,
    {{ dbt_utils.generate_surrogate_key(["tracking_id"]) }} as tracking_id,

    order_cost,
    order_total,
    shipping_service,
    shipping_cost,
    status,
    _fivetran_synced

from orders_source

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
