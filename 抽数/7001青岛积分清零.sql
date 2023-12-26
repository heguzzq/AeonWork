
select
     store_code,
     sum(cast(total_not_used_point as decimal(18,2)))
from dwd.dwd_member_point_expire
where   expire_time >= '2023-01-01 00:00:00' and expire_time <= '2023-12-31 23:59:59'  and  corporation_code='701'
 and store_code='7001' and cast(total_not_used_point as decimal(18,2))>0
group by
    store_code



