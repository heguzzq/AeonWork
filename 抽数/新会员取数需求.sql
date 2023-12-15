--年度汇总
select
    count(distinct t3.member_key) as register_nums,  --注册会员数
    count(distinct t4.member_key) as consume_nums,   --有消费会员数
    count(distinct t4.order_no) as consume_orders,   --订单数
    sum(total_pay_amt) as total_pay_amt
from
(
select
    member_key
from dwd.dim_member t1  --dwd.dim_member_membership会籍表
inner join dwd.dim_store t2 on t1.store_key=t2.store_key
where t1.created_at>='2021-01-01 00:00:00' and t1.created_at<='2021-12-31 23:59:59'  ----根据抽数提取条件可自动设置日期
      and t2.company_business_type='GMS'
group by member_key
)t3
left join
(
select
member_key,
order_no,
sum(total_pay_amt) as total_pay_amt
from dwd.dwd_trade_order_sales t1
inner join  dwd.dim_store t2 on t1.store_key=t2.store_key
where pt_month  between  202201 and 202212  --根据抽数提取条件可自动设置月份日期
  and t2.company_business_type='GMS'
and order_status=1090
group by
member_key,
order_no
)t4 on t3.member_key=cast(t4.member_key as string);




--月度汇总


select
    t3.pt_month,
    count(distinct t3.member_key) as register_nums,  --注册会员数
    count(distinct t4.member_key) as consume_nums,   --有消费会员数
    count(distinct t4.order_no) as consume_orders,   --订单数
    sum(total_pay_amt) as total_pay_amt
from
(
select
    member_key,
   from_unixtime(unix_timestamp(t1.created_at),'yyyyMM') as pt_month
   --from_unixtime(unix_timestamp(months_add(t1.created_at,1)),'yyyyMM')as pt_month  计算次月消费
from dwd.dim_member t1  --dwd.dim_member_membership会籍表
inner join dwd.dim_store t2 on t1.store_key=t2.store_key
where t1.created_at>='2020-01-01 00:00:00' and t1.created_at<='2023-04-30 23:59:59'  ----根据抽数提取条件可自动设置日期
      and t2.company_business_type='GMS'
group by member_key,from_unixtime(unix_timestamp(t1.created_at),'yyyyMM')
)t3
left join
(
select
member_key,
order_no,
pt_month,
sum(total_pay_amt) as total_pay_amt
from dwd.dwd_trade_order_sales t1
inner join  dwd.dim_store t2 on t1.store_key=t2.store_key
where pt_month  between  202001 and 202305  --根据抽数提取条件可自动设置月份日期
  and t2.company_business_type='GMS'
and order_status=1090
group by
member_key,
order_no,
pt_month
)t4 on t3.member_key=cast(t4.member_key as string) and t3.pt_month=cast(t4.pt_month as string)
group by t3.pt_month;