

select
    时间,
    cast(sum(商品PA线上) as decimal(18,2)) as 商品PA线上,
    cast(sum(商品PA线下) as decimal(18,2)) as 商品PA线下,
    cast(sum(营运PA) as decimal(18,2)) as 营运PA,
    cast(sum(其他PA) as decimal(18,2))as 其他PA,
    sum(永久降价PA不含税) as 永久降价PA不含税,

    sum(永久涨价PA不含税) as 永久涨价PA不含税,

    sum(报废PA不含税) as 报废PA不含税,

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

    ,0 as 永久涨价PA不含税

    ,0 as 报废PA不含税

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
        member_disc/(1 + sales_vat_rate / 100)+cast(sale_reserve_disc1 as decimal(18,2))/(1 + sales_vat_rate / 100)+stdd_disc/(1 + sales_vat_rate / 100)+group_disc/(1 + sales_vat_rate / 100)+sls_mmc_disc/(1 + sales_vat_rate / 100)+sale_mixed_disc/(1 + sales_vat_rate / 100)+cast(sale_reserve_disc2 as decimal(18,2))/(1 + sales_vat_rate / 100) end) as online_member_disc,  --会员单品折扣
      sum(case when  sales_order_type_key<>'sales_order_type^002' then
        member_disc/(1 + sales_vat_rate / 100)+cast(sale_reserve_disc1 as decimal(18,2))/(1 + sales_vat_rate / 100)+stdd_disc/(1 + sales_vat_rate / 100)+group_disc/(1 + sales_vat_rate / 100)+sls_mmc_disc/(1 + sales_vat_rate / 100)+sale_mixed_disc/(1 + sales_vat_rate / 100)+cast(sale_reserve_disc2 as decimal(18,2))/(1 + sales_vat_rate / 100) end) as offline_member_disc,  --会员单品折扣
---营运折扣
       sum(exec_disc/(1 + sales_vat_rate / 100)+pos_disc/(1 + sales_vat_rate / 100)+sale_machine_disc/(1 + sales_vat_rate / 100)) as sale_exec_disc,  --全单折扣
--其他折扣
       sum(promo_disc/(1 + sales_vat_rate / 100)+staff_disc/(1 + sales_vat_rate / 100)+sale_fresh_disc/(1 + sales_vat_rate / 100)+authorise_disc/(1 + sales_vat_rate / 100)+one_day_disc/(1 + sales_vat_rate / 100)) as sale_card_disc--永旺卡折扣()
from dwd.dwd_trade_profit_sale t1
inner join dwd.dim_store t2 on t1.store_key=t2.store_key
 join dwd.dim_product_class cls
ON  t1.class = cls.class_code
and t1.pt_tenant = cls.pt_tenant
where pt_month between  202201 and 202310 and cls.ccess_csign_class='D'
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

    ,sum(day_mkup_sell_wovat) as 永久涨价PA不含税

    ,sum(ext_sell_adj_wovat) as 报废PA不含税


from dwd.dwd_inventory_forever_pa_day t1
inner join dwd.dim_store t5
    on t1.pt_tenant = t5.pt_tenant
    and t1.store_key=t5.store_key
inner join dwd.dim_product t3 on  t1.product_key=t3.product_key
 join dwd.dim_product_class cls
ON  t3.class_code = cls.class_code
and t3.pt_tenant = cls.pt_tenant
where t1.pt_month  between 202201 and 202310 and cls.ccess_csign_class='D'
  and t3.section_code in ('131','132','133','134','135','136','137','150')
and t5.corporation_code<>'004'
group by
     t5.corporation_code
    ,t5.corporation_name
    ,t3.section_code
    ,t3.section_name
    ,t1.pt_month

 )t4
 group by
    时间
 order by 时间


