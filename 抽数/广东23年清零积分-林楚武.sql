
select point.member_id     as `会员id`
     , not_use_point_store as `会员积分到期门店`
     , dm.store            as `会员注册门店`
     , not_used_point_2023 as `2023-12-31到期积分`
     , not_used_point_sum  as `会员积分余额（广东永旺）`
from (select t1.corporation_code,
             collect_set(store_name)      as not_use_point_store,
             cast(t1.member_id as string) as member_id,
             sum(case
                     when from_unixtime(unix_timestamp(t1.expire_time), 'yyyyMMdd') = '20231231'
                         or from_unixtime(unix_timestamp(t1.expire_time), 'yyyyMMdd') = '20240101'
                         then total_not_used_point
                     else 0 end)          as `not_used_point_2023`,
             sum(total_not_used_point)    as `not_used_point_sum`
      from ods.ods_memberdb_sec_member_point_expire_df t1
      where t1.corporation_code = '002'
        and t1.status = 0
      group by t1.corporation_code, t1.member_id
      having `not_used_point_2023` > 0) point
         left join (select member_id, concat(ds.store_key, '_', store_name) as store
                    from dwd.dim_member mb
                             inner join dwd.dim_store ds
                                        on mb.corporation_code = ds.corporation_code
                                            and mb.store_key = ds.store_key) dm on point.member_id = dm.member_id