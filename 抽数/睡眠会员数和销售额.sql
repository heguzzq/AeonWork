with sales as
         (select count(distinct member_key)
          from (select t1.member_key,

                       max(case
                               when
                                           ABS(datediff(from_unixtime(unix_timestamp(sales_trans_datekey, 'yyyyMMdd'),
                                                                      'yyyy-MM-dd'),
                                                        from_unixtime(unix_timestamp('20221110', 'yyyyMMdd'), 'yyyy-MM-dd'))) <
                                           365
                                       and ABS(datediff(
                                           from_unixtime(unix_timestamp(register_time, 'yyyyMMdd'), 'yyyy-MM-dd'),
                                           from_unixtime(unix_timestamp(sales_trans_datekey, 'yyyyMMdd'),
                                                         'yyyy-MM-dd'))) >= 0
                                   then 1
                               else 0 end)    flag1,
                       max(case
                               when ABS(datediff(
                                       from_unixtime(unix_timestamp(sales_trans_datekey, 'yyyyMMdd'), 'yyyy-MM-dd'),
                                       from_unixtime(unix_timestamp('20221110', 'yyyyMMdd'), 'yyyy-MM-dd'))) < 181
                                   and
                                    ABS(datediff(from_unixtime(unix_timestamp(register_time, 'yyyyMMdd'), 'yyyy-MM-dd'),
                                                 from_unixtime(unix_timestamp(sales_trans_datekey, 'yyyyMMdd'),
                                                               'yyyy-MM-dd'))) >= 0
                                   then 1
                               else 0 end) as flag2
                from dwd.dwd_trade_profit_sale_header t1
                         inner join dwd.dim_member t2 on t1.member_key = t2.member_id
                where pt_month > 202109
                  and pt_month <= 202211
                  and sales_trans_datekey > 20211110
                  and sales_trans_datekey < 20221110
                group by t1.member_key) t3
          where flag1 - flag2 = 1)


select sum(ext_net_sell_tot) as ext_net_sell_tot,
       count(distinct t1.member_key)

from dwd.dwd_trade_profit_sale_header t1
         inner join sales t2 on t1.member_key = t2.member_key
         inner join dwd.dim_member t3 on t1.member_key = t3.member_id and t3.member_status <> '1'
where pt_month > 202109
  and pt_month <= 202209
			 
			 
			 
			 
			 
			 
			 
