CREATE TABLE subway.fact_station_hourly_total AS
SELECT
    service_date,
    source_year,
    line_name,
    station_code,
    station_name,
    direction,
    hour_bucket,
    passenger_count,
    day_of_week,
    is_weekday,
    is_weekend,
    month,
    year_month
FROM subway.stg_station_hourly_total
WHERE passenger_type = 'all_passengers';

Create indexes so queries run faster:

CREATE INDEX idx_hourly_station
ON subway.fact_station_hourly_total
(line_name, station_code, service_date);

CREATE INDEX idx_hourly_date
ON subway.fact_station_hourly_total
(service_date);

CREATE INDEX idx_hourly_year_weekday
ON subway.fact_station_hourly_total
(source_year, is_weekday);

CREATE INDEX idx_hourly_hour
ON subway.fact_station_hourly_total
(hour_bucket);

-- Create the 2025 passenger-type fact table separately:

CREATE TABLE subway.fact_station_hourly_type_2025 AS
SELECT
    service_date,
    source_year,
    line_name,
    station_code,
    station_name,
    direction,
    passenger_type,
    hour_bucket,
    passenger_count,
    day_of_week,
    is_weekday,
    is_weekend,
    month,
    year_month
FROM subway.stg_station_hourly_type_2025;

CREATE INDEX idx_type_station
ON subway.fact_station_hourly_type_2025
(line_name, station_code, service_date);

CREATE INDEX idx_type_passenger
ON subway.fact_station_hourly_type_2025
(passenger_type);

Create daily and station-summary tables

Daily station activity

-- CREATE MATERIALIZED VIEW subway.mv_station_daily AS
SELECT
    service_date,
    source_year,
    line_name,
    station_code,
    station_name,
    is_weekday,
    is_weekend,
    day_of_week,
    month,
    year_month,

    SUM(
        CASE WHEN direction = 'board'
        THEN passenger_count ELSE 0 END
    ) AS boardings,

    SUM(
        CASE WHEN direction = 'alight'
        THEN passenger_count ELSE 0 END
    ) AS alightings,

    SUM(passenger_count) AS total_activity

FROM subway.fact_station_hourly_total
GROUP BY
    service_date,
    source_year,
    line_name,
    station_code,
    station_name,
    is_weekday,
    is_weekend,
    day_of_week,
    month,
    year_month;

CREATE INDEX idx_daily_station
ON subway.mv_station_daily
(line_name, station_code, service_date);

-- Station-hour summary

CREATE MATERIALIZED VIEW subway.mv_station_hourly AS
SELECT
    service_date,
    source_year,
    line_name,
    station_code,
    station_name,
    is_weekday,
    is_weekend,
    hour_bucket,

    SUM(
        CASE WHEN direction = 'board'
        THEN passenger_count ELSE 0 END
    ) AS boardings,

    SUM(
        CASE WHEN direction = 'alight'
        THEN passenger_count ELSE 0 END
    ) AS alightings,

    SUM(passenger_count) AS total_activity

FROM subway.fact_station_hourly_total
GROUP BY
    service_date,
    source_year,
    line_name,
    station_code,
    station_name,
    is_weekday,
    is_weekend,
    hour_bucket;