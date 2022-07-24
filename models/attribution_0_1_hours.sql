with sessions as (

    select * from {{ ref('sessions_transformed') }}

),

attribution_1_3 as (

  select * from {{ ref('attribution_1_3_hours') }}

),

cte as (

select user_id, 
       time_started,
       signup_time,
       is_paid, 
       medium,
       row_number() over(partition by user_id order by time_started) rank_session
from sessions
where time_started between signup_time - interval 1 hour and signup_time
and medium in ('PAID CLICK', 'PAID IMP')
and is_paid is true
and user_id not in (select user_id from attribution_1_3)
order by 1

)

select user_id, 
	   signup_time, 
	   medium as attribution
from cte
where rank_session = 1


