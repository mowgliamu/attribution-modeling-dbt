with sessions as (

    select * from {{ ref('sessions_transformed') }}

),

cte as (

select user_id, 
       time_started,
       signup_time,
       is_paid, 
       medium
from sessions
where time_started between signup_time - interval 3 hour and signup_time - interval 1 hour
and medium = 'PAID CLICK'
and is_paid is true
order by 1

)

select distinct user_id, 
				signup_time, 
				medium as attribution
from cte
