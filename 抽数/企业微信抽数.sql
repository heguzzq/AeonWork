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
    ,sum(`all_member_cnt`) as `��Ⱥ��������`
    ,sum(`��Ⱥ����������ע���Ա��`) as ��Ⱥ����������ע���Ա��
    ,sum(`qywx_friends_cnt`) as `��΢������`
    ,sum(`��΢��������ע���Ա��`) as `��΢��������ע���Ա��`
    ,sum(new_register_cnt) as `��΢�������ڼ���ע���Ա����`
    ,sum(ȫ���ڼ���ע���Ա��) as `ȫ���ڼ���ע���Ա��`
    ,sum(ȫ���������ڼ乺���Ա��) as `ȫ���������ڼ乺���Ա��`
    ,sum(ȫ����ȥ���ڼ乺���Ա��) as `ȫ����ȥ���ڼ乺���Ա��`
    ,sum(ȫ���������ڼ䶩����) as `ȫ���������ڼ䶩����`
    ,sum(ȫ����ȥ���ڼ䶩����) as `ȫ����ȥ���ڼ䶩����`
    ,sum(ȫ���������ڼ����۶�) as `ȫ���������ڼ����۶�`
    ,sum(ȫ����ȥ���ڼ����۶�) as `ȫ����ȥ���ڼ����۶�`
    ,sum(ȫ���������ڼ�ȫ�������۶��ܶ�) as `ȫ���������ڼ�ȫ�������۶��ܶ�`
    ,sum(ȫ����ȥ���ڼ�ȫ�������۶��ܶ�) as `ȫ����ȥ���ڼ�ȫ�������۶��ܶ�`
    ,sum(`ȫ����������΢��������ռ��`) as `ȫ����������΢��������ռ��`
    ,sum(`ȫ����ȥ����΢��������ռ��`) as `ȫ����ȥ����΢��������ռ��`
    ,sum(��ƽ̨�����ڼ乺���Ա��) as `��ƽ̨�����ڼ乺���Ա��`
    ,sum(��ƽ̨ȥ���ڼ乺���Ա��) as `��ƽ̨ȥ���ڼ乺���Ա��`
    ,sum(��ƽ̨�����ڼ䶩����) as `��ƽ̨�����ڼ䶩����`
    ,sum(��ƽ̨��ƽ̨ȥ���ڼ䶩����) as `��ƽ̨��ƽ̨ȥ���ڼ䶩����`
    ,sum(��ƽ̨�����ڼ����۶�) as `��ƽ̨�����ڼ����۶�`
    ,sum(��ƽ̨ȥ���ڼ����۶�) as `��ƽ̨ȥ���ڼ����۶�`
    ,sum(��ƽ̨�����ڼ�ȫ�������۶��ܶ�) as `��ƽ̨�����ڼ�ȫ�������۶��ܶ�`
    ,sum(��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�) as `��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�`
    ,sum(`��ƽ̨������΢��������ռ��`) as `��ƽ̨������΢��������ռ��`
    ,sum(`��ƽ̨ȥ����΢��������ռ��`) as `��ƽ̨ȥ����΢��������ռ��`
from (
    select store_key
        ,count(distinct t1.customer_id) as all_member_cnt
        ,count(distinct t3.middlend_member_id) as ��Ⱥ����������ע���Ա��
        ,0 as qywx_friends_cnt
        ,0 as ��΢��������ע���Ա��
        ,0 as new_register_cnt
        ,0 as `ȫ���ڼ���ע���Ա��`
        ,0 as `ȫ���������ڼ乺���Ա��`
        ,0 as `ȫ����ȥ���ڼ乺���Ա��`
        ,0 as `ȫ���������ڼ䶩����`
        ,0 as `ȫ����ȥ���ڼ䶩����`
        ,0 as `ȫ���������ڼ����۶�`
        ,0 as `ȫ����ȥ���ڼ����۶�`
        ,0 as `ȫ���������ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����������΢��������ռ��`
        ,0 as `ȫ����ȥ����΢��������ռ��`
        ,0 as `��ƽ̨�����ڼ乺���Ա��`
        ,0 as `��ƽ̨ȥ���ڼ乺���Ա��`
        ,0 as `��ƽ̨�����ڼ䶩����`
        ,0 as `��ƽ̨��ƽ̨ȥ���ڼ䶩����`
        ,0 as `��ƽ̨�����ڼ����۶�`
        ,0 as `��ƽ̨ȥ���ڼ����۶�`
        ,0 as `��ƽ̨�����ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨������΢��������ռ��`
        ,0 as `��ƽ̨ȥ����΢��������ռ��`
    from ods.ods_memberdb_oprt_qywx_group_member_df t1
    inner join dwd.dim_qywx_group t2
    on t1.chat_id = t2.chat_id
    left join ods.ods_memberdb_oprt_qywx_customer_df t3
    on t1.customer_id=t3.id
    where join_status=0
--     and store_key ='0007'
    group by t2.store_key
    union all
    --��΢������
    select
    t1.store_key
         ,0 as all_member_cnt
        ,0 as ��Ⱥ����������ע���Ա��
         ,count(distinct t2.customer_id) as qywx_friends_cnt
        ,count(distinct t3.member_id) as ��΢��������ע���Ա��
        ,0 as new_register_cnt
        ,0 as `ȫ���ڼ���ע���Ա��`
        ,0 as `ȫ���������ڼ乺���Ա��`
        ,0 as `ȫ����ȥ���ڼ乺���Ա��`
        ,0 as `ȫ���������ڼ䶩����`
        ,0 as `ȫ����ȥ���ڼ䶩����`
        ,0 as `ȫ���������ڼ����۶�`
        ,0 as `ȫ����ȥ���ڼ����۶�`
        ,0 as `ȫ���������ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����������΢��������ռ��`
        ,0 as `ȫ����ȥ����΢��������ռ��`
        ,0 as `��ƽ̨�����ڼ乺���Ա��`
        ,0 as `��ƽ̨ȥ���ڼ乺���Ա��`
        ,0 as `��ƽ̨�����ڼ䶩����`
        ,0 as `��ƽ̨ȥ���ڼ䶩����`
        ,0 as `��ƽ̨�����ڼ����۶�`
        ,0 as `��ƽ̨ȥ���ڼ����۶�`
        ,0 as `��ƽ̨�����ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨������΢��������ռ��`
        ,0 as `��ƽ̨ȥ����΢��������ռ��`
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
    --�ڼ���ע������
    select
    t1.store_key
         ,0 as all_member_cnt
        ,0 as ��Ⱥ����������ע���Ա��
         ,0 as qywx_friends_cnt
        ,0 as ��΢��������ע���Ա��
         ,count(distinct t4.member_id) as new_register_cnt
        ,0 as `ȫ���ڼ���ע���Ա��`
        ,0 as `ȫ���������ڼ乺���Ա��`
        ,0 as `ȫ����ȥ���ڼ乺���Ա��`
        ,0 as `ȫ���������ڼ䶩����`
        ,0 as `ȫ����ȥ���ڼ䶩����`
        ,0 as `ȫ���������ڼ����۶�`
        ,0 as `ȫ����ȥ���ڼ����۶�`
        ,0 as `ȫ���������ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����������΢��������ռ��`
        ,0 as `ȫ����ȥ����΢��������ռ��`
        ,0 as `��ƽ̨�����ڼ乺���Ա��`
        ,0 as `��ƽ̨ȥ���ڼ乺���Ա��`
        ,0 as `��ƽ̨�����ڼ䶩����`
        ,0 as `��ƽ̨ȥ���ڼ䶩����`
        ,0 as `��ƽ̨�����ڼ����۶�`
        ,0 as `��ƽ̨ȥ���ڼ����۶�`
        ,0 as `��ƽ̨�����ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨������΢��������ռ��`
        ,0 as `��ƽ̨ȥ����΢��������ռ��`
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
        ,0 as ��Ⱥ����������ע���Ա��
        ,0 as qywx_friends_cnt
        ,0 as ��΢��������ע���Ա��
        ,0 as new_register_cnt
        ,count(distinct t4.member_id) as ȫ���ڼ���ע���Ա��
        ,0 as `ȫ���������ڼ乺���Ա��`
        ,0 as `ȫ����ȥ���ڼ乺���Ա��`
        ,0 as `ȫ���������ڼ䶩����`
        ,0 as `ȫ����ȥ���ڼ䶩����`
        ,0 as `ȫ���������ڼ����۶�`
        ,0 as `ȫ����ȥ���ڼ����۶�`
        ,0 as `ȫ���������ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `ȫ����������΢��������ռ��`
        ,0 as `ȫ����ȥ����΢��������ռ��`
        ,0 as `��ƽ̨�����ڼ乺���Ա��`
        ,0 as `��ƽ̨ȥ���ڼ乺���Ա��`
        ,0 as `��ƽ̨�����ڼ䶩����`
        ,0 as `��ƽ̨��ƽ̨ȥ���ڼ䶩����`
        ,0 as `��ƽ̨�����ڼ����۶�`
        ,0 as `��ƽ̨ȥ���ڼ����۶�`
        ,0 as `��ƽ̨�����ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�`
        ,0 as `��ƽ̨������΢��������ռ��`
        ,0 as `��ƽ̨ȥ����΢��������ռ��`
    from  dwd.dim_member t4
    where t4.register_datekey between '20230109' and '20230115'
    group by t4.store_key

    union all
    --ȫ��������
    --�����Ա��
    select
      store_key
        ,0 as all_member_cnt
        ,0 as ��Ⱥ����������ע���Ա��
        ,0 as qywx_friends_cnt
        ,0 as ��΢��������ע���Ա��
      ,0 as new_register_cnt
        ,0 as `ȫ���ڼ���ע���Ա��`
      ,sum(`�����ڼ乺���Ա��`) as `ȫ���������ڼ乺���Ա��`,
      sum(`ȥ���ڼ乺���Ա��`) as `ȫ����ȥ���ڼ乺���Ա��`,
      sum(`�����ڼ䶩����`) as `ȫ���������ڼ䶩����`,
      sum(`ȥ���ڼ䶩����`) as `ȫ����ȥ���ڼ䶩����`,
      sum(`�����ڼ����۶�`) as `ȫ���������ڼ����۶�`,
      sum(`ȥ���ڼ����۶�`) as `ȫ����ȥ���ڼ����۶�`,
      sum(`�����ڼ�ȫ�������۶��ܶ�`) as  `ȫ���������ڼ�ȫ�������۶��ܶ�`,
      sum(`ȥ���ڼ�ȫ�������۶��ܶ�`) as  `ȫ����ȥ���ڼ�ȫ�������۶��ܶ�`,
      case when sum(`�����ڼ�ȫ�������۶��ܶ�`) <>0 then sum(`�����ڼ����۶�`)/sum(`�����ڼ�ȫ�������۶��ܶ�`) else 0 end as `ȫ����������΢��������ռ��`,
      case when sum(`ȥ���ڼ�ȫ�������۶��ܶ�`) <>0 then sum(`ȥ���ڼ����۶�`)/sum(`ȥ���ڼ�ȫ�������۶��ܶ�`) else 0 end as `ȫ����ȥ����΢��������ռ��`,
      0 as `��ƽ̨�����ڼ乺���Ա��`,
      0 as `��ƽ̨ȥ���ڼ乺���Ա��`,
      0 as `��ƽ̨�����ڼ䶩����`,
      0 as `��ƽ̨ȥ���ڼ䶩����`,
      0 as `��ƽ̨�����ڼ����۶�`,
      0 as `��ƽ̨ȥ���ڼ����۶�`,
      0 as  `��ƽ̨�����ڼ�ȫ�������۶��ܶ�`,
      0 as  `��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�`,
      0  as `��ƽ̨������΢��������ռ��`,
      0  as `��ƽ̨ȥ����΢��������ռ��`
    from(
        select
          t2.store_key,
          count(distinct t2.member_id) as `�����ڼ乺���Ա��`,
          0 as `ȥ���ڼ乺���Ա��`,
          count(distinct t1.order_no) as `�����ڼ䶩����`,
          0 as `ȥ���ڼ䶩����`,
          sum(t1.total_product_price) as `�����ڼ����۶�`,
          0 as `ȥ���ڼ����۶�`,
          0.00 as  `�����ڼ�ȫ�������۶��ܶ�`,
          0.00 as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
        --�ڼ䶩����
        --�ڼ����۶�
        union all
        --�ڼ�ȫ�������۶��ܶ�
        select
          t1.store_key,
          0 as `�����ڼ乺���Ա��`,
          0 as `ȥ���ڼ乺���Ա��`,
          0 as `�����ڼ䶩����`,
          0 as `ȥ���ڼ䶩����`,
          0 as `�����ڼ����۶�`,
          0 as `ȥ���ڼ����۶�`,
          sum(t1.total_product_price) as  `�����ڼ�ȫ�������۶��ܶ�`,
          0.00 as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
        --ȥ��
        select
          t2.store_key,
          0 as `�����ڼ乺���Ա��`,
          count(distinct t2.member_id) as `ȥ���ڼ乺���Ա��`,
          0 as `�����ڼ䶩����`,
          count(distinct t1.order_no) as `ȥ���ڼ䶩����`,
          0 as `�����ڼ����۶�`,
          sum(t1.total_product_price) as `ȥ���ڼ����۶�`,
          0.00 as  `�����ڼ�ȫ�������۶��ܶ�`,
          0.00 as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
        --�ڼ䶩����
        --�ڼ����۶�
        union all
        --�ڼ�ȫ�������۶��ܶ�
        select
          t1.store_key,
          0 as `�����ڼ乺���Ա��`,
          0 as `ȥ���ڼ乺���Ա��`,
          0 as `�����ڼ䶩����`,
          0 as `ȥ���ڼ䶩����`,
          0 as `�����ڼ����۶�`,
          0 as `ȥ���ڼ����۶�`,
          0.00 as  `�����ڼ�ȫ�������۶��ܶ�`,
          sum(t1.total_product_price)  as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
    --��ƽ̨����
    select
      store_key
        ,0 as all_member_cnt
        ,0 as ��Ⱥ����������ע���Ա��
        ,0 as qywx_friends_cnt
        ,0 as ��΢��������ע���Ա��
      ,0 as new_register_cnt
        ,0 as `ȫ���ڼ���ע���Ա��`
      ,0 as `ȫ���������ڼ乺���Ա��`,
      0 as `ȫ����ȥ���ڼ乺���Ա��`,
      0 as `ȫ���������ڼ䶩����`,
      0 as `ȫ����ȥ���ڼ䶩����`,
      0 as `ȫ���������ڼ����۶�`,
      0 as `ȫ����ȥ���ڼ����۶�`,
      0 as  `ȫ���������ڼ�ȫ�������۶��ܶ�`,
      0 as `ȫ����ȥ���ڼ�ȫ�������۶��ܶ�`,
      0 as `ȫ����������΢��������ռ��`,
      0 as `ȫ����ȥ����΢��������ռ��`,
      sum(`�����ڼ乺���Ա��`)  as `��ƽ̨�����ڼ乺���Ա��`,
      sum(`ȥ���ڼ乺���Ա��`) as `��ƽ̨ȥ���ڼ乺���Ա��`,
      sum(`�����ڼ䶩����`) as  `��ƽ̨�����ڼ䶩����`,
      sum(`ȥ���ڼ䶩����`) as  `��ƽ̨ȥ���ڼ䶩����`,
      sum(`�����ڼ����۶�`) as  `��ƽ̨�����ڼ����۶�`,
      sum(`ȥ���ڼ����۶�`) as  `��ƽ̨ȥ���ڼ����۶�`,
      sum(`�����ڼ�ȫ�������۶��ܶ�`) as   `��ƽ̨�����ڼ�ȫ�������۶��ܶ�`,
      sum(`ȥ���ڼ�ȫ�������۶��ܶ�`) as   `��ƽ̨ȥ���ڼ�ȫ�������۶��ܶ�`,
      case when sum(`�����ڼ�ȫ�������۶��ܶ�`) <>0 then sum(`�����ڼ����۶�`)/sum(`�����ڼ�ȫ�������۶��ܶ�`) else 0 end as `��ƽ̨������΢��������ռ��`,
      case when sum(`ȥ���ڼ�ȫ�������۶��ܶ�`) <>0 then sum(`ȥ���ڼ����۶�`)/sum(`ȥ���ڼ�ȫ�������۶��ܶ�`) else 0 end as `��ƽ̨ȥ����΢��������ռ��`
    from(
        select
          t2.store_key,
          count(distinct t2.member_id) as `�����ڼ乺���Ա��`,
          0 as `ȥ���ڼ乺���Ա��`,
          count(distinct t1.order_no) as `�����ڼ䶩����`,
          0 as `ȥ���ڼ䶩����`,
          sum(t1.total_product_price) as `�����ڼ����۶�`,
          0 as `ȥ���ڼ����۶�`,
          0.00 as  `�����ڼ�ȫ�������۶��ܶ�`,
          0.00 as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
        --�ڼ䶩����
        --�ڼ����۶�
        union all
        --�ڼ�ȫ�������۶��ܶ�
        select
          t1.store_key,
          0 as `�����ڼ乺���Ա��`,
          0 as `ȥ���ڼ乺���Ա��`,
          0 as `�����ڼ䶩����`,
          0 as `ȥ���ڼ䶩����`,
          0 as `�����ڼ����۶�`,
          0 as `ȥ���ڼ����۶�`,
          sum(t1.total_product_price) as  `�����ڼ�ȫ�������۶��ܶ�`,
          0.00 as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
        --ȥ��
        select
          t2.store_key,
          0 as `�����ڼ乺���Ա��`,
          count(distinct t2.member_id) as `ȥ���ڼ乺���Ա��`,
          0 as `�����ڼ䶩����`,
          count(distinct t1.order_no) as `ȥ���ڼ䶩����`,
          0 as `�����ڼ����۶�`,
          sum(t1.total_product_price) as `ȥ���ڼ����۶�`,
          0.00 as  `�����ڼ�ȫ�������۶��ܶ�`,
          0.00 as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
        --�ڼ䶩����
        --�ڼ����۶�
        union all
        --�ڼ�ȫ�������۶��ܶ�
        select
          t1.store_key,
          0 as `�����ڼ乺���Ա��`,
          0 as `ȥ���ڼ乺���Ա��`,
          0 as `�����ڼ䶩����`,
          0 as `ȥ���ڼ䶩����`,
          0 as `�����ڼ����۶�`,
          0 as `ȥ���ڼ����۶�`,
          0.00 as  `�����ڼ�ȫ�������۶��ܶ�`,
          sum(t1.total_product_price)  as  `ȥ���ڼ�ȫ�������۶��ܶ�`
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
