with sale_a as (select t1.member_key
                      ,t1.store_key
                      ,sum(t1.total_pay_amt) as total_pay_amt
                      ,count(t1.order_no)    as orders
                from dwd.dwd_trade_order_sales t1
                inner join dwd.dim_mall_shop t2 on t1.store_key = t2.store_code
                where t1.pt_month = 202212
                  and t1.order_status = '1090'
                  and t1.corporation_code = 'SC02017'
                  and t1.order_time_key = 20221231
                --  and t1.store_key in ('MA00966', 'MA00972')   10000005300106 MA01051  MA01061  MA04487
                and member_key in('10000005910866','10000013136923','10000013809904')
                group by t1.store_key,t1.member_key
                )

select

    t1.member_key,

    concat_ws(',',concat(t1.store_key,'+',t2.store_key)) as store_code,
    sum(t1.total_pay_amt+t2.total_pay_amt) as pay_amt,
    sum(t1.orders+t2.orders) as orders
from sale_a t1
left join sale_a t2 on t1.member_key = t2.member_key
where t1.store_key > t2.store_key
group by t1.member_key,t1.store_key,t2.store_key



10000005910866,MA01045+MA01016
10000005910866,MA01051+MA01016
10000005910866,MA01051+MA01045
10000005910866,MA01051+MA01050


10000013136923,MA01011+MA00966
10000013136923,MA01152+MA00966
10000013136923,MA01190+MA00966
10000013136923,MA01190+MA01011
10000013136923,MA01190+MA01152



10000013809904,MA00996+MA00981
10000013809904,MA01042+MA00981
10000013809904,MA01050+MA00996
10000013809904,MA01080+MA01042
10000013809904,MA01080+MA01050
10000013809904,MA01208+MA01042

