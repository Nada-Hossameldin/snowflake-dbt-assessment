{{ config(materialized='view') }}

with orders as (
    select
        o.o_orderkey,
        o.o_custkey,
        o.o_orderdate,
        year(o.o_orderdate) as order_year,
        o.o_totalprice as total_price,
        c.c_name as customer_name
    from {{ source('tpch', 'orders') }} o
    join {{ source('tpch', 'customer') }} c
      on o.o_custkey = c.c_custkey
)

select *
from orders
