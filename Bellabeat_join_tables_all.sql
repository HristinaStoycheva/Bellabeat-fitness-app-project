/* First I will check if in the main table - daily_activity_all 
there are all the basic data records:
    if we have the all 35 ids
    if we have all the dates for the period - from March 12, 2016 to May 12, 2016

*/

SELECT *
FROM daily_activity_all;

-- 1397 rows

SELECT DISTINCT
    id
FROM daily_activity_all;

-- 35 results

SELECT DISTINCT
    activity_date
FROM daily_activity_all;

-- 62 results

SELECT (35*62)
= 
(SELECT COUNT(*)
FROM daily_activity_all);

-- FALSE

-- So we don't have all the basics here

-- First I will perform the JOIN and then I'll clean the JOINed table.



CREATE TABLE daily_activity_joined AS (
SELECT
    main.*,
    heartrate.average_heartrate,
    d_intensity.sum_intensity,
    d_intensity.avg_intensity,
    d_steps.sum_steps,
    d_calories_m.sum_calories_m,
    d_intensity_m.sum_intensity_m,
    d_intensity_m.avg_intensity_m,
    d_met_m.avg_mets_m,
    d_sleep_m.avg_sleep_m,
    d_sleep_m.log_id_sleep,
    d_steps_m.sum_steps_m,
    d_calories.calories_daily,
    d_calories_2.calories_2,
    d_intensity_2.sedentary_minutes_2,
    d_intensity_2.lightly_active_minutes_2,
    d_intensity_2.fairly_active_minutes_2,
    d_intensity_2.very_active_minutes_2,
    d_intensity_2.sedentary_active_distance_2,
    d_intensity_2.light_active_distance_2,
    d_intensity_2.moderately_active_distance_2,
    d_intensity_2.very_active_distance_2,
    d_steps_2.step_total_2,
    d_sleep_2.total_sleep_records,
    d_sleep_2.total_minutes_asleep,
    d_sleep_2.total_time_in_bed,
    w_joined.daily_calories_sum_w,
    w_joined.daily_intensity_sum_w,
    w_joined.daily_intensity_avg_w,
    w_joined.daily_steps_sum_w,
    loginfo.avg_weight_kg,
    loginfo.avg_weight_pounds,
    loginfo.avg_bmi,
    loginfo.fat,
    loginfo.is_manual_report,
    loginfo.log_id
FROM daily_activity_all AS main
FULL OUTER JOIN daily_heartrate_avg AS heartrate 
    ON main.id = heartrate.id
    AND main.activity_date = heartrate.calculated_date
FULL OUTER JOIN daily_intensity_aggregated AS d_intensity 
    ON main.id = d_intensity.id
    AND main.activity_date = d_intensity.calculated_date
FULL OUTER JOIN daily_steps_aggregated AS d_steps 
    ON main.id = d_steps.id
    AND main.activity_date = d_steps.calculated_date
FULL OUTER JOIN daily_calories_m_aggregared AS d_calories_m 
    ON main.id = d_calories_m.id
    AND main.activity_date = d_calories_m.calculated_date
FULL OUTER JOIN daily_intensity_m_aggregared AS d_intensity_m 
    ON main.id = d_intensity_m.id
    AND main.activity_date = d_intensity_m.calculated_date
FULL OUTER JOIN daily_mets_m_aggregared AS d_met_m 
    ON main.id = d_met_m.id
    AND main.activity_date = d_met_m.calculated_date
FULL OUTER JOIN daily_sleep_m_aggregared AS d_sleep_m 
    ON main.id = d_sleep_m.id
    AND main.activity_date = d_sleep_m.calculated_date
FULL OUTER JOIN daily_steps_m_aggregared AS d_steps_m 
    ON main.id = d_steps_m.id
    AND main.activity_date = d_steps_m.calculated_date
FULL OUTER JOIN daily_calories_aggregated AS d_calories 
    ON main.id = d_calories.id
    AND main.activity_date = d_calories.calculated_date
FULL OUTER JOIN daily_calories_2 AS d_calories_2 
    ON main.id = d_calories_2.id
    AND main.activity_date = d_calories_2.activity_day
FULL OUTER JOIN daily_intensities_2 AS d_intensity_2 
    ON main.id = d_intensity_2.id
    AND main.activity_date = d_intensity_2.activity_day
FULL OUTER JOIN daily_steps_2 AS d_steps_2 
    ON main.id = d_steps_2.id
    AND main.activity_date = d_steps_2.activity_day
FULL OUTER JOIN sleep_day_2 AS d_sleep_2 
    ON main.id = d_sleep_2.id
    AND main.activity_date = d_sleep_2.sleep_day
FULL OUTER JOIN calories_intensity_steps_w_joined AS w_joined
    ON main.id = w_joined.id
    AND main.activity_date = w_joined.calculated_date
FULL OUTER JOIN weight_loginfo_all AS loginfo
    ON main.id = loginfo.id
    AND main.activity_date = loginfo.calculated_date
);


-- Checking new table 

SELECT *
FROM daily_activity_joined;


-- Checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_date,
    total_steps,
    total_distance,
    tracker_distance,
    logged_activities_distance,
    very_active_distance,
    moderately_active_distance,
    light_active_distance,
    sedentary_active_distance,
    very_active_minutes,
    fairly_active_minutes,
    lightly_active_minutes,
    sedentary_minutes,
    calories,
    average_heartrate,
    sum_intensity,
    avg_intensity,
    sum_steps,
    sum_calories_m,
    sum_intensity_m,
    avg_intensity_m,
    avg_mets_m,
    avg_sleep_m,
    log_id_sleep,
    sum_steps_m,
    calories_daily,
    calories_2,
    sedentary_minutes_2,
    lightly_active_minutes_2,
    fairly_active_minutes_2,
    very_active_minutes_2,
    sedentary_active_distance_2,
    light_active_distance_2,
    moderately_active_distance_2,
    very_active_distance_2,
    step_total_2,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
 ORDER BY
    id,
    activity_date,
    total_steps,
    total_distance,
    tracker_distance,
    logged_activities_distance,
    very_active_distance,
    moderately_active_distance,
    light_active_distance,
    sedentary_active_distance,
    very_active_minutes,
    fairly_active_minutes,
    lightly_active_minutes,
    sedentary_minutes,
    calories,
    average_heartrate,
    sum_intensity,
    avg_intensity,
    sum_steps,
    sum_calories_m,
    sum_intensity_m,
    avg_intensity_m,
    avg_mets_m,
    avg_sleep_m,
    log_id_sleep,
    sum_steps_m,
    calories_daily,
    calories_2,
    sedentary_minutes_2,
    lightly_active_minutes_2,
    fairly_active_minutes_2,
    very_active_minutes_2,
    sedentary_active_distance_2,
    light_active_distance_2,
    moderately_active_distance_2,
    very_active_distance_2,
    step_total_2,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
 ) AS rn
FROM daily_activity_joined) AS duplicate_check
WHERE rn > 1;

-- 1318 duplicates

-- Delete duplicates

CREATE TABLE daily_activity_joined_cleaned AS (
SELECT
    *
FROM (SELECT *,
    ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_date,
    total_steps,
    total_distance,
    tracker_distance,
    logged_activities_distance,
    very_active_distance,
    moderately_active_distance,
    light_active_distance,
    sedentary_active_distance,
    very_active_minutes,
    fairly_active_minutes,
    lightly_active_minutes,
    sedentary_minutes,
    calories,
    average_heartrate,
    sum_intensity,
    avg_intensity,
    sum_steps,
    sum_calories_m,
    sum_intensity_m,
    avg_intensity_m,
    avg_mets_m,
    avg_sleep_m,
    log_id_sleep,
    sum_steps_m,
    calories_daily,
    calories_2,
    sedentary_minutes_2,
    lightly_active_minutes_2,
    fairly_active_minutes_2,
    very_active_minutes_2,
    sedentary_active_distance_2,
    light_active_distance_2,
    moderately_active_distance_2,
    very_active_distance_2,
    step_total_2,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
    ORDER BY
    id,
    activity_date,
    total_steps,
    total_distance,
    tracker_distance,
    logged_activities_distance,
    very_active_distance,
    moderately_active_distance,
    light_active_distance,
    sedentary_active_distance,
    very_active_minutes,
    fairly_active_minutes,
    lightly_active_minutes,
    sedentary_minutes,
    calories,
    average_heartrate,
    sum_intensity,
    avg_intensity,
    sum_steps,
    sum_calories_m,
    sum_intensity_m,
    avg_intensity_m,
    avg_mets_m,
    avg_sleep_m,
    log_id_sleep,
    sum_steps_m,
    calories_daily,
    calories_2,
    sedentary_minutes_2,
    lightly_active_minutes_2,
    fairly_active_minutes_2,
    very_active_minutes_2,
    sedentary_active_distance_2,
    light_active_distance_2,
    moderately_active_distance_2,
    very_active_distance_2,
    step_total_2,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
    ) AS rn
    FROM daily_activity_joined) AS duplicate_check
WHERE rn = 1);

DROP TABLE daily_activity_joined;

ALTER TABLE daily_activity_joined_cleaned
RENAME TO daily_activity_joined;

ALTER TABLE daily_activity_joined
DROP COLUMN rn;

-- Check for duplicates again

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_date,
    total_steps,
    total_distance,
    tracker_distance,
    logged_activities_distance,
    very_active_distance,
    moderately_active_distance,
    light_active_distance,
    sedentary_active_distance,
    very_active_minutes,
    fairly_active_minutes,
    lightly_active_minutes,
    sedentary_minutes,
    calories,
    average_heartrate,
    sum_intensity,
    avg_intensity,
    sum_steps,
    sum_calories_m,
    sum_intensity_m,
    avg_intensity_m,
    avg_mets_m,
    avg_sleep_m,
    log_id_sleep,
    sum_steps_m,
    calories_daily,
    calories_2,
    sedentary_minutes_2,
    lightly_active_minutes_2,
    fairly_active_minutes_2,
    very_active_minutes_2,
    sedentary_active_distance_2,
    light_active_distance_2,
    moderately_active_distance_2,
    very_active_distance_2,
    step_total_2,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
 ORDER BY
    id,
    activity_date,
    total_steps,
    total_distance,
    tracker_distance,
    logged_activities_distance,
    very_active_distance,
    moderately_active_distance,
    light_active_distance,
    sedentary_active_distance,
    very_active_minutes,
    fairly_active_minutes,
    lightly_active_minutes,
    sedentary_minutes,
    calories,
    average_heartrate,
    sum_intensity,
    avg_intensity,
    sum_steps,
    sum_calories_m,
    sum_intensity_m,
    avg_intensity_m,
    avg_mets_m,
    avg_sleep_m,
    log_id_sleep,
    sum_steps_m,
    calories_daily,
    calories_2,
    sedentary_minutes_2,
    lightly_active_minutes_2,
    fairly_active_minutes_2,
    very_active_minutes_2,
    sedentary_active_distance_2,
    light_active_distance_2,
    moderately_active_distance_2,
    very_active_distance_2,
    step_total_2,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
 ) AS rn
FROM daily_activity_joined) AS duplicate_check
WHERE rn > 1;

-- Check the table

SELECT *
FROM daily_activity;

/* Checking how many NULL values there are in the first column - id, 
so I won't expect them to be uploaded in the spreadsheets 
when I continiue the analysis there. */


SELECT *
FROM daily_activity_joined
WHERE id IS NULL;

-- 3333 rows of NULL values in column id.
-- Subtract 3333 from the whole number of rows

SELECT(14302-3333) AS spreadsheet_rows_number

-- So my spreadsheet will be 10969 rows



-- Next I will extract the table and will continue the analysis in spreadsheets, Tableau and Power Point.

