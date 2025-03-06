{{ config(materialized='table') }}

with trips_data as (
  select * from {{ ref('fact_trips') }}
),
trip_fare_data AS (
  SELECT
    {{ dbt.date_trunc("year", "pickup_datetime") }} AS revenue_year,
    {{ dbt.date_trunc("month", "pickup_datetime") }} AS revenue_month,
    service_type,
    fare_amount
  FROM trips_data
  WHERE fare_amount > 0
    AND trip_distance > 0
    AND lower(payment_type_description) IN ('cash', 'credit card')
),
percentiles AS (
  SELECT
    revenue_year,
    revenue_month,
    service_type,
    fare_amount,
    PERCENTILE_CONT(fare_amount, 0.90) OVER(PARTITION BY revenue_year, revenue_month, service_type) AS p90_fare_amount,
    PERCENTILE_CONT(fare_amount, 0.95) OVER(PARTITION BY revenue_year, revenue_month, service_type) AS p95_fare_amount,
    PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION BY revenue_year, revenue_month, service_type) AS p97_fare_amount
  FROM trip_fare_data
)
SELECT
  revenue_year,
  revenue_month,
  service_type,
  MAX(fare_amount) AS max_amount,
  MIN(fare_amount) AS min_amount,
  AVG(fare_amount) AS avg_amount,
  MAX(p90_fare_amount) AS p90_fare_amount,
  MAX(p95_fare_amount) AS p95_fare_amount,
  MAX(p97_fare_amount) AS p97_fare_amount
FROM percentiles
GROUP BY revenue_year, revenue_month, service_type