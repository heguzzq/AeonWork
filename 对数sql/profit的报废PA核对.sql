select
    T1.ADJ_NO,T1.STORE,T2.SHORT_SKU,CASE WHEN T1.adj_trans_type = 'ADI' THEN
                                    T2.EXT_SELL_ADJ_WOVAT
                                WHEN T1.adj_trans_type= 'ADO' THEN
                                    (-1)*T2.EXT_SELL_ADJ_WOVAT ELSE 0 END AS pricealter_dis_adj_wovat
    from PROFIT.ADJTXHDR T1
INNER JOIN PROFIT.ADJTXDET T2 ON T1.ADJ_NO=T2.ADJ_NO AND T1.STORE=T2.STORE
WHERE T1.STORE='0004' and t1.ADJ_CONFIRM_STATUS='Y'
AND TO_CHAR(T1.adj_confirm_date,'yyyyMMdd')>=20230401 AND TO_CHAR(T1.adj_confirm_date,'yyyyMMdd')<=20230418
and t2.SHORT_SKU in ()