CREATE DATABASE seoul_subway;

CREATE SCHEMA IF NOT EXISTS subway;

CREATE TABLE subway.stg_station_hourly_total (
    service_date DATE,
    source_year INTEGER,
    line_name TEXT,
    station_code TEXT,
    station_name TEXT,
    direction TEXT,
    passenger_type TEXT,
    hour_bucket TEXT,
    passenger_count BIGINT,
    day_of_week TEXT,
    is_weekday BOOLEAN,
    is_weekend BOOLEAN,
    month INTEGER,
    year_month TEXT
);

CREATE TABLE subway.stg_station_hourly_type_2025 (
    service_date DATE,
    source_year INTEGER,
    line_name TEXT,
    station_code TEXT,
    station_name TEXT,
    direction TEXT,
    passenger_type TEXT,
    hour_bucket TEXT,
    passenger_count BIGINT,
    day_of_week TEXT,
    is_weekday BOOLEAN,
    is_weekend BOOLEAN,
    month INTEGER,
    year_month TEXT
);
