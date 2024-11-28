-- CHECKING AND CLEANING ALL THE 11 TABLES		
		
-- 1. Table daily_activity		

SELECT *
FROM daily_activity;

SELECT 
    COUNT (*)
FROM daily_activity;

-- 457 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.


SELECT *
FROM daily_activity
WHERE activity_date ~ '^\d{1}/\d{2}/\d{4}';

-- 152 rows

SELECT *
FROM daily_activity
WHERE activity_date ~ '^\d{1}/\d{1}/\d{4}';

-- 305 rows

-- Now I will convert the date based on the different structures
-- First I'm checking if it works properly.

SELECT DISTINCT pg_typeof(converted_date)
FROM (SELECT
    activity_date,
    CASE 
        WHEN activity_date ~ '^\d{1}/\d{2}/\d{4}' THEN 
            TO_DATE(activity_date, 'MM/DD/YYYY')::DATE
        WHEN activity_date ~ '^\d{1}/\d{1}/\d{4}' THEN 
            TO_DATE(activity_date, 'MM/DD/YYYY')::DATE
        ELSE NULL
    END AS converted_date
FROM daily_activity);

-- Before column altering I am checking for duplicates

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
    calories
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
    calories
 ) AS rn
FROM daily_activity) AS duplicate_check
WHERE rn > 1;

-- Then I alter activity_date column


ALTER TABLE daily_activity
ALTER COLUMN activity_date TYPE date
USING CASE 
        WHEN activity_date ~ '^\d{1}/\d{2}/\d{4}' THEN 
            TO_DATE(activity_date, 'MM/DD/YYYY')::DATE
        WHEN activity_date ~ '^\d{1}/\d{1}/\d{4}' THEN 
            TO_DATE(activity_date, 'MM/DD/YYYY')::DATE
        ELSE NULL
    END;

-- Check data type in activity_date column

SELECT DISTINCT pg_typeof(activity_date)
FROM daily_activity;

-- Then I've checked with the query above if there are duplicates after column altering and the result is still 0.

-- Now I will format the numeric columns to 2 decimal places.

ALTER TABLE daily_activity
ALTER COLUMN total_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_activity
ALTER COLUMN tracker_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_activity
ALTER COLUMN logged_activities_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_activity
ALTER COLUMN very_active_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_activity
ALTER COLUMN moderately_active_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_activity
ALTER COLUMN light_active_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_activity
ALTER COLUMN sedentary_active_distance TYPE NUMERIC(10,2);

-- Checking if everything is ok

SELECT *
FROM daily_activity
WHERE 	id	IS NULL
    OR	activity_date	IS NULL
    OR	total_steps	IS NULL
    OR	total_distance	IS NULL
    OR	tracker_distance	IS NULL
    OR	logged_activities_distance	IS NULL
    OR	very_active_distance	IS NULL
    OR	moderately_active_distance	IS NULL
    OR	light_active_distance	IS NULL
    OR	sedentary_active_distance	IS NULL
    OR	very_active_minutes	IS NULL
    OR	fairly_active_minutes	IS NULL
    OR	lightly_active_minutes	IS NULL
    OR	sedentary_minutes	IS NULL
    OR	calories	IS NULL;


-- 2. Table heartrate_seconds		

SELECT *
FROM heartrate_seconds;

SELECT 
    COUNT (*)
FROM heartrate_seconds;

-- 1154681 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM heartrate_seconds
WHERE time ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 167392 rows

(SELECT COUNT(*)
FROM heartrate_seconds
WHERE time ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 58249 rows

(SELECT COUNT(*)
FROM heartrate_seconds
WHERE time ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 701926 rows

(SELECT COUNT(*)
FROM heartrate_seconds
WHERE time ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 227114 rows
)

=

(SELECT 
    COUNT (*)
FROM heartrate_seconds);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    time,
    value
 ORDER BY
    id,
    time,
    value
 ) AS rn
FROM heartrate_seconds) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 , 
because at 3:00 AM there is a time change because of Daylight Saving Time */

SELECT *
FROM heartrate_seconds
WHERE time LIKE '3/27/2016%';

-- In this data set this date doesn't exist.
-- Now I'll alter the time column
-- First check it

SELECT DISTINCT pg_typeof(converted_date)
FROM(
    SELECT
        time,
        CASE 
            WHEN time ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            WHEN time ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            WHEN time ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            WHEN time ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            ELSE NULL
        END AS converted_date
    FROM heartrate_seconds);


-- Before column altering I am checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    time,
    value
 ORDER BY
    id,
    time,
    value
 ) AS rn
FROM heartrate_seconds) AS duplicate_check
WHERE rn > 1;

-- Then I alter time column


ALTER TABLE heartrate_seconds
ALTER COLUMN time TYPE timestamp WITHOUT TIME ZONE
USING CASE 
            WHEN time ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            WHEN time ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            WHEN time ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            WHEN time ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
                TO_TIMESTAMP(time, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
            ELSE NULL
        END;

-- Check data type in time column

SELECT DISTINCT pg_typeof(time)
FROM heartrate_seconds;

-- Then I've checked with the query above if there are duplicates after column altering and the result is still 0.

-- Checking if everything is ok

SELECT *
FROM heartrate_seconds
WHERE 	id	IS NULL
    OR	time IS NULL
    OR	value IS NULL;


SELECT *
FROM heartrate_seconds
LIMIT 10;



-- 3. Table hourly_calories		

SELECT *
FROM hourly_calories;

SELECT 
    COUNT (*)
FROM hourly_calories;

-- 24084 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM hourly_calories
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 12932 rows

(SELECT COUNT(*)
FROM hourly_calories
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 4278 rows

(SELECT COUNT(*)
FROM hourly_calories
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 5159 rows

(SELECT COUNT(*)
FROM hourly_calories
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 1715 rows
)

=

(SELECT 
    COUNT (*)
FROM hourly_calories);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    calories
 ORDER BY
    id,
    activity_hour,
    calories
 ) AS rn
FROM hourly_calories) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 , 
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour, that's why I will use exact match in WHERE clause*/

SELECT *
FROM hourly_calories
WHERE activity_hour = '3/27/2016 3:00:00 AM';

-- There are 33 records fot this time, so I'll modify my query for timestamp formatting acording this.

SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_hour,
    CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM hourly_calories);

-- Checking the problem time

SELECT DISTINCT
    activity_hour,
    CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM hourly_calories
WHERE activity_hour = '3/27/2016 3:00:00 AM'

-- Before column altering I am checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    calories
 ORDER BY
    id,
    activity_hour,
    calories
 ) AS rn
FROM hourly_calories) AS duplicate_check
WHERE rn > 1;

-- Then I alter time column


ALTER TABLE hourly_calories
ALTER COLUMN activity_hour TYPE timestamp WITHOUT TIME ZONE
USING CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in activity_hour column

SELECT DISTINCT pg_typeof(activity_hour)
FROM hourly_calories;

-- Then I've checked with the query above if there are duplicates after column altering and the result is still 0.

-- Checking if everything is ok



SELECT *
FROM hourly_calories
WHERE 	id	IS NULL
    OR	activity_hour IS NULL
    OR	calories IS NULL;


SELECT *
FROM hourly_calories
LIMIT 10;




-- 4. Table hourly_intensities		

SELECT *
FROM hourly_intensities;

SELECT 
    COUNT (*)
FROM hourly_intensities;

-- 24084 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM hourly_intensities
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 12932 rows

(SELECT COUNT(*)
FROM hourly_intensities
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 4278 rows

(SELECT COUNT(*)
FROM hourly_intensities
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 5159 rows

(SELECT COUNT(*)
FROM hourly_intensities
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 1715 rows
)

=

(SELECT 
    COUNT (*)
FROM hourly_intensities);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    total_intensity,
    average_intensity
 ORDER BY
    id,
    activity_hour,
    total_intensity,
    average_intensity
 ) AS rn
FROM hourly_intensities) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 , 
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour, that's why I will use exact match in WHERE clause*/

SELECT *
FROM hourly_intensities
WHERE activity_hour = '3/27/2016 3:00:00 AM';

-- There are 33 records fot this time, so I'll modify my query for timestamp formatting acording this.

SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_hour,
    CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM hourly_intensities);

-- Checking the problem time

SELECT DISTINCT
    activity_hour,
    CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM hourly_intensities
WHERE activity_hour = '3/27/2016 3:00:00 AM';

-- Then I alter tiactivity_hour me column


ALTER TABLE hourly_intensities
ALTER COLUMN activity_hour TYPE timestamp WITHOUT TIME ZONE
USING CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' 
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN 
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in activity_hour column

SELECT DISTINCT pg_typeof(activity_hour)
FROM hourly_intensities;

-- Then I've checked with the query above if there are duplicates after column altering and the result is still 0.


-- Now I will format the numeric column to 2 decimal places.

ALTER TABLE hourly_intensities
ALTER COLUMN average_intensity TYPE NUMERIC(10,2);

-- Checking if everything is ok

SELECT *
FROM hourly_intensities
WHERE 	id	IS NULL
    OR activity_hour IS NULL
    OR	total_intensity IS NULL
    OR	average_intensity IS NULL;


SELECT *
FROM hourly_intensities
LIMIT 10;



-- 5. Table hourly_steps      

SELECT *
FROM hourly_steps;

SELECT
 COUNT (*)
FROM hourly_steps;

-- 24084 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM hourly_steps
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 12932 rows

(SELECT COUNT(*)
FROM hourly_steps
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 4278 rows

(SELECT COUNT(*)
FROM hourly_steps
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 5159 rows

(SELECT COUNT(*)
FROM hourly_steps
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 1715 rows
)

=

(SELECT
 COUNT (*)
FROM hourly_steps);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    step_total
 ORDER BY
    id,
    activity_hour,
    step_total
 ) AS rn
FROM hourly_steps) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour, that's why I will use exact match in WHERE clause*/

SELECT *
FROM hourly_steps
WHERE activity_hour = '3/27/2016 3:00:00 AM';

-- There are 33 records fot this time, so I'll modify my query for timestamp formatting acording this.

SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_hour,
    CASE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM hourly_steps);

-- Checking the problem time

SELECT DISTINCT
    activity_hour,
    CASE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
         WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM hourly_steps
WHERE activity_hour = '3/27/2016 3:00:00 AM';

-- Then I alter activity_hour column


ALTER TABLE hourly_steps
ALTER COLUMN activity_hour TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'
            AND activity_hour != '3/27/2016 3:00:00 AM' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'
            AND activity_hour = '3/27/2016 3:00:00 AM' THEN
            TO_TIMESTAMP('3/27/2016 2:00:00 AM', 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE + INTERVAL '1 hour'
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in activity_hour column

SELECT DISTINCT pg_typeof(activity_hour)
FROM hourly_steps;

-- Then I've checked with the query above if there are duplicates after column altering and the result is still 0.


-- Checking if everything is ok

SELECT *
FROM hourly_steps
WHERE id IS NULL
OR activity_hour IS NULL
OR step_total IS NULL;


SELECT *
FROM hourly_steps
LIMIT 10;


-- 6. Table minute_calories_narrow      

SELECT *
FROM minute_calories_narrow;

SELECT
    COUNT (*)
FROM minute_calories_narrow;

-- 1445040 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_calories_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 775920 rows

(SELECT COUNT(*)
FROM minute_calories_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 256680 rows

(SELECT COUNT(*)
FROM minute_calories_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 309540 rows

(SELECT COUNT(*)
FROM minute_calories_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 102900 rows
)

=

(SELECT
    COUNT (*)
FROM minute_calories_narrow);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_minute,
    calories
 ORDER BY
id,
    activity_minute,
    calories
 ) AS rn
FROM minute_calories_narrow) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_calories_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- Checking the structure consistency

SELECT DISTINCT
    LENGTH(activity_minute)
FROM minute_calories_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

SELECT DISTINCT(activity_minute)
FROM minute_calories_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- There are 1980 records fot this time, which are 20 charactes length and 60 unique values, so I'll modify my query for timestamp formatting acording this.
-- But now I will need more complex solution because we have a range for the date 2016-03-27 from 3:00:00 AM to 3:59:00 AM.
-- And I will use a function

CREATE OR REPLACE FUNCTION adjust_dst_timestamp(timestamp_str TEXT) RETURNS TIMESTAMP WITHOUT TIME ZONE AS $$
DECLARE
  adjusted_timestamp TIMESTAMP WITHOUT TIME ZONE;
BEGIN
  IF timestamp_str ~ '^3/27/2016 3:\d{2}:\d{2} AM$' THEN
    -- Replace only the first occurrence of '3:' with '2:'
    adjusted_timestamp := TO_TIMESTAMP(regexp_replace(timestamp_str, '^(\d{2}/\d{2}/\d{4}) 3:', '\1 2:', 'g'), 'MM/DD/YYYY HH24:MI:SS AM')::timestamp WITHOUT TIME ZONE - INTERVAL '1 hour';
  ELSE
    adjusted_timestamp := TO_TIMESTAMP(timestamp_str, 'MM/DD/YYYY HH24:MI:SS AM,PM');
  END IF;
  RETURN adjusted_timestamp;
END;
$$ LANGUAGE plpgsql;


-- Checking the function

SELECT
    activity_minute,
    adjust_dst_timestamp(activity_minute) AS adjusted_timestamp
FROM
  minute_calories_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';

-- Now insert the function in the whole conversion query to check it before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_calories_narrow);

-- Checking the query with the function for duplicates before column altering

SELECT
 activity_minute,
 converted_date
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    converted_date,
    calories
 ORDER BY
    id,
    converted_date,
    calories
 ) AS rn
FROM (
    SELECT
        id,
        activity_minute,
        calories,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_calories_narrow) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    converted_date,
    calories
 ORDER BY
    id,
    converted_date,
    calories
 ) AS rn
FROM (
    SELECT
        id,
        activity_minute,
        calories,
        CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_calories_narrow) AS duplicate_check)
WHERE rn > 1;

-- Checking again the problem time


SELECT 
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_calories_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';


-- Then I alter activity_minute column


ALTER TABLE minute_calories_narrow
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in activity_minute column

SELECT DISTINCT pg_typeof(activity_minute)
FROM minute_calories_narrow;


-- Now I will format the numeric column to 2 decimal places.

ALTER TABLE minute_calories_narrow
ALTER COLUMN calories TYPE NUMERIC(10,2);

-- Checking if everything is ok

SELECT *
FROM minute_calories_narrow
WHERE id IS NULL
OR activity_minute IS NULL
OR calories IS NULL;


SELECT *
FROM minute_calories_narrow
LIMIT 10;


-- 7. Table minute_intensities_narrow      

SELECT *
FROM minute_intensities_narrow;

SELECT
    COUNT (*)
FROM minute_intensities_narrow;

-- 1445040 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_intensities_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 775920 rows

(SELECT COUNT(*)
FROM minute_intensities_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 256680 rows

(SELECT COUNT(*)
FROM minute_intensities_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 309540 rows

(SELECT COUNT(*)
FROM minute_intensities_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 102900 rows
)

=

(SELECT
    COUNT (*)
FROM minute_intensities_narrow);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_minute,
    intensity
 ORDER BY
    id,
    activity_minute,
    intensity
 ) AS rn
FROM minute_intensities_narrow) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_intensities_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- Checking the structure consistency

SELECT DISTINCT
    LENGTH(activity_minute)
FROM minute_intensities_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

SELECT DISTINCT(activity_minute)
FROM minute_intensities_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- There are 1980 records fot this time, which are 20 charactes length and 60 unique values, so I'll modify my query for timestamp formatting acording this.
-- But now I will need more complex solution because we have a range for the date 2016-03-27 from 3:00:00 AM to 3:59:00 AM.
--  I will use the function which created for the previous table

-- Checking the function

SELECT
    activity_minute,
    adjust_dst_timestamp(activity_minute) AS adjusted_timestamp
FROM
  minute_intensities_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';

-- Now insert the function in the whole conversion query to check it before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_intensities_narrow);

-- Checking the query with the function for duplicates before column altering

SELECT
 activity_minute,
 converted_date
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    converted_date,
    intensity
 ORDER BY
    id,
    converted_date,
    intensity
 ) AS rn
FROM (
    SELECT
    id,
    activity_minute,
    intensity,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_intensities_narrow) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    converted_date,
    intensity
 ORDER BY
    id,
    converted_date,
    intensity
 ) AS rn
FROM (
    SELECT
        id,
        activity_minute,
        intensity,
        CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_intensities_narrow) AS duplicate_check)
WHERE rn > 1;

-- Checking again the problem time


SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_intensities_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';


-- Then I alter activity_minute column


ALTER TABLE minute_intensities_narrow
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in activity_minute column

SELECT DISTINCT pg_typeof(activity_minute)
FROM minute_intensities_narrow;


-- Checking if everything is ok

SELECT *
FROM minute_intensities_narrow
WHERE id IS NULL
OR activity_minute IS NULL
OR intensity IS NULL;


SELECT *
FROM minute_intensities_narrow
LIMIT 10;




-- 8. Table minute_met_narrow      

SELECT *
FROM minute_met_narrow;

SELECT
    COUNT (*)
FROM minute_met_narrow;

-- 1445040 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_met_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 775920 rows

(SELECT COUNT(*)
FROM minute_met_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 256680 rows

(SELECT COUNT(*)
FROM minute_met_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 309540 rows

(SELECT COUNT(*)
FROM minute_met_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 102900 rows
)

=

(SELECT
    COUNT (*)
FROM minute_met_narrow);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_minute,
    mets
 ORDER BY
    id,
    activity_minute,
    mets
 ) AS rn
FROM minute_met_narrow) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_met_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- Checking the structure consistency

SELECT DISTINCT
    LENGTH(activity_minute)
FROM minute_met_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

SELECT DISTINCT(activity_minute)
FROM minute_met_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- There are 1980 records fot this time, which are 20 charactes length and 60 unique values, so I'll modify my query for timestamp formatting acording this.
-- But now I will need more complex solution because we have a range for the date 2016-03-27 from 3:00:00 AM to 3:59:00 AM.
--  I will use the function which created for the previous table

-- Checking the function

SELECT
    activity_minute,
    adjust_dst_timestamp(activity_minute) AS adjusted_timestamp
FROM
  minute_met_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';

-- Now insert the function in the whole conversion query to check it before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_met_narrow);

-- Checking the query with the function for duplicates before column altering

SELECT
 activity_minute,
 converted_date
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    converted_date,
    mets
 ORDER BY
    id,
    converted_date,
    mets
 ) AS rn
FROM (
    SELECT
    id,
    activity_minute,
    mets,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_met_narrow) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    converted_date,
    mets
 ORDER BY
    id,
    converted_date,
    mets
 ) AS rn
FROM (
    SELECT
        id,
        activity_minute,
        mets,
        CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_met_narrow) AS duplicate_check)
WHERE rn > 1;

-- Checking again the problem time


SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_met_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';


-- Then I alter activity_minute column


ALTER TABLE minute_met_narrow
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in activity_minute column

SELECT DISTINCT pg_typeof(activity_minute)
FROM minute_met_narrow;


-- Checking if everything is ok

SELECT *
FROM minute_met_narrow
WHERE id IS NULL
OR activity_minute IS NULL
OR mets IS NULL;


SELECT *
FROM minute_met_narrow
LIMIT 10;


-- 9. Table minute_sleep      

SELECT *
FROM minute_sleep;

SELECT
    COUNT (*)
FROM minute_sleep;

-- 198559 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_sleep
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 106728 rows

(SELECT COUNT(*)
FROM minute_sleep
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 31647 rows

(SELECT COUNT(*)
FROM minute_sleep
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 47616 rows

(SELECT COUNT(*)
FROM minute_sleep
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 12568 rows
)

=

(SELECT
    COUNT (*)
FROM minute_sleep);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    date,
    value,
    log_id
 ORDER BY
    id,
    date,
    value,
    log_id
 ) AS rn
FROM minute_sleep) AS duplicate_check
WHERE rn > 1;

-- 525 duplicates
-- I am checking one row of the duplicates to see if its really duplicated record

SELECT *
FROM minute_sleep
WHERE id = 4319703577
    AND date = '4/5/2016 10:50:00 PM'
    AND value = 3
    AND log_id = 11344563687

-- When I' ve checked the id 4319703577 I came back to check another one, but I noticed that duplicates apper only for this id.
-- Below I am checking my observation:

SELECT DISTINCT id,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    date,
    value,
    log_id
 ORDER BY
    id,
    date,
    value,
    log_id
 ) AS rn
FROM minute_sleep

-- The only dulicate rows are for id 4319703577


/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_sleep
WHERE date LIKE '%3/27/2016 3:__:__ AM';

-- Checking the structure consistency

SELECT DISTINCT
    LENGTH(date)
FROM minute_sleep
WHERE date LIKE '%3/27/2016 3:__:__ AM';

SELECT DISTINCT(date)
FROM minute_sleep
WHERE date LIKE '%3/27/2016 3:__:__ AM';

-- There are 651 records fot this time, which are 20 charactes length and 120 unique values, so I'll modify my query for timestamp formatting acording this.
-- But now I will need more complex solution because we have time for the date 2016-03-27, which includes hour, minutes and seconds.
--  I will use the function which created for the previous table

-- Checking the function

SELECT
    date,
    adjust_dst_timestamp(date) AS adjusted_timestamp
FROM
  minute_sleep
WHERE date LIKE '3/27/2016 3:__:__ AM';

-- Now insert the function in the whole conversion query to check it before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    date,
    CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(date)
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_sleep);

-- Checking the query with the function for duplicates before column altering

SELECT
 date,
 converted_date
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    date,
    value,
    log_id
 ORDER BY
    id,
    date,
    value,
    log_id
 ) AS rn
FROM (
    SELECT
    id,
    date,
    value,
    log_id,
    CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(date)
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_sleep) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    date,
    value,
    log_id
 ORDER BY
    id,
    date,
    value,
    log_id
 ) AS rn
FROM (
    SELECT
    id,
    date,
    value,
    log_id,
        CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(date)
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_sleep) AS duplicate_check)
WHERE rn > 1;

-- Checking again the problem time


SELECT
    date,
    CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(date)
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_sleep
WHERE date LIKE '3/27/2016 3:__:__ AM';


-- Then I alter date column


ALTER TABLE minute_sleep
ALTER COLUMN date TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(date)
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in date column

SELECT DISTINCT pg_typeof(date)
FROM minute_sleep;

-- Now when I have consistent data I'll delete duplicate rows

CREATE TABLE minute_sleep_clean AS (
SELECT
    *
FROM (SELECT *,
    ROW_NUMBER() OVER (PARTITION BY
        id,
        date,
        value,
        log_id
    ORDER BY
        id,
        date,
        value,
        log_id
    ) AS rn
    FROM minute_sleep) AS duplicate_check
WHERE rn = 1);

DROP TABLE minute_sleep;

ALTER TABLE minute_sleep_clean
RENAME TO minute_sleep;

ALTER TABLE minute_sleep
DROP COLUMN rn;

-- Checking if everything is ok

SELECT *
FROM minute_sleep
WHERE id IS NULL
OR date IS NULL
OR value IS NULL
OR log_id IS NULL

SELECT *
FROM minute_sleep
LIMIT 10;


-- 10. Table minute_steps_narrow      

SELECT *
FROM minute_steps_narrow;

SELECT
    COUNT (*)
FROM minute_steps_narrow;

-- 1445040 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_steps_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 775920 rows

(SELECT COUNT(*)
FROM minute_steps_narrow
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 256680 rows

(SELECT COUNT(*)
FROM minute_steps_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 309540 rows

(SELECT COUNT(*)
FROM minute_steps_narrow
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 102900 rows
)

=

(SELECT
    COUNT (*)
FROM minute_steps_narrow);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_minute,
    steps
 ORDER BY
    id,
    activity_minute,
    steps
 ) AS rn
FROM minute_steps_narrow) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_steps_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- Checking the structure consistency

SELECT DISTINCT
    LENGTH(activity_minute)
FROM minute_steps_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

SELECT DISTINCT(activity_minute)
FROM minute_steps_narrow
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- There are 1980 records fot this time, which are 20 charactes length and 60 unique values, so I'll modify my query for timestamp formatting acording this.
-- But now I will need more complex solution because we have a range for the date 2016-03-27 from 3:00:00 AM to 3:59:00 AM.
--  I will use the function which created for the previous table

-- Checking the function

SELECT
    activity_minute,
    adjust_dst_timestamp(activity_minute) AS adjusted_timestamp
FROM
  minute_steps_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';

-- Now insert the function in the whole conversion query to check it before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_steps_narrow);

-- Checking the query with the function for duplicates before column altering

SELECT
 activity_minute,
 converted_date
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_minute,
    steps
 ORDER BY
    id,
    activity_minute,
    steps
 ) AS rn
FROM (
    SELECT
    id,
    activity_minute,
    steps,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_steps_narrow) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_minute,
    steps
 ORDER BY
    id,
    activity_minute,
    steps
 ) AS rn
FROM (
    SELECT
    id,
    activity_minute,
    steps,
        CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_steps_narrow) AS duplicate_check)
WHERE rn > 1;

-- Checking again the problem time


SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_steps_narrow
WHERE activity_minute LIKE '3/27/2016 3:__:__ AM';


-- Then I alter date column


ALTER TABLE minute_steps_narrow
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            adjust_dst_timestamp(activity_minute)
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in date column

SELECT DISTINCT pg_typeof(activity_minute)
FROM minute_steps_narrow;



-- Checking if everything is ok

SELECT *
FROM minute_steps_narrow
WHERE id IS NULL
    OR activity_minute IS NULL
    OR steps IS NULL;


SELECT *
FROM minute_steps_narrow
LIMIT 10;


-- 11. Table weight_loginfo      

SELECT *
FROM weight_loginfo;

SELECT
    COUNT (*)
FROM weight_loginfo;

-- 33 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM weight_loginfo
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 3 rows

(SELECT COUNT(*)
FROM weight_loginfo
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 6 rows

(SELECT COUNT(*)
FROM weight_loginfo
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 7 rows

(SELECT COUNT(*)
FROM weight_loginfo
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 17 rows
)

=

(SELECT
    COUNT (*)
FROM weight_loginfo);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id
 ORDER BY
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id
 ) AS rn
FROM weight_loginfo) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM weight_loginfo
WHERE date LIKE '%3/27/2016 3:__:__ AM';

-- No data for this time
-- Checking the function


-- Now insert the conversion query to check it before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    date,
    CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM weight_loginfo);

-- Checking the query for duplicates before column altering

SELECT
 date,
 converted_date
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id
 ORDER BY
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id
 ) AS rn
FROM (
    SELECT
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id,
    CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM weight_loginfo) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id
 ORDER BY
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id
 ) AS rn
FROM (
    SELECT
    id,
    date,
    weight_kg,
    weight_pounds,
    fat,
    bmi,
    is_manual_report,
    log_id,
        CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM weight_loginfo) AS duplicate_check)
WHERE rn > 1;


-- Then I alter date column


ALTER TABLE weight_loginfo
ALTER COLUMN date TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END;

-- Check data type in date column

SELECT DISTINCT pg_typeof(date)
FROM weight_loginfo;


-- Now I will format the numeric columns to 2 decimal places.

ALTER TABLE weight_loginfo
ALTER COLUMN weight_kg TYPE NUMERIC(10, 2);

ALTER TABLE weight_loginfo
ALTER COLUMN weight_pounds TYPE NUMERIC(10, 2);

ALTER TABLE weight_loginfo
ALTER COLUMN bmi TYPE NUMERIC(10, 2);


-- Checking if everything is ok

SELECT *
FROM weight_loginfo
WHERE id IS NULL
    OR date IS NULL
    OR weight_kg IS NULL
    OR weight_pounds IS NULL
    OR bmi IS NULL
    OR is_manual_report IS NULL
    OR log_id IS NULL;


SELECT *
FROM weight_loginfo
WHERE fat IS NULL;

-- As only 'fat' column has 'NULL' values and I will use this information later in the analysis, for now I'll leave the column this way.

SELECT *
FROM weight_loginfo;