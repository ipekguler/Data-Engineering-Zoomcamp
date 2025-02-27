{{
    config(
        materialized='view'
    )
}}

with tripdata as
(
  select *
  from {{ source('raw_nyc_tripdata','fhv_tripdata') }}
  where dispatching_base_num is not null
)
select
    -- identifiers
    {{ dbt.safe_cast("dispatching_base_num", api.Column.translate_type("string")) }} as dispatching_base_num,
    {{ dbt.safe_cast("Affiliated_base_number", api.Column.translate_type("string")) }} as affiliated_base_number,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }} as dropoff_locationid,
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,

    -- trip info
    SR_Flag as sr_flag
from tripdata