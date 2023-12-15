drop table cdpads.ads_mall_csmr_tag_total_df_rename3;
set @@session.tidb_enable_list_partition = ON;

select count(1) from  cdpads.ads_mall_csmr_tag_total_df_rename3;

desc select count(1) from  cdpads.ads_csmr_tag_total_df;

explain analyze select count(1) from  cdpads.ads_mall_csmr_tag_total_df;

SELECT * FROM information_schema.tiflash_replica WHERE TABLE_SCHEMA = 'cdpads' ;

ALTER TABLE cdpads.ads_nuza_event_detl_df_dept SET TIFLASH REPLICA 1;


set @@session.tidb_isolation_read_engines = "tiflash";

select count(1) from  cdpads.ads_csmr_tag_total_df;



show warnings;

    sel



show create table cdpads.ads_nuza_event_obj_df;




analyze table cdpads.ads_nuza_event_detl_df;


select count(1) from cdpads.ads_mall_csmr_tag_total_df;

select count(1) from cdpads.ads_nuza_event_mall_detl_df;

show stats_meta where table_name = 'ads_nuza_event_mall_detl_df';


select * from lightning_metadata.table_meta order by task_id desc limit 1;



show processlist;

select count(1)
from cdpads.ads_csmr_tag_total_df;

select count(1)
from cdpads.ads_csmr_tag_total_df_rename1;


select count(t1.oneid) count
from cdpads.ads_csmr_tag_total_df partition (p1) t1
         inner join cdpads.dwd_tags_mbr_crowd_instance_prod_gms_rename partition (p1) t2 on t1.oneid = t2.oneid
where t2.instance_id = 750006
  and t1.buy_count_level is not null
  and cast(t1.buy_count_level as char) <> '';


select * from cdpads.dwd_tags_mbr_crowd_instance_prod_gms_rename  where  instance_id='750006'

select
    count(1)
from cdpads.dwd_tags_mbr_crowd_instance_prod_gms where create_time>='2023-04-13 00:00:00'




show processlist

admin show ddl jobs;


ADMIN SHOW DDL;







show config where name like '%SHARD_ROW_ID_BITS%';


show variables like '%tidb_max_auto_analyze_time%';




SHOW TABLE cdpads.ads_csmr_tag_total_df_rename partition (p1) REGIONS ;

USE information_schema;
DESC tikv_region_status;

create index onid_index    on cdpads.ads_csmr_tag_total_df_rename   (oneid);

analyze table cdpads.ads_nuza_event_detl_df_clustered;


select * from cdpads.ads_nuza_event_detl_df limit 1;

drop table cdpads.dwd_tags_mbr_crowd_instance_prod_gms_rename

alter table cdpads.ads_nuza_event_detl_df rename  to cdpads.ads_nuza_event_detl_df_clustered_rename;

alter table cdpads.ads_nuza_event_detl_df_clustered rename  to cdpads.ads_nuza_event_detl_df;

show processlist;

show analyze status;


kill  1893622905820975735

show index from cdpads.ads_csmr_tag_total_df;

alter table cdpads.ads_csmr_tag_total_df rename to  cdpads.ads_csmr_tag_total_df_rename2;
alter table cdpads.ads_csmr_tag_total_df_rename1 rename to  cdpads.ads_csmr_tag_total_df;
alter table cdpads.ads_csmr_tag_total_df_rename2 rename to  cdpads.ads_csmr_tag_total_df_rename1;


create index index_obj on cdpads.ads_nuza_event_obj_df (obj_attr1_id,obj_attr2_id,obj_attr3_id,obj_attr4_id,obj_attr5_id,obj_id);


show variables where Variable_name = 'tidb_isolation_read_engines';


















