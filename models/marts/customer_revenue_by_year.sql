{{ config(materialized='table') }}

with order_revenue as (
    select
        o.o_orderkey,
        o.o_custkey,
        year(o.o_orderdate) as order_year,
        sum(l.l_extendedprice * (1 - l.l_discount)) as revenue
    from {{ source('tpch', 'orders') }} o
    join {{ source('tpch', 'lineitem') }} l
      on o.o_orderkey = l.l_orderkey
    group by o.o_orderkey, o.o_custkey, year(o.o_orderdate)
),

customer_revenue as (
    select
        c.c_custkey as customer_id,
        c.c_name as customer_name,
        orv.order_year,
        sum(orv.revenue) as total_revenue
    from order_revenue orv
    join {{ source('tpch', 'customer') }} c
      on orv.o_custkey = c.c_custkey
    group by c.c_custkey, c.c_name, orv.order_year
)

select *
from customer_revenue
