 select t1.store,
       t1.prc_chg_no as prc_chg_no,
       t2.prc_chg_trans_type,
      
       sum( t1.str_prc_ext_sell_change /(1 +t1.  str_prc_chg_vat_rate / 100)) as pricealter_other_adj_wovat,
       t2.prc_auth_date as prc_auth_datekey,  --变价授权日期
       t2.prc_chg_date_eff as prc_chg_date_eff_datekey,  --变价生效日期
       T2.PRC_CHG_UPDATE as prc_chg_UPDATE_datekey,  --变价更新日期
       t2.prc_apply_date as prc_apply_datekey
                        --from dwd.dwd_inventory_pa r1
from ods.ods_profit_prchgdet_di t1
left join ods.ods_profit_prchghdr_di t2 on  t1.coy = t2.coy and t1.prc_chg_no = t2.prc_chg_no
  INNER join dwd.dim_product t3 on t1.pt_coy=t3.pt_tenant and concat(t1.pt_coy,'^',t1.short_sku) = t3.product_key

 where T1.pt_datekey BETWEEN 202205 AND 202206 AND
  t2.prc_chg_update between date'2022-05-01' and date'2022-05-31'
 AND t1.store='0001'

  and  prc_chg_status = 'C'
  and  t2.prc_chg_trans_type in( 'MKU', 'MKD')

group by t1.store,   t1.prc_chg_no ,
       t2.prc_chg_trans_type,t2.prc_auth_date,  
       t2.prc_chg_date_eff ,
       t2.PRC_CHG_UPDATE ,
       t2.prc_chg_trans_date ,
       t2.prc_apply_date 
     