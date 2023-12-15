select

    section编号,
    section名称,
    时间,
    sum(商品PA线上) as 商品PA线上,
    sum(商品PA线下) as 商品PA线下,
    sum(营运PA) as 营运PA,
    sum(其他PA) as 其他PA,
    sum(永久降价PA不含税) as 永久降价PA不含税,
    sum(永久降价PA含税) as 永久降价PA含税,
    sum(永久涨价PA不含税) as 永久涨价PA不含税,
    sum(永久涨价PA含税) as 永久涨价PA含税,
    sum(报废PA不含税) as 报废PA不含税,
    sum(报废PA含税) as 报废PA含税
from
(
select
  t1.corporation_code as 公司编号
    ,t1.corporation_name as 公司名称
    ,t1.`section` as section编号
    ,t2.section_name as section名称
    ,t1.pt_month as 时间
    ,sum(online_member_disc) as 商品PA线上
    ,sum(offline_member_disc) as 商品PA线下
    ,sum(sale_exec_disc) as 营运PA
    ,sum(sale_card_disc) as 其他PA
    ,0 as 永久降价PA不含税
    ,0 as 永久降价PA含税
    ,0 as 永久涨价PA不含税
    ,0 as 永久涨价PA含税
    ,0 as 报废PA不含税
    ,0 as 报废PA含税
from
(
select
       pt_month,
       t1.region_code,
       t1.corporation_code,
       t2.corporation_name,
       t1.store_key,
       `section`,
       product_key,
    ---商品折扣
      sum(case when sales_capture_key in('sales_capture^AAPP','sales_capture^XCX','sales_capture^JDDJ','sales_capture^MT','sales_capture^MTSG','sales_capture^ELM')
           and sales_order_type_key='sales_order_type^002' then
        member_disc+cast(sale_reserve_disc1 as decimal(18,2))+stdd_disc+group_disc+sls_mmc_disc+sale_mixed_disc+cast(sale_reserve_disc2 as decimal(18,2)) end) as online_member_disc,  --会员单品折扣
      sum(case when  sales_order_type_key<>'sales_order_type^002' then
        member_disc+cast(sale_reserve_disc1 as decimal(18,2))+stdd_disc+group_disc+sls_mmc_disc+sale_mixed_disc+cast(sale_reserve_disc2 as decimal(18,2)) end) as offline_member_disc,  --会员单品折扣
---营运折扣
       sum(exec_disc+pos_disc+sale_machine_disc) as sale_exec_disc,  --全单折扣
--其他折扣
       sum(promo_disc+staff_disc+sale_fresh_disc+authorise_disc+one_day_disc) as sale_card_disc--永旺卡折扣()
from dwd.dwd_trade_profit_sale t1
inner join dwd.dim_store t2 on t1.store_key=t2.store_key
where pt_month between  202201 and 202310
and `section` in ('131','132','133','134','135','136','137','150') and ext_disc_amount<>'0'
and t1.corporation_code<>'004'
group by
        pt_month,
       t1.region_code,
       t1.corporation_code,
       t2.corporation_name,
        t1.store_key,
       `section`,
       product_key
    )t1 left join dwd.dim_product t2 on t1.product_key=t2.product_key
group by
    t1.`section`
    ,t2.section_name
    ,t1.pt_month
    ,t1.corporation_code
    ,t1.corporation_name

union all
select
     t5.corporation_code as 公司
     ,t5.corporation_name as 公司名称
    ,t3.section_code as section编号
    ,t3.section_name as section名称
    ,t1.pt_month as 时间
    ,0 as 商品PA线上
    ,0 as 商品PA线下
    ,0 as 营运PA
    ,0 as 其他PA
    ,sum(day_mkdn_sell_wovat) as 永久降价PA不含税
    ,sum(day_mkdn_sell) as 永久降价PA含税
    ,sum(day_mkup_sell_wovat) as 永久涨价PA不含税
    ,sum(day_mkup_sell) as 永久涨价PA含税
    ,sum(ext_sell_adj_wovat) as 报废PA不含税
    ,sum(ext_sell_adj) as 报废PA含税

from dwd.dwd_inventory_forever_pa_day t1

inner join dwd.dim_store t5
    on t1.pt_tenant = t5.pt_tenant
    and t1.store_key=t5.store_key
inner join dwd.dim_product t3 on  t1.product_key=t3.product_key
where t1.pt_month  between 202201 and 202310 and t3.section_code in ('131','132','133','134','135','136','137','150')
and t5.corporation_code<>'004'
group by
     t5.corporation_code
    ,t5.corporation_name
    ,t3.section_code
    ,t3.section_name
    ,t1.pt_month

 )t4
 group by

    section编号,
    section名称,时间
    order by section编号,时间
