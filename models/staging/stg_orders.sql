with raw as (

    select * from {{source("Snowflake_Source","raw_orders")}}
),

final as (

    select id as ORDER_ID,
    USER_ID,
    STATUS
    from raw
)
select * from final