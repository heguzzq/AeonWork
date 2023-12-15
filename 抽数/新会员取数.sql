select
    count(distinct t3.member_key) as register_nums,  --注册会员数
    count(distinct t4.member_key) as consume_nums,   --有消费会员数
    count(distinct t4.order_no) as consume_orders,   --订单数
    sum(total_pay_amt) as total_pay_amt
from
(
select
    member_key
from dwd.dim_member t1
inner join dwd.dim_store t2 on t1.store_key=t2.store_key
where t1.created_at>='2020-01-01 00:00:00' and t1.created_at<='2020-12-31 23:59:59'  ----根据抽数提取条件可自动设置日期
      and t2.company_business_type='GMS'
)t3
left join
(
select
member_key,
order_no,
sum(total_pay_amt) as total_pay_amt
from dwd.dwd_trade_order_sales
where pt_month between 202001 and 202012   --根据抽数提取条件可自动设置月份日期
and order_status='1090'
group by
member_key,
order_no
)t4 on t3.member_key=t4.member_key;





