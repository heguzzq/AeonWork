 select t2.DateKey,
                        t2.pricealter_store_code,
                        t2.pricealter_product_code,
                        0 as pricealter_sum_adj_qty,
                        0 as pricealter_sum_adj_wovat,
                        0 as pricealter_pos_adj_qty,
                        0 as pricealter_pos_adj_wovat,
                        t2.pricealter_other_adj_qty as pricealter_other_adj_qty,
                        t2.pricealter_other_adj_wovat as pricealter_other_adj_wovat,
                        0 as pricealter_dis_adj_qty,
                        0 as pricealter_dis_adj_wovat
                    from (
                        select prc_apply_datekey AS DateKey,
                            r1.store_key as pricealter_store_code,
                            r1.product_key as pricealter_product_code,
                            r1.STR_PRC_CHG_QUANTITY as pricealter_other_adj_qty,
                            r1.STR_PRC_EXT_SELL_CHANGE /(1 + r1.STR_PRC_CHG_VAT_RATE / 100) as pricealter_other_adj_wovat
                        from dwd.dwd_inventory_pa r1
                        INNER join dwd.dim_product r2 on r1.pt_tenant=r2.pt_tenant and r1.product_key = r2.product_key
						where r1.pt_month between 202301 and 202301
						  and r1.pt_tenant = 'ACH'
						  AND r1.store_key='0001'
						  and r2.article_code='0308'

						  and r1.prc_chg_status_key = 'prc_chg_status^C'
                        and r1.prc_chg_trans_type_key in( 'MKU', 'MKD')
                        --dwd.dim_store st
                        --where r1.store_key=st.store_key
                        --and r1.region_code=st.region_code
                        --and st.store_type='S'
                    )t2










 select t2.DateKey,
                        t2.pricealter_store_code,
                        t2.pricealter_product_code,
                        0 as pricealter_sum_adj_qty,
                        0 as pricealter_sum_adj_wovat,
                        0 as pricealter_pos_adj_qty,
                        0 as pricealter_pos_adj_wovat,
                        t2.pricealter_other_adj_qty as pricealter_other_adj_qty,
                        t2.pricealter_other_adj_wovat as pricealter_other_adj_wovat,
                        0 as pricealter_dis_adj_qty,
                        0 as pricealter_dis_adj_wovat
                    from (
                        select prc_apply_datekey AS DateKey,
                            r1.store_key as pricealter_store_code,
                            r1.product_key as pricealter_product_code,
                            r1.STR_PRC_CHG_QUANTITY as pricealter_other_adj_qty,
                            r1.STR_PRC_EXT_SELL_CHANGE /(1 + r1.STR_PRC_CHG_VAT_RATE / 100) as pricealter_other_adj_wovat
                        from dwd.dwd_inventory_pa r1
						 INNER join dwd.dim_product r2 on r1.pt_tenant=r2.pt_tenant and r1.product_key = r2.product_key
						where r1.pt_month=202205
						  and r1.pt_tenant = 'ACH'
						  AND r1.store_key='0001'
						  and r2.article_code='0308'

						  and r1.prc_chg_status_key = 'prc_chg_status^C'
                        and r1.prc_chg_trans_type_key in( 'MKU', 'MKD')
                    )t2








