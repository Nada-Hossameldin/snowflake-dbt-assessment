{{ config(materialized='table') }}


with orders as (
select
o_orderkey,
o_custkey
from {{ ref('stg_orders') }}
),
lineitems as (
select
l_orderkey,
l_extendedprice,
l_discount
from {{ source('tpch_sf1', 'lineitem') }}
)


select
o.o_custkey as c_custkey,
max(s.customer_name) as customer_name,
sum(l.l_extendedprice * (1 - l.l_discount)) as total_revenue
from orders o
join lineitems l
on o.o_orderkey = l.l_orderkey
left join {{ source('tpch_sf1','customer') }} s
on o.o_custkey = s.c_custkey
group by o.o_custkey