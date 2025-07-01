-- Requirement: Customer Payments Summary Table
-- The client requested a summary table that showcases key customer-level insights for demo purposes. The goal was to present a simplified use case that highlights DBT’s transformation capabilities using modular SQL logic and CTEs.

-- Specifically, the client wanted:
-- ->A table listing each customer
-- ->The total payments made by each customer
-- ->The date of their first order
-- ->The date of their most recent order
-- ->To achieve this, we pulled data from the staging layer (stg_customers, stg_orders, stg_payments) and applied transformations in the data mart layer using CTEs for clarity and easier debugging.

{{
    config(
        Database='GOLDEN_LAYER_DB',
        schema='Analytics'
    )}}

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

-- final_table as (
--         select cl.*,pd.*
--         from customer_level_details cl
--         left join payment_details pd
--         on cl.CUSTOMER_ID = pd.CUSTOMER_ID
--         order by cl.CUSTOMER_ID
-- )
final_table as (
    select 
        cl.CUSTOMER_ID,
        cl.FIRST_ORDER,
        cl.MOST_RECENT_ORDER,
        pd.AMOUNT
    from customer_level_details cl
    left join payment_details pd
        on cl.CUSTOMER_ID = pd.CUSTOMER_ID
    order by cl.CUSTOMER_ID
)

select * from final_table 