-- Put your downloaded CSV files in a local folder, for example:

C:\Users\YourName\Documents\seoul-subway\data\cleaned\

-- From psql, use \copy. This imports from your own computer and avoids server-file permission problems.

\copy subway.stg_station_hourly_total
FROM 'C:/Users/YourName/Documents/seoul-subway/data/cleaned/station_hourly_total.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

\copy subway.stg_station_hourly_type_2025
FROM 'C:/Users/YourName/Documents/seoul-subway/data/cleaned/station_hourly_passenger_type_2025.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) AS total_hourly_rows
FROM subway.stg_station_hourly_total;

SELECT
    source_year,
    MIN(service_date) AS first_date,
    MAX(service_date) AS last_date,
    COUNT(*) AS rows_loaded
FROM subway.stg_station_hourly_total
GROUP BY source_year
ORDER BY source_year;

-- Data quality check
-- There should be no null dates, stations, directions, or counts.
SELECT *
FROM subway.stg_station_hourly_total
WHERE service_date IS NULL
   OR station_name IS NULL
   OR line_name IS NULL
   OR direction IS NULL
   OR passenger_count IS NULL;

-- Passenger counts cannot be negative.
SELECT COUNT(*) AS negative_passenger_rows
FROM subway.stg_station_hourly_total
WHERE passenger_count < 0;

-- Direction should be standardized.
SELECT direction, COUNT(*)
FROM subway.stg_station_hourly_total
GROUP BY direction;

-- Check that no hourly records are duplicated.
SELECT
    service_date,
    line_name,
    station_code,
    direction,
    hour_bucket,
    COUNT(*) AS duplicate_rows
FROM subway.stg_station_hourly_total
GROUP BY
    service_date,
    line_name,
    station_code,
    direction,
    hour_bucket
HAVING COUNT(*) > 1;

