with cte as (

  select * from {{ ref('attribution_1_3_hours') }}

  union all

  select * from {{ ref('attribution_0_1_hours') }}

  union all

  select * from {{ ref('attribution_0_12_hours') }}

  union all

  select * from {{ ref('attribution_12_hours_before') }}

)

select * from cte
