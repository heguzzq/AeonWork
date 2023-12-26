
select
    substring(t1.date_key,1,4) as 年份,
    concat(t5.corporation_code,'_',t5.corporation_name) as 公司,
    sum(t1.ext_sell_adj_wovat) as 报废PA不含税
from (select adj_datekey AS date_key,
	   region_code,
       store_key,
       product_key,
    pt_tenant,
       	CASE WHEN adj_trans_type_key = 'adj_trans_type^ADI' and adj_rsn_cd_key='DIS' THEN
                                    EXT_SELL_ADJ_WOVAT
                                WHEN adj_trans_type_key = 'adj_trans_type^ADO' and adj_rsn_cd_key='DIS' THEN
                                    (-1)*EXT_SELL_ADJ_WOVAT
                                ELSE 0 END AS ext_sell_adj_wovat  --废弃额不含税

FROM dwd.dwd_inventory_adjustment
where pt_month between 201901 and 202212
      and adj_rsn_cd_key  in('DIS','PA')
      and adj_confirm_status_key='adj_confirm_status^Y') t1
join dwd.dim_product t2 on t1.pt_tenant = t2.pt_tenant and  t1.product_key = t2.product_key
left join dwd.dim_store t5
    on t1.pt_tenant = t5.pt_tenant
    and t1.store_key=t5.store_key
where  t2.section_code in('133','135','136','137')

group by substring(t1.date_key,1,4),
    concat(t5.corporation_code,'_',t5.corporation_name)