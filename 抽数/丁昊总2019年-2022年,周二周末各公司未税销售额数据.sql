select
    t2.calendar_yearname_cn as 年份,
    t2.week_name_cn as 星期,
    concat(t3.corporation_code,t3.corporation_name) as 公司,
    t1.dept_code as 部门,
    sum(t1.sale_amt_without_tax) as 销售额

from dwd.dwd_trade_day_sell_sum t1
join
(
select
      calendar_yearname_cn,datekey,week_name_cn
from dwd.dim_date
where week_name_cn ='星期二' and datekey>=20190101 and datekey<=20221231
)t2 on t1.datekey=t2.datekey
join dwd.dim_store t3 on t1.store_key=t3.store_key
where t1.pt_month between 201901 and 202212 and t1.dept_code='02'
group by
    t2.calendar_yearname_cn,
    t2.week_name_cn ,
    concat(t3.corporation_code,t3.corporation_name) ,
    t1.dept_code


select
    t2.calendar_yearname_cn as 年份,
    concat(t3.corporation_code,t3.corporation_name) as 公司,
    sum(t1.sale_amt_without_tax) as 销售额

from dwd.dwd_trade_day_sell_sum t1
join
(
select
      calendar_yearname_cn,datekey,week_name_cn
from dwd.dim_date
where week_name_cn in('星期六','星期日') and datekey>=20190101 and datekey<=20221231
)t2 on t1.datekey=t2.datekey
join dwd.dim_store t3 on t1.store_key=t3.store_key
where t1.pt_month between 201901 and 202212 --and t1.dept_code='02'
group by
    t2.calendar_yearname_cn,
    concat(t3.corporation_code,t3.corporation_name)
