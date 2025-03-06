select *
from {{ ref('fact_trips') }}
where pickup_datetime >= TIMESTAMP(CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DBT_DAYS_BACK", "30")) }}' DAY)