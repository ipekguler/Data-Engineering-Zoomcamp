{{ config(materialized='table') }}

with fhv_trips as (
  select TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS travel_time,
    dropoff_locationid,
    pickup_locationid,
    dropoff_zone,
    pickup_zone,
    pickup_month,
    pickup_year from {{ ref('dim_fhv_trips') }}
),
percentiles AS (
  SELECT
    pickup_year,
    pickup_month,
    pickup_locationid,
    dropoff_locationid,
    pickup_zone,
    dropoff_zone,
    PERCENTILE_CONT(travel_time, 0.90) OVER(PARTITION BY pickup_zone, dropoff_zone, pickup_year, pickup_month) AS p90_travel_time
  FROM fhv_trips
)
SELECT
  pickup_year,
  pickup_month,
  pickup_locationid,
  dropoff_locationid,
  pickup_zone,
  dropoff_zone,
  MAX(p90_travel_time) AS p90_travel_time
FROM percentiles
GROUP BY pickup_year, pickup_month, pickup_zone, dropoff_zone, pickup_locationid, dropoff_locationid