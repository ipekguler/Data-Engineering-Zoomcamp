# Week 1: Docker, SQL and Terraform

## Question 1. Version of pip:
```
$ docker run -it --entrypoint bash python:3.12.8
$ root@7b97aa3ca6d8:/# pip --version
```

## Prepare Postgres

* ### Run Postgres and Pgadmin:
```
$ docker-compose up
```

* ### Dockerize the ingestion script:
```
$ docker build -t ingest-data .
```

* ### Ingest green taxi data:
```
$ URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"

$ docker run -it \
  --network=01-docker-terraform_default \
  ingest-data \
    --user=postgres \
    --password=postgres \
    --host=db \
    --port=5432 \
    --db=ny_taxi \
    --table_name=green_taxi_trips \
    --url=${URL}
```

* ### Ingest taxi zone data:
```
$ URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"

$ docker run -it \
  --network=01-docker-terraform_default \
  ingest-data \
    --user=postgres \
    --password=postgres \
    --host=db \
    --port=5432 \
    --db=ny_taxi \
    --table_name=taxi_zone_lookup \
    --url=${URL}
```

## Question 3. Trip Segmentation Count
```
SELECT
    SUM(CASE WHEN trip_distance <= 1 THEN 1 ELSE 0 END) AS "Up to 1 mile",
    SUM(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 ELSE 0 END) AS "In between 1 (exclusive) and 3 miles (inclusive)",
    SUM(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 ELSE 0 END) AS "In between 3 (exclusive) and 7 miles (inclusive)",
    SUM(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 ELSE 0 END) AS "In between 7 (exclusive) and 10 miles (inclusive)",
    SUM(CASE WHEN trip_distance > 10 THEN 1 ELSE 0 END) AS "Over 10 miles"
FROM 
	green_taxi_trips
WHERE 
	lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01';
```

## Question 4. Longest trip for each day
```
SELECT 
	DATE(lpep_pickup_datetime) AS pick_up_day , MAX(trip_distance) AS LONGEST_DISTANCE
FROM 
	green_taxi_trips
GROUP BY
	1
ORDER BY 
	2 DESC
LIMIT 1;
```


## Question 5. Three biggest pickup zones
```
SELECT 
	tzl."Zone", tzl."Borough", SUM(gtt.total_amount) AS total_amount
FROM 
	green_taxi_trips gtt
JOIN 
	taxi_zone_lookup tzl ON gtt."PULocationID" = tzl."LocationID"
WHERE 
	DATE(gtt.lpep_pickup_datetime) = '2019-10-18'
GROUP BY 
	tzl."Zone", tzl."Borough"
HAVING 
	SUM(gtt.total_amount) > 13000
ORDER BY 
	total_amount DESC
LIMIT 3;
```


## Question 6. Largest tip
```
SELECT 
	tzl."Zone" AS dropoff_zone, MAX(gtt.tip_amount) AS max_tip
FROM 
	green_taxi_trips gtt
JOIN 
	taxi_zone_lookup tzl ON gtt."DOLocationID" = tzl."LocationID"
JOIN 
	taxi_zone_lookup pickup_zone ON gtt."PULocationID" = pickup_zone."LocationID"
WHERE 
	pickup_zone."Zone" = 'East Harlem North' AND DATE(gtt.lpep_pickup_datetime) BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY 
	tzl."Zone"
ORDER BY 
	max_tip DESC
LIMIT 1;
```