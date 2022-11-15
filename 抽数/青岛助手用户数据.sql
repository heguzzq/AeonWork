select
    date_key as 日期,
    store_code as 店铺编号,
    store_name as 店铺名称,
   -- um_key_userid as 擦,
    account as 操作账号,
    real_name as 姓名,
    um_key_currentpage_name as 页面名称

from dwd.dwd_log_mobilezs_user_behavior_log r
inner join
    (
        select
            distinct
            corporation_code,
            corporation_name,
            store_code,
            store_name,
            account,
            user_id,
            real_name
        from dws.dws_mobilezs_user_store
        where region_code='QDA'

    )store on r.um_key_userid=cast(store.user_id as string) and r.um_key_storecode=store.store_code
left join dwd.dim_mobilezs_pagename_type p
on r.eventname=p.eventcode and p.um_key_currentpage_code=r.um_key_currentpage
where r.date_key>='20210101' and r.date_key<='20221031'
and r.um_key_storecode in(
    select distinct
        store_code
    from dws.dws_mobilezs_user_store
    where region_code='QDA'
    )