

select
    job_name
     ,job_type
     ,start_time
     ,end_time
    ,unix_timestamp(end_time) -unix_timestamp(start_time) as total_time
from db_bd.t_schedule_task
where create_time>='2023-06-01 00:00:00' and create_time<='2023-06-01 23:59:59'
and task_status='SUCCESS'