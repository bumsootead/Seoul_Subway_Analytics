# Seoul Subway & Mobility Analytics
<img width="1851" height="839" alt="Dashboard" src="https://github.com/user-attachments/assets/4785cf77-74b4-49fc-be82-a936de28b5a6" />

## Overview
This project analyzes Seoul's subway travel patterns to understand how different stations function within the city's urban mobility network.
The analysis standardizes official 2024 and 2025 Seoul Metro datasets into a common station-hour model, identifies recurring commute and leisure patterns, classifies station mobility roles, and presents findings through Python visualizations and an interactive Tableau dashboard.

## Seoul Subway Mobility Hub Analysis: Identifying Commuter, Residential, and Commercial Travel Patterns

Core question
> How do subway travel patterns vary across Seoul, and which stations function primarily as commuter/employment hubs, residential-origin hubs, commercial/leisure hubs, or high-volume mixed mobility hubs?

## Interactive Tableau Dashboard

[Explore the live Seoul Subway Mobility Dashboard](https://public.tableau.com/app/profile/bumsoo.jeong/viz/SeoulSubwayAnalysis/1_1)

## Key Findings

- **Weekday activity is commuter-led.** Average citywide passenger activity was approximately 10.02 million movements on 2024 weekdays, compared with 6.51 million on weekends.
- **Demand follows a consistent two-peak commute pattern** The strongest weekday demand periods occur at**8:00–09:00 and 18:00–19:00.**
- **Two weekday peaks recur across the network:** 08:00–09:00 is the leading morning period and 18:00–19:00 is the leading evening period. Weekend demand shifts later, concentrating in the afternoon.
- **Line 2 is the network's largest activity corridor**, with approximately 1.55 billion passenger movements across the combined available period.
- **Commuter/employment hubs** include Gangnam, Yeoksam, Samsung (Trade Center), Seolleung, Euljiro 1-ga, and Gasan Digital Complex; these stations have high morning alighting and high evening boarding flows.
- **Residential-origin hubs** include Sillim, Kkachisan, Yeonsinnae, Ssangmun, and Hwagok; these show the reverse directional profile.
- **Commercial/leisure candidates** such as Jongno 3-ga, Jongno 5-ga, Hoehyeon (Namdaemun Market), Cheongnyangni, and Express Bus Terminal have comparatively high midday activity shares.
- **Comparable Jul–Dec year-over-year activity was broadly stable.** The median station-level change from Jul–Dec 2024 to Jul–Dec 2025 was +1.81%.

## Significant Data Change

April 2024 is a major outlier. Average daily activity was about 12.82 million, compared with 8.91 million in March and 9.04 million in May; the uplift occurred across all lines and reversed immediately afterward. The project flags April 2024 as a likely reporting, extraction, or aggregation anomaly rather than treating it as confirmed demand growth.

## Data Sources

| File | Coverage | Grain | Use |
|---|---|---|---|
| `서울교통공사_역별 일별 시간대별 승하차인원 정보_20241231.csv` | Jan–Dec 2024 | Date × line × station × direction | Total ridership |
| `서울교통공사_1_8호선 역별 일별 시간대별 승객유형별 승하차인원_20251231.csv` | Jul–Dec 2025 | Date × line × station × direction × passenger type | Passenger-type analysis and 2025 totals |

The 2024 source is already aggregated across passenger types. The 2025 source is first aggregated across passenger types before the years are combined. The two raw files use CP949 encoding.

## Project Workflow

```text
Official CSV files
  → Python cleaning and validation
  → Common station-hour total-ridership layer
  → PostgreSQL analytical queries and station-function metrics
  → Evidence table and Tableau-ready extracts
  → Interactive dashboard and portfolio findings
```

## Cleaned Data Products

| File | Description |
|---|---|
| `station_hourly_total.csv` | Unified total ridership at date × line × station × direction × hour grain. |
| `station_hourly_passenger_type_2025.csv` | Jul–Dec 2025 ridership at passenger-type detail. |
| `station_daily_wide.csv` | Daily station boardings, alightings, total activity, and net boarding. |
| `final_evidence_table.csv` | Final station-role evidence table for analysis and Tableau. |

`final_evidence_table.csv` contains 547 station-year records and the fields below:

```text
source_year, station_name, line_name, station_code,
total_weekday_activity, morning_net_alighting,
evening_net_boarding, midday_activity, midday_share_pct,
station_function, yoy_jul_dec_change_pct
```

## Station Function Method

The analysis uses weekday flows because they best represent routine commuting behavior.

- **Commuter / employment hub:** Morning alightings exceed morning boardings and evening boardings exceed evening alightings; activity is above the 75th percentile.
- **Residential origin hub:** Morning boardings exceed morning alightings and evening alightings exceed evening boardings; activity is above the 75th percentile.
- **Commercial / leisure hub:** Midday activity share is high and morning directional imbalance is limited.
- **High-volume mixed hub:** Very high activity without a clean directional classification.
- **Local / balanced station:** Remaining stations without a dominant pattern.

These are mobility-pattern classifications. They are not proof of surrounding land use because the project does not include employment, housing, retail, tourism, or station-transfer data.

## Technology

- **Python:** Pandas, NumPy, Matplotlib, Seaborn
- **Database:** PostgreSQL
- **Visualization:** Tableau
- **Data source format:** CP949-encoded CSV

## Running the Project

1. Place the two raw CSV files in `data/raw/`.
2. Run the cleaning notebook/script to produce the standardized files in `data/cleaned/`.
3. Load `station_hourly_total.csv` and `station_hourly_passenger_type_2025.csv` into PostgreSQL staging tables.
4. Run the schema, validation, and analysis SQL scripts.
5. Export the final evidence table and Tableau extracts.
6. Build the Tableau dashboard using the cleaned and evidence-table outputs.

## Data Quality and Limitations

- **2025 is partial-year data.** It covers July–December only, so year-over-year comparisons must use July–December 2024 versus July–December 2025.
- **April 2024 is anomalous.** Exclude it from trend claims unless validated against the official source.
- **Station coverage differs slightly:** there are 274 line-station pairs in 2024 and 273 in 2025. Check for renamed, added, removed, or recoded stations before interpreting station-level changes.
- **Encoding:** If the wide cleaned CSVs display corrupted Korean labels, regenerate them from the CP949 raw files with `encoding='cp949'`, then export UTF-8 with `encoding='utf-8-sig'`. `final_evidence_table.csv` has verified Korean station and line labels and should be used for dashboard labels.
- **No causal variables:** Weather, holidays, train frequency, land use, employment density, and transfers are not available in this dataset.

## Repository Structure

```text
.
├── data/
│   ├── raw/
│   ├── cleaned/
│   └── tableau/
├── notebooks/
│   ├── 01_cleaning.ipynb
│   ├── 02_sql_validation.ipynb
│   ├── 03_python_analysis.ipynb
│   └── 04_insights.ipynb
├── sql/
│   ├── 01_schema.sql
│   ├── 02_load.sql
│   └── 03_analysis.sql
├── outputs/
│   ├── figures/
│   └── tables/
└── README.md
```

## Portfolio Summary

> Analyzed official Seoul Metro ridership data across Lines 1–8 using Python, PostgreSQL, and Tableau; built a standardized hourly passenger model, identified peak-demand and directional travel patterns, and classified stations into commuter, residential, commercial, and mixed mobility hubs using data-driven flow metrics.
