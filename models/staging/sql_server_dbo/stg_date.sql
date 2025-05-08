{{ config(
    materialized='table'
) }}

WITH date_spine AS (

    {{ dbt_utils.date_spine(
        start_date="'2021-01-01'",
        end_date="'2024-12-31'",
        datepart="day"
    ) }}

)

SELECT 
    date_day AS date,
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(MONTH FROM date_day) AS month,
    EXTRACT(DAY FROM date_day) AS day,
    EXTRACT(DAYOFWEEK FROM date_day) AS day_of_week,
    TRIM(TO_CHAR(date_day, 'MMMM')) AS month_name,
    TRIM(TO_CHAR(date_day, 'DY')) AS day_name,
    CASE 
        WHEN date_day <= CURRENT_DATE THEN TRUE
        ELSE FALSE
    END AS is_past
FROM date_spine
ORDER BY date_day
