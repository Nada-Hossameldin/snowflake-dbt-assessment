{{ config(materialized='view') }}


with raw_orders as (
select
o_orderkey,
o_custkey,
o_orderstatus,
o_totalprice,
o_orderdate,
o_orderpriority,
o_clerk,
o_shippriority,
o_comment
from {{ source('tpch_sf1', 'orders') }}
),
customers as (
select c_custkey, c_name from {{ source('tpch_sf1', 'customer') }}
)


select
ro.*,
c.c_name as customer_name,
extract(year from ro.o_orderdate) as order_year,
ro.o_totalprice as total_price
from raw_orders ro
left join customers c
on ro.o_custkey = c.c_custkey