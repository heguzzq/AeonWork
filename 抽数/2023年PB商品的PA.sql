
with  pb_sec as(select distinct dim.region_code,
                                 dim.corporation_code,
                                 sec.section_code as section_code,
                                 sec.section_name as section_name,
                                 product.short_sku
                 from dws.dws_tvimp_basedata_transposit_recv_v2 t1
                          left join (select corporation_code, corporation_name, store_key, store_name, region_code
                                     from dwd.dim_store
                                     where store_type = 'S'
                                       -- AND store_del_cd = 'N'
                                       AND STORE_NAME NOT LIKE '%名义%'
                                       AND STORE_NAME NOT LIKE '%仓库%'
                                       AND STORE_NAME NOT LIKE '%物流%'
                                       AND STORE_NAME NOT LIKE '%外仓%'
                                       AND STORE_NAME NOT LIKE '%虚拟%'
                                       AND store_key not in ('0000', '2000', '3000', '7000')
                                     group by corporation_code, corporation_name, store_key, store_name,
                                              region_code) dim
                                    on t1.corporation_code = dim.corporation_code and t1.store_key = dim.store_key
                          left join (select region_code,
                                            department_code,
                                            department_name,
                                            section_code,
                                            section_name,
                                            article_code,
                                            class_code,
                                            sub_class_code,
                                            sub_class_name,
                                            short_sku,
                                            barcode
                                     from dwd.dim_product
                                     where department_code in ('01', '02', '03', '06')) product
                                    on dim.region_code = product.region_code and t1.barcode = product.barcode
                          left join (select -- 上载section_code 跟 系统section_code不一致，取上载section_code对应名称
                                            region_code,
                                            department_code,
                                            max(department_name) as department_name,
                                            section_code,
                                            max(section_name)    as section_name
                                     from dwd.dim_product_article
                                     where department_code in ('01', '02', '03', '06')
                                     group by region_code, department_code, section_code) sec
                                    on dim.region_code = sec.region_code and sec.section_code = t1.`groups`
                 where t1.corporation_code <> '004'
                   and t1.start_month between 202301 and 202310
                   and sec.section_code in ('131', '132', '133', '134', '135', '136', '137', '150')
                 )

select



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
    t1.corporation_code as 公司
     ,t1.corporation_name as 公司名称
    ,t1.section_code as section编号
    ,t1.section_name as section名称
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
       t2.corporation_code,
       t2.corporation_name,
       t2.store_key,
      t3.section_code,
    t3.section_name,
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
inner join pb_sec t3 on t1.region_code=t3.region_code and t1.corporation_code=t3.corporation_code and t1.product_key=concat(t3.region_code,'^',t3.short_sku)
where pt_month between 202301 and 202310 and ext_disc_amount<>'0'
group by
        pt_month,
       t1.region_code,
       t2.corporation_code,
       t2.corporation_name,
        t2.store_key,
       t3.section_code,
    t3.section_name,
       product_key
    )t1
group by
t1.section_code,
    t1.section_name
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
inner join pb_sec t3 on t1.region_code=t3.region_code and t5.corporation_code=t3.corporation_code and t1.product_key=concat(t3.region_code,'^',t3.short_sku)
where t1.pt_month  between 202301 and 202310

group by
     t5.corporation_code
    ,t5.corporation_name
    ,t3.section_code
    ,t3.section_name
    ,t1.pt_month
 )t4 where 公司<>'004'
 group by
    时间
    order by 时间
