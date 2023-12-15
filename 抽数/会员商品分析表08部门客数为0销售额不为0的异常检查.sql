
--客数表
select
coy as region_code,
coy_sub as coy_sub_key,
store as store_key,
sales_trans_date,
concat('item_group_type','^',coalesce(item_group_type,'unknown')) as plan_group_key,
item_group,
sls_cust_count,
DATE_FORMAT(sales_trans_date,'yyyyMMdd') as sales_trans_datekey,
sys_rs_id,
'hql_dwd_trade_custcnt_sum' as task_rs_id,
current_timestamp() as dm_created_time,
cast(null as string) as dm_created_by,
current_timestamp() as dm_updated_time,
cast(null as string) as dm_updated_by,
DATE_FORMAT(sales_trans_date,'yyyyMM') as pt_month
from ods.ods_profit_slsclcnt_di
where pt_coy='AHD'
and pt_datekey >=202211
and pt_datekey <=202211
and coy_sub='201'
and store='2001'
and item_group_type='1'
and DATE_FORMAT(sales_trans_date,'yyyyMMdd')='20221117';



--销售表

selEct
*
 from ods.ods_profit_slsdate_di tsls
 inner join dwd.dim_product  tprod  -- 商品维度表
on tsls.short_sku=tprod.short_sku
and tsls.pt_coy=tprod.pt_tenant
  where tsls.pt_coy = 'AHD'
  and pt_datekey >= 202211
  and pt_datekey <= 202211
and coy_sub='201'
and tsls.store='2001'
    AND   date_format(tsls.sales_trans_date,'yyyyMMdd') ='20221117'
AND tprod.department_code ='08'--IN('01','02','03','04','05','06','07','08')
