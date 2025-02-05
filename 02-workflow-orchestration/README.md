# Week 2: Workflow Orchestration

## Question 3. Number of rows (yellow, 2020):
```
SELECT 
  COUNT(*) 
FROM 
  yellow_tripdata
WHERE 
  filename LIKE 'yellow_tripdata_2020-%.csv';
```

## Question 4. Number of rows (green, 2020):
```
SELECT 
  COUNT(*)
FROM 
  green_tripdata
WHERE 
  filename LIKE 'green_tripdata_2020-%.csv';
```

## Question 5. Number of rows (yellow, March 2021):
```
SELECT 
  COUNT(*)
FROM 
  green_tripdata
WHERE 
  filename LIKE 'yellow_tripdata_2021-03.csv';
```