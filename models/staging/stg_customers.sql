with raw as (

    select * from {{source("Snowflake_Source","raw_customers")}}
),

final as (

    select id as CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME
    from raw
)
select * from final