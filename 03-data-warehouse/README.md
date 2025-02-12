# Week 3: Data Warehouse

## Creating the External Table:
```SQL
CREATE OR REPLACE EXTERNAL TABLE `nytaxi.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dezoomcamp_hw3_ig/yellow_tripdata_2024-*.parquet']
);
```

## Question 1:
```SQL
SELECT 
  COUNT(*) AS record_count
FROM 
  `nytaxi.external_yellow_tripdata`;
```

## Question 2:
```SQL
SELECT 
  COUNT(DISTINCT PULocationID)
FROM 
  `nytaxi.external_yellow_tripdata`;

  SELECT 
  COUNT(DISTINCT PULocationID)
FROM 
  `nytaxi.native_yellow_tripdata`;
```

## Question 3:
```SQL
SELECT 
  PULocationID
FROM 
  `nytaxi.native_yellow_tripdata`;

SELECT 
  PULocationID, DOLocationID
FROM 
  `nytaxi.native_yellow_tripdata`;
```

## Question 4:
```SQL
SELECT 
  COUNT(*) AS record_count
FROM 
  `nytaxi.external_yellow_tripdata`
WHERE 
  fare_amount = 0;
```

## Question 5:
```SQL
CREATE OR REPLACE TABLE `nytaxi.native_yellow_tripdata_partitioned_clustered`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `nytaxi.native_yellow_tripdata`;
```

## Question 6:
```SQL
SELECT 
  DISTINCT VendorID
FROM 
  `nytaxi.native_yellow_tripdata`
WHERE 
  tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

SELECT 
  DISTINCT VendorID
FROM 
  `nytaxi.native_yellow_tripdata_partitioned_clustered`
WHERE 
  tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
```