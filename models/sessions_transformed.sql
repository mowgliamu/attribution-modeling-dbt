select s.user_id as user_id, 
	   s.time_started as time_started, 
       c.registration_time as signup_time, 
       s.is_paid as is_paid, 
	   case when medium  = 'PAID SEARCH' then 'PAID CLICK'
	   when medium = 'PAID SOCIAL' then 'PAID IMP'
	   when medium = 'ORGANIC SEARCH' then 'ORGANIC CLICK'
	   when medium = 'DIRECT' then 'DIRECT'
	   else 'OTHER' end as medium
from `miro.sessions` s
left join `miro.conversions` c
on s.user_id = c.user_id
where s.time_started < c.registration_time
