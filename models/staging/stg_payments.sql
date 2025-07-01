{{ config(
    database='STAGING',
    schema='stg'
) }}

with raw as (

    select * from {{source("Snowflake_Source","raw_payments")}}
),

final as (

    select id as PAYMENT_ID,
    ORDER_ID,
    PAYMENT_METHOD AS PAYMENT_MODE,
    AMOUNT/100 AS AMOUNT

    from raw
)
select * from final