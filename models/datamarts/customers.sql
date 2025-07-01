with customers as (
        select * from {{ref('stg_customers')}}

),
orders as (
        select * from {{ref('stg_orders')}}

),
payments as (
        select * from {{ref('stg_payments')}}

),
customer_level_details as (
    select
    -- c.FIRST_NAME,
    -- c.LAST_NAME,
    c.CUSTOMER_ID,
    MIN(o.ORDER_DATE) AS FIRST_ORDER,
    MAX(o.ORDER_DATE) as most_recent_order
    from customers c 
    left join orders o
    on c.CUSTOMER_ID = o.CUSTOMER_ID
    group by c.FIRST_NAME ,c.LAST_NAME,c.CUSTOMER_ID

),
payment_details as(
        select
        o.CUSTOMER_ID,
        sum(p.AMOUNT) as AMOUNT
        from payments p
        LEFT JOIN orders o 
        on p.ORDER_ID= o.ORDER_ID
        group by o.CUSTOMER_ID
        order by o.CUSTOMER_ID

) ,

final_table as (
        select cl.*,pd.*
        from customer_level_details cl
        left join payment_details pd
        on cl.CUSTOMER_ID = pd.CUSTOMER_ID
        order by cl.CUSTOMER_ID
)

select * from final_table