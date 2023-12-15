with base as(
select t3.store_key,t3.mark_friend_time,t4.middlend_member_id as member_id,t3.customer_id
from (
    select
    t1.store_key,t2.customer_id,min(cast(substring(translate(cast(t2.add_time as string), '-', ''), 1, 8)as int)) as
        mark_friend_time
    from tmp.tmp_qywx_operater t1
    inner join ods.ods_memberdb_oprt_qywx_customer_follow_df t2
    on t1.middleend_account=t2.middleend_account
    and t1.store_key = t2.user_store_code
    and t2.deleted=0
    group by t1.store_key,t2.customer_id
) t3 inner join ods.ods_memberdb_oprt_qywx_customer_df t4
on t3.customer_id=t4.id
and t4.middlend_member_id is not null
)

select
  concat(t6.corporation_code,max(t6.corporation_name)) as corporation_name
    ,concat(t6.store_key,max(t6.store_name)) as store_name
    ,sum(`all_member_cnt`) as `社群现有人数`
    ,sum(`社群现有人数中注册会员数`) as 社群现有人数中注册会员数
    ,sum(`qywx_friends_cnt`) as `企微好友数`
    ,sum(`企微好友数中注册会员数`) as `企微好友数中注册会员数`
    ,sum(new_register_cnt) as `企微好友中期间新注册会员人数`
    ,sum(全店期间新注册会员数) as `全店期间新注册会员数`
    ,sum(全渠道今年期间购物会员数) as `全渠道今年期间购物会员数`
    ,sum(全渠道去年期间购物会员数) as `全渠道去年期间购物会员数`
    ,sum(全渠道今年期间订单数) as `全渠道今年期间订单数`
    ,sum(全渠道去年期间订单数) as `全渠道去年期间订单数`
    ,sum(全渠道今年期间销售额) as `全渠道今年期间销售额`
    ,sum(全渠道去年期间销售额) as `全渠道去年期间销售额`
    ,sum(全渠道今年期间全渠道销售额总额) as `全渠道今年期间全渠道销售额总额`
    ,sum(全渠道去年期间全渠道销售额总额) as `全渠道去年期间全渠道销售额总额`
    ,sum(`全渠道今年企微好友销售占比`) as `全渠道今年企微好友销售占比`
    ,sum(`全渠道去年企微好友销售占比`) as `全渠道去年企微好友销售占比`
    ,sum(自平台今年期间购物会员数) as `自平台今年期间购物会员数`
    ,sum(自平台去年期间购物会员数) as `自平台去年期间购物会员数`
    ,sum(自平台今年期间订单数) as `自平台今年期间订单数`
    ,sum(自平台自平台去年期间订单数) as `自平台自平台去年期间订单数`
    ,sum(自平台今年期间销售额) as `自平台今年期间销售额`
    ,sum(自平台去年期间销售额) as `自平台去年期间销售额`
    ,sum(自平台今年期间全渠道销售额总额) as `自平台今年期间全渠道销售额总额`
    ,sum(自平台去年期间全渠道销售额总额) as `自平台去年期间全渠道销售额总额`
    ,sum(`自平台今年企微好友销售占比`) as `自平台今年企微好友销售占比`
    ,sum(`自平台去年企微好友销售占比`) as `自平台去年企微好友销售占比`
from (
    select store_key
        ,count(distinct t1.customer_id) as all_member_cnt
        ,count(distinct t3.middlend_member_id) as 社群现有人数中注册会员数
        ,0 as qywx_friends_cnt
        ,0 as 企微好友数中注册会员数
        ,0 as new_register_cnt
        ,0 as `全店期间新注册会员数`
        ,0 as `全渠道今年期间购物会员数`
        ,0 as `全渠道去年期间购物会员数`
        ,0 as `全渠道今年期间订单数`
        ,0 as `全渠道去年期间订单数`
        ,0 as `全渠道今年期间销售额`
        ,0 as `全渠道去年期间销售额`
        ,0 as `全渠道今年期间全渠道销售额总额`
        ,0 as `全渠道去年期间全渠道销售额总额`
        ,0 as `全渠道今年企微好友销售占比`
        ,0 as `全渠道去年企微好友销售占比`
        ,0 as `自平台今年期间购物会员数`
        ,0 as `自平台去年期间购物会员数`
        ,0 as `自平台今年期间订单数`
        ,0 as `自平台自平台去年期间订单数`
        ,0 as `自平台今年期间销售额`
        ,0 as `自平台去年期间销售额`
        ,0 as `自平台今年期间全渠道销售额总额`
        ,0 as `自平台去年期间全渠道销售额总额`
        ,0 as `自平台今年企微好友销售占比`
        ,0 as `自平台去年企微好友销售占比`
    from ods.ods_memberdb_oprt_qywx_group_member_df t1
    inner join dwd.dim_qywx_group t2
    on t1.chat_id = t2.chat_id
    left join ods.ods_memberdb_oprt_qywx_customer_df t3
    on t1.customer_id=t3.id
    where join_status=0
--     and store_key ='0007'
    group by t2.store_key
    union all
    --企微好友数
    select
    t1.store_key
         ,0 as all_member_cnt
        ,0 as 社群现有人数中注册会员数
         ,count(distinct t2.customer_id) as qywx_friends_cnt
        ,count(distinct t3.member_id) as 企微好友数中注册会员数
        ,0 as new_register_cnt
        ,0 as `全店期间新注册会员数`
        ,0 as `全渠道今年期间购物会员数`
        ,0 as `全渠道去年期间购物会员数`
        ,0 as `全渠道今年期间订单数`
        ,0 as `全渠道去年期间订单数`
        ,0 as `全渠道今年期间销售额`
        ,0 as `全渠道去年期间销售额`
        ,0 as `全渠道今年期间全渠道销售额总额`
        ,0 as `全渠道去年期间全渠道销售额总额`
        ,0 as `全渠道今年企微好友销售占比`
        ,0 as `全渠道去年企微好友销售占比`
        ,0 as `自平台今年期间购物会员数`
        ,0 as `自平台去年期间购物会员数`
        ,0 as `自平台今年期间订单数`
        ,0 as `自平台去年期间订单数`
        ,0 as `自平台今年期间销售额`
        ,0 as `自平台去年期间销售额`
        ,0 as `自平台今年期间全渠道销售额总额`
        ,0 as `自平台去年期间全渠道销售额总额`
        ,0 as `自平台今年企微好友销售占比`
        ,0 as `自平台去年企微好友销售占比`
    from tmp.tmp_qywx_operater t1
    inner join ods.ods_memberdb_oprt_qywx_customer_follow_df t2
    on t1.middleend_account=t2.middleend_account
    and t1.store_key = t2.user_store_code
    and t2.deleted=0
    left join base t3
    on t2.customer_id = t3.customer_id
    and t2.user_store_code=t3.store_key
    group by t1.store_key
    union all
    --期间新注册人数
    select
    t1.store_key
         ,0 as all_member_cnt
        ,0 as 社群现有人数中注册会员数
         ,0 as qywx_friends_cnt
        ,0 as 企微好友数中注册会员数
         ,count(distinct t4.member_id) as new_register_cnt
        ,0 as `全店期间新注册会员数`
        ,0 as `全渠道今年期间购物会员数`
        ,0 as `全渠道去年期间购物会员数`
        ,0 as `全渠道今年期间订单数`
        ,0 as `全渠道去年期间订单数`
        ,0 as `全渠道今年期间销售额`
        ,0 as `全渠道去年期间销售额`
        ,0 as `全渠道今年期间全渠道销售额总额`
        ,0 as `全渠道去年期间全渠道销售额总额`
        ,0 as `全渠道今年企微好友销售占比`
        ,0 as `全渠道去年企微好友销售占比`
        ,0 as `自平台今年期间购物会员数`
        ,0 as `自平台去年期间购物会员数`
        ,0 as `自平台今年期间订单数`
        ,0 as `自平台去年期间订单数`
        ,0 as `自平台今年期间销售额`
        ,0 as `自平台去年期间销售额`
        ,0 as `自平台今年期间全渠道销售额总额`
        ,0 as `自平台去年期间全渠道销售额总额`
        ,0 as `自平台今年企微好友销售占比`
        ,0 as `自平台去年企微好友销售占比`
    from tmp.tmp_qywx_operater t1
    inner join ods.ods_memberdb_oprt_qywx_customer_follow_df t2
    on t1.middleend_account=t2.middleend_account
    and t1.store_key = t2.user_store_code
    and t2.deleted=0
    inner join ods.ods_memberdb_oprt_qywx_customer_df t3
    on t2.customer_id=t3.id
    inner join dwd.dim_member t4
    on t3.middlend_member_id=cast(t4.member_id as bigint)
    and t4.register_datekey between '20230109' and '20230115'
    group by t1.store_key

    union all
        select t4.store_key
        ,0 as all_member_cnt
        ,0 as 社群现有人数中注册会员数
        ,0 as qywx_friends_cnt
        ,0 as 企微好友数中注册会员数
        ,0 as new_register_cnt
        ,count(distinct t4.member_id) as 全店期间新注册会员数
        ,0 as `全渠道今年期间购物会员数`
        ,0 as `全渠道去年期间购物会员数`
        ,0 as `全渠道今年期间订单数`
        ,0 as `全渠道去年期间订单数`
        ,0 as `全渠道今年期间销售额`
        ,0 as `全渠道去年期间销售额`
        ,0 as `全渠道今年期间全渠道销售额总额`
        ,0 as `全渠道去年期间全渠道销售额总额`
        ,0 as `全渠道今年企微好友销售占比`
        ,0 as `全渠道去年企微好友销售占比`
        ,0 as `自平台今年期间购物会员数`
        ,0 as `自平台去年期间购物会员数`
        ,0 as `自平台今年期间订单数`
        ,0 as `自平台自平台去年期间订单数`
        ,0 as `自平台今年期间销售额`
        ,0 as `自平台去年期间销售额`
        ,0 as `自平台今年期间全渠道销售额总额`
        ,0 as `自平台去年期间全渠道销售额总额`
        ,0 as `自平台今年企微好友销售占比`
        ,0 as `自平台去年企微好友销售占比`
    from  dwd.dim_member t4
    where t4.register_datekey between '20230109' and '20230115'
    group by t4.store_key

    union all
    --全渠道好友
    --购物会员数
    select
      store_key
        ,0 as all_member_cnt
        ,0 as 社群现有人数中注册会员数
        ,0 as qywx_friends_cnt
        ,0 as 企微好友数中注册会员数
      ,0 as new_register_cnt
        ,0 as `全店期间新注册会员数`
      ,sum(`今年期间购物会员数`) as `全渠道今年期间购物会员数`,
      sum(`去年期间购物会员数`) as `全渠道去年期间购物会员数`,
      sum(`今年期间订单数`) as `全渠道今年期间订单数`,
      sum(`去年期间订单数`) as `全渠道去年期间订单数`,
      sum(`今年期间销售额`) as `全渠道今年期间销售额`,
      sum(`去年期间销售额`) as `全渠道去年期间销售额`,
      sum(`今年期间全渠道销售额总额`) as  `全渠道今年期间全渠道销售额总额`,
      sum(`去年期间全渠道销售额总额`) as  `全渠道去年期间全渠道销售额总额`,
      case when sum(`今年期间全渠道销售额总额`) <>0 then sum(`今年期间销售额`)/sum(`今年期间全渠道销售额总额`) else 0 end as `全渠道今年企微好友销售占比`,
      case when sum(`去年期间全渠道销售额总额`) <>0 then sum(`去年期间销售额`)/sum(`去年期间全渠道销售额总额`) else 0 end as `全渠道去年企微好友销售占比`,
      0 as `自平台今年期间购物会员数`,
      0 as `自平台去年期间购物会员数`,
      0 as `自平台今年期间订单数`,
      0 as `自平台去年期间订单数`,
      0 as `自平台今年期间销售额`,
      0 as `自平台去年期间销售额`,
      0 as  `自平台今年期间全渠道销售额总额`,
      0 as  `自平台去年期间全渠道销售额总额`,
      0  as `自平台今年企微好友销售占比`,
      0  as `自平台去年企微好友销售占比`
    from(
        select
          t2.store_key,
          count(distinct t2.member_id) as `今年期间购物会员数`,
          0 as `去年期间购物会员数`,
          count(distinct t1.order_no) as `今年期间订单数`,
          0 as `去年期间订单数`,
          sum(t1.total_product_price) as `今年期间销售额`,
          0 as `去年期间销售额`,
          0.00 as  `今年期间全渠道销售额总额`,
          0.00 as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        inner join base t2
            on t1.member_key = t2.member_id
            and t1.store_key = t2.store_key
            and t1.pt_month >= 202301
            and t1.pt_month <= 202312
            and t1.datekey between 20230109 and 20230115
        where
--           t2.mark_friend_time <= t1.order_time_key
--             and
              t1.order_status=1090
        group by
          t2.store_key
        --期间订单数
        --期间销售额
        union all
        --期间全渠道销售额总额
        select
          t1.store_key,
          0 as `今年期间购物会员数`,
          0 as `去年期间购物会员数`,
          0 as `今年期间订单数`,
          0 as `去年期间订单数`,
          0 as `今年期间销售额`,
          0 as `去年期间销售额`,
          sum(t1.total_product_price) as  `今年期间全渠道销售额总额`,
          0.00 as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        where
            t1.order_status=1090
            and t1.pt_month >= 202301
            and t1.pt_month <= 202312
            and t1.datekey between 20230109 and 20230115
            and region_code in ('ACH', 'ABJ', 'QDA', 'AHD', 'AHB', 'MGZ')
        group by
          store_key
        union
        --去年
        select
          t2.store_key,
          0 as `今年期间购物会员数`,
          count(distinct t2.member_id) as `去年期间购物会员数`,
          0 as `今年期间订单数`,
          count(distinct t1.order_no) as `去年期间订单数`,
          0 as `今年期间销售额`,
          sum(t1.total_product_price) as `去年期间销售额`,
          0.00 as  `今年期间全渠道销售额总额`,
          0.00 as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        inner join base t2
            on t1.member_key = t2.member_id
            and t1.store_key = t2.store_key
            and t1.pt_month >= (202301-100)
            and t1.pt_month <= (202312-100)
            and t1.datekey between (20230109-10000) and (20230115-10000)
        where
--           t2.mark_friend_time <= t1.order_time_key
--             and
              t1.order_status=1090
        group by
          t2.store_key
        --期间订单数
        --期间销售额
        union all
        --期间全渠道销售额总额
        select
          t1.store_key,
          0 as `今年期间购物会员数`,
          0 as `去年期间购物会员数`,
          0 as `今年期间订单数`,
          0 as `去年期间订单数`,
          0 as `今年期间销售额`,
          0 as `去年期间销售额`,
          0.00 as  `今年期间全渠道销售额总额`,
          sum(t1.total_product_price)  as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        where
            t1.order_status=1090
            and t1.pt_month >= (202301-100)
            and t1.pt_month <= (202312-100)
            and t1.datekey between (20230109-10000) and (20230115-10000)
            and region_code in ('ACH', 'ABJ', 'QDA', 'AHD', 'AHB', 'MGZ')
        group by
          store_key
    ) tmp
    group by store_key
    union all
    --自平台好友
    select
      store_key
        ,0 as all_member_cnt
        ,0 as 社群现有人数中注册会员数
        ,0 as qywx_friends_cnt
        ,0 as 企微好友数中注册会员数
      ,0 as new_register_cnt
        ,0 as `全店期间新注册会员数`
      ,0 as `全渠道今年期间购物会员数`,
      0 as `全渠道去年期间购物会员数`,
      0 as `全渠道今年期间订单数`,
      0 as `全渠道去年期间订单数`,
      0 as `全渠道今年期间销售额`,
      0 as `全渠道去年期间销售额`,
      0 as  `全渠道今年期间全渠道销售额总额`,
      0 as `全渠道去年期间全渠道销售额总额`,
      0 as `全渠道今年企微好友销售占比`,
      0 as `全渠道去年企微好友销售占比`,
      sum(`今年期间购物会员数`)  as `自平台今年期间购物会员数`,
      sum(`去年期间购物会员数`) as `自平台去年期间购物会员数`,
      sum(`今年期间订单数`) as  `自平台今年期间订单数`,
      sum(`去年期间订单数`) as  `自平台去年期间订单数`,
      sum(`今年期间销售额`) as  `自平台今年期间销售额`,
      sum(`去年期间销售额`) as  `自平台去年期间销售额`,
      sum(`今年期间全渠道销售额总额`) as   `自平台今年期间全渠道销售额总额`,
      sum(`去年期间全渠道销售额总额`) as   `自平台去年期间全渠道销售额总额`,
      case when sum(`今年期间全渠道销售额总额`) <>0 then sum(`今年期间销售额`)/sum(`今年期间全渠道销售额总额`) else 0 end as `自平台今年企微好友销售占比`,
      case when sum(`去年期间全渠道销售额总额`) <>0 then sum(`去年期间销售额`)/sum(`去年期间全渠道销售额总额`) else 0 end as `自平台去年企微好友销售占比`
    from(
        select
          t2.store_key,
          count(distinct t2.member_id) as `今年期间购物会员数`,
          0 as `去年期间购物会员数`,
          count(distinct t1.order_no) as `今年期间订单数`,
          0 as `去年期间订单数`,
          sum(t1.total_product_price) as `今年期间销售额`,
          0 as `去年期间销售额`,
          0.00 as  `今年期间全渠道销售额总额`,
          0.00 as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        inner join base t2
            on t1.member_key = t2.member_id
            and t1.store_key = t2.store_key
            and t1.pt_month >= 202301
            and t1.pt_month <= 202312
            and t1.datekey between 20230109 and 20230115
            and t1.sale_channel in (80,32)
        where
--           t2.mark_friend_time <= t1.order_time_key
--             and
              t1.order_status=1090
        group by
          t2.store_key
        --期间订单数
        --期间销售额
        union all
        --期间全渠道销售额总额
        select
          t1.store_key,
          0 as `今年期间购物会员数`,
          0 as `去年期间购物会员数`,
          0 as `今年期间订单数`,
          0 as `去年期间订单数`,
          0 as `今年期间销售额`,
          0 as `去年期间销售额`,
          sum(t1.total_product_price) as  `今年期间全渠道销售额总额`,
          0.00 as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        where
            t1.order_status=1090
            and t1.pt_month >= 202301
            and t1.pt_month <= 202312
            and t1.datekey between 20230109 and 20230115
            and region_code in ('ACH', 'ABJ', 'QDA', 'AHD', 'AHB', 'MGZ')
            and t1.sale_channel in (80,32)
        group by
          store_key
        union
        --去年
        select
          t2.store_key,
          0 as `今年期间购物会员数`,
          count(distinct t2.member_id) as `去年期间购物会员数`,
          0 as `今年期间订单数`,
          count(distinct t1.order_no) as `去年期间订单数`,
          0 as `今年期间销售额`,
          sum(t1.total_product_price) as `去年期间销售额`,
          0.00 as  `今年期间全渠道销售额总额`,
          0.00 as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        inner join base t2
            on t1.member_key = t2.member_id
            and t1.store_key = t2.store_key
            and t1.pt_month >= (202301-100)
            and t1.pt_month <= (202312-100)
            and t1.datekey between (20230109-10000) and (20230115-10000)
            and t1.sale_channel in (80,32)
        where
--           t2.mark_friend_time <= t1.order_time_key
--             and
              t1.order_status=1090
        group by
          t2.store_key
        --期间订单数
        --期间销售额
        union all
        --期间全渠道销售额总额
        select
          t1.store_key,
          0 as `今年期间购物会员数`,
          0 as `去年期间购物会员数`,
          0 as `今年期间订单数`,
          0 as `去年期间订单数`,
          0 as `今年期间销售额`,
          0 as `去年期间销售额`,
          0.00 as  `今年期间全渠道销售额总额`,
          sum(t1.total_product_price)  as  `去年期间全渠道销售额总额`
        from
            dwd.dwd_trade_order_sales t1
        where
            t1.order_status=1090
            and t1.pt_month >= (202301-100)
            and t1.pt_month <= (202312-100)
            and t1.datekey between (20230109-10000) and (20230115-10000)
            and region_code in ('ACH', 'ABJ', 'QDA', 'AHD', 'AHB', 'MGZ')
            and t1.sale_channel in (80,32)
        group by
          store_key
    ) tmp
    group by store_key
) tmp_all
inner join dwd.dim_store t6
on tmp_all.store_key=t6.store_key
inner join (select distinct store_key from tmp.tmp_qywx_operater) t7
on tmp_all.store_key=t7.store_key
group by t6.corporation_code,t6.store_key
order by t6.corporation_code,t6.store_key
