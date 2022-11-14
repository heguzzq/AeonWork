with sales as
         (select member_key
          from (select member_key, max(flag1) flag1
                from (select member_key,

                             case
                                 when    ABS(datediff(from_unixtime(unix_timestamp(sales_trans_datekey, 'yyyyMMdd'),  'yyyy-MM-dd'),
                                          from_unixtime(unix_timestamp('20221110', 'yyyyMMdd'), 'yyyy-MM-dd'))) < 365
                                     then 1
                                 else 0 end as flag1
                      from dwd.dwd_trade_profit_sale_header
                      where pt_month > 202109
                        and pt_month <= 202211
                        and sales_trans_datekey > '20211110'
                        and sales_trans_datekey <= '20221110'
                        and length(store_key) = 4) t3
                group by member_key) t
          where flag1 = 1
           )


select
t4.member_key
,t4.ext_net_sell_tot
from
(
select

distinct  t1.member_id

from dwd.dim_member t1
left join sales t2 on t1.member_id=t2.member_key
where t1.member_status <> '1' and register_time <'2021-11-10' and t2.member_key is null AND t1.corporation_code in ('101','201','301','701','801','002','003')

)t3 inner join(

	select
	member_key,
	ext_net_sell_tot

  from dwd.dwd_trade_profit_sale_header
  where
                         pt_month <= 202111
                        and sales_trans_datekey < '20211110'
                        and length(store_key) = 4
)t4 on t3.member_id=t4.member_key






	select
	member_key,
	ext_net_sell_tot

  from dwd.dwd_trade_profit_sale_header
  where
                         pt_month <= 202111
                        and sales_trans_datekey < '20211110'
                        and length(store_key) = 4
and member_key='10000014915634'