with sales as
         (select member_key
          from (select member_key, max(flag1) flag1
                from (select member_key,

                             case
                                 when    ABS(datediff(from_unixtime(unix_timestamp(cast (datekey as string), 'yyyyMMdd'),  'yyyy-MM-dd'),
                                          from_unixtime(unix_timestamp('20221115', 'yyyyMMdd'), 'yyyy-MM-dd'))) < 365
                                     then 1
                                 else 0 end as flag1
                      from dwd.dwd_trade_order_sales
                      where pt_month > 202109
                        and pt_month <= 202211
                        and datekey >= 20211115
                        and datekey <= 20221115
                        and region_code in('QDA','ACH','AHB','AHD','ABJ','MGZ')
                        and order_status=1090
                      and is_deleted=0
                          ) t3
                group by member_key) t
          where flag1 = 1
           )
--截止至2022.11.15,休眠会员数（注册时间在一年以上且近一年无消费的会员）
select
    count(distinct t5.member_id) as cnt,
    sum(t6.total_amt) as total_amt

from
(
select
   distinct t3.member_id

from
(
select
distinct
t1.member_id

from dwd.dim_member_membership t1
left join sales t2 on t1.member_id=t2.member_key
where t1.deleted = 0  and t1.created_at <'2021-11-15' and t2.member_key is null AND t1.corporation_code in ('101','201','301','701','801','002','003')
    )t3
    left join(
--2020.11.16~2021.11.15的消费人数
	select
	member_key
  from dwd.dwd_trade_order_sales
   where     pt_month <= 202111
                        and pt_month>=202011
                        and datekey >= 20201116
                        and datekey <= 20211115
                        and region_code in('QDA','ACH','AHB','AHD','ABJ','MGZ')
                        and order_status=1090
                      and is_deleted=0
    group by member_key
)t4 on t3.member_id=t4.member_key
    where t4.member_key is null
    )t5

inner join
    (
--2019.11.16~2020.11.15的消费人数  会员范围:休眠会员数减去2020.11.16~2021.11.15的消费人数
	select
	member_key,
	sum(total_amt) as total_amt

  from dwd.dwd_trade_order_sales
   where     pt_month <= 202011
                        and pt_month>=201911
                        and datekey >= 20191116
                        and datekey <= 20201115
                        and region_code in('QDA','ACH','AHB','AHD','ABJ','MGZ')
                        and order_status=1090
                      and is_deleted=0
   group by member_key
)t6 on t5.member_id=t6.member_key;


