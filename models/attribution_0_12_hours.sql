with sessions as (

    select * from {{ ref('sessions_transformed') }}

),

attribution_1_3 as (

  select * from {{ ref('attribution_1_3_hours') }}

),

attribution_0_1 as (

  select * from {{ ref('attribution_0_1_hours') }}

),

cte as (

select user_id, 
       time_started,
       signup_time,
       is_paid, 
       medium,
from sessions s
where time_started between signup_time - interval 12 hour and signup_time 
and medium = 'ORGANIC CLICK'
and user_id not in (select user_id from attribution_1_3)
and user_id not in (select user_id from attribution_0_1)
order by 1

)

select distinct user_id, 
				signup_time, 
				medium as attribution
from cte 
