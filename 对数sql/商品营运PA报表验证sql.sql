
select
    t1.datekey,
    t5.region_code,
    t5.region_name,
    t5.corporation_code,
    t5.corporation_name,
    t1.store_key,
    t5.store_name,
    t1.section_code,t1.product_key,
	sum(t1.sale_mixed_disc) as sale_combine_disc,  --混合促销折扣
    sum(coalesce(sale_combine_disc,0)) as  sale_combine_disc,--混合促销折扣
    sum(coalesce(sale_reduce_disc,0)) as  sale_reduce_disc --满减促销折扣

from dwd.dwd_trade_day_sell_sum t1
left join
     (
        select
            date_key,
          pt_month,
          store_key,
          product_key,
            coalesce(sum(case when promo_type_key = 5 then promo_amount end),0) as sale_combine_disc,
            coalesce(sum(case when promo_type_key = 4 then promo_amount end),0) as sale_reduce_disc
            from
         (select t2.finish_time_key   as date_key,
                 t1.pt_month,
                 t1.store_key,
                 t1.product_key,
                 t1.promo_type_key,
                 sum(t1.promo_amount) as promo_amount
          from dwd.dwd_act_order_promo t1
                   inner join dwd.dwd_trade_order_sales t2 on t1.order_no = t2.order_no
               --left join dwd.dwd_trade_after_sales_item t3 on t2.order_no = t3.sale_order_no and t1.order_item_no = t3.sale_item_no
          where t1.pt_month >= 202301
            and t1.store_key = '0025'
          --  and t2.finish_time_key = 20230201
            and t1.promo_type_key in (4, 5)
            and  t2.pay_status in(3,4)
            and t1.promo_dock_type_key in(7,8,9,10,11,12,13)

           -- and t2.sale_channel<>20
           -- and t2.order_status = 1090
          --  and t1.product_key = 'ACH^10522622'
            -- and t3.sale_order_no is null
          group by t2.finish_time_key,
                   t1.pt_month,
                   t1.store_key,
                   t1.product_key,
                   t1.promo_type_key
          union all
          select cast(date_format(t3.finish_time, 'yyyyMMdd') as int) as date_key,
                 t3.pt_month,
                 t1.store_key,
                 t3.product_key,
                 t1.promo_type_key,

                 -1 * sum(cast((t1.promo_amount/t2.sale_qty) as decimal(18,2)) *t3.sale_qty)                          as promo_amount  --因为有退货退一个的
          from dwd.dwd_act_order_promo t1
                   inner join dwd.dwd_trade_order_items t2 on t1.order_no = t2.order_no and t1.order_item_no =t2.order_item_no
           --   inner join dwd.dwd_trade_order_items t4 on t2.order_no = t4.order_no and t2.o
                   left join dwd.dwd_trade_after_sales_item t3
                             on t2.order_no = t3.sale_order_no and t1.order_item_no = t3.sale_item_no
          where  t1.pt_month >= 202208  and  t2.pay_status in(3,4)
            and  t1.store_key = '0025'
            and date_format(t3.finish_time, 'yyyyMMdd') = 20230201
            and t1.promo_type_key in (4, 5)
            and t1.promo_dock_type_key in(7,8,9,10,11,12,13)

           -- and t2.sale_channel<>20
            and t3.order_status = 2090
           -- and t3.finish_time is not null and t3.product_key is not null
          --  and t1.product_key = 'ACH^10014134'
         -- and t3.finish_time is not null
          group by date_format(t3.finish_time, 'yyyyMMdd'),
                   t3.pt_month,
                   t1.store_key,
                   t3.product_key,
                   t1.promo_type_key
          )t
          --  where date_key is not null
            group by
                date_key,

          pt_month,
          store_key,
          product_key
      )t2 on t1.pt_month=t2.pt_month and   t1.datekey = t2.date_key and t1.store_key = t2.store_key and t1.product_key = t2.product_key
left join dwd.dim_store t5
    on t1.pt_tenant = t5.pt_tenant
    and t1.store_key=t5.store_key

where t1.pt_month =202302
      and t1.pt_tenant = 'ACH'
  and t1.store_key='0025'
 and t1.section_code='131'

and t1.datekey=20230201
--and  t1.product_key='ACH^09682931'
group by
    t1.datekey,
    t5.region_code,
    t5.region_name,
    t5.corporation_code,
    t5.corporation_name,
    t1.store_key,
    t5.store_name,t1.section_code,t1.product_key
having sum(t1.sale_mixed_disc)>0



