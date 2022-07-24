with sessions as (

    select * from {{ ref('sessions_transformed') }}

),

attribution_1_3 as (

  select * from {{ ref('attribution_1_3_hours') }}

),

attribution_0_1 as (

  select * from {{ ref('attribution_0_1_hours') }}

),

attribution_0_12 as (

  select * from {{ ref('attribution_0_12_hours') }}

),

cte as (
		
select user_id,
	   signup_time, 
	   case when medium = 'DIRECT' then 'DIRECT' else 'OTHER' end as attribution,
	   row_number() over(partition by user_id order by time_started) rank_session
from sessions s
where s.user_id not in (select user_id from attribution_1_3)
and user_id not in (select user_id from attribution_0_1)
and user_id not in (select user_id from attribution_0_12)

)

select user_id, 
	   signup_time,
       attribution
from cte
where rank_session=1
