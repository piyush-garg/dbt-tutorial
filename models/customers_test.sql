with customerscli as (

    select
        id as customer_id,
        first_name,
        last_name

    from raw1.jaffle_shop.customers

),

orderscli as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from raw1.jaffle_shop.orders

),

customer_orders_cli as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orderscli

    group by 1

),

finalcli as (

    select
        customerscli.customer_id,
        customerscli.first_name,
        customerscli.last_name,
        customer_orders_cli.first_order_date,
        customer_orders_cli.most_recent_order_date,
        coalesce(customer_orders_cli.number_of_orders, 0) as number_of_orders

    from customerscli

    left join customer_orders_cli using (customer_id)

)

select * from finalcli