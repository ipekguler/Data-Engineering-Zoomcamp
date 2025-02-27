{{
    config(
        materialized='table'
    )
}}
with fhv_tripdata as (
    select *
    from {{ ref('stg_fhv_tripdata') }}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    fhv_tripdata.dispatching_base_num as dispatching_base_num,
    fhv_tripdata.affiliated_base_number as affiliated_base_number,
    fhv_tripdata.pickup_locationid as pickup_locationid,
    fhv_tripdata.dropoff_locationid as dropoff_locationid,
    fhv_tripdata.pickup_datetime as pickup_datetime,
    fhv_tripdata.dropoff_datetime as dropoff_datetime,
    fhv_tripdata.sr_flag as sr_flag,
    extract(month from fhv_tripdata.pickup_datetime) as pickup_month,
    extract(year from fhv_tripdata.pickup_datetime) as pickup_year
from fhv_tripdata
inner join dim_zones as pickup_zone
on fhv_tripdata.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_tripdata.dropoff_locationid = dropoff_zone.locationid