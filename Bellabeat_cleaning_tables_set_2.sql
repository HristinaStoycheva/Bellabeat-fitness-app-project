-- CHECKING AND CLEANING ALL THE 18 TABLES

-- 1. Table daily_activity_2

SELECT *		
FROM daily_activity_2;		
		
SELECT 		
    COUNT (*)		
FROM daily_activity_2;		
		
-- 940 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
SELECT(		
(SELECT COUNT(*)	
FROM daily_activity_2		
WHERE activity_date ~ '^\d{1}/\d{2}/\d{4}') +			
-- 682 rows		
		
(SELECT COUNT(*)		
FROM daily_activity_2		
WHERE activity_date ~ '^\d{1}/\d{1}/\d{4}')		
-- 258 rows	
)	

=

(SELECT 		
    COUNT (*)		
FROM daily_activity_2);


		
-- Now I will convert the date based on the different structures		
-- First I'm checking if it works properly.		
		
SELECT DISTINCT pg_typeof(converted_date)		
FROM (SELECT		
    daily_activity_2,		
    CASE 		
        WHEN activity_date ~ '^\d{1}/\d{2}/\d{4}' THEN 		
            TO_DATE(activity_date, 'MM/DD/YYYY')::DATE		
        WHEN activity_date ~ '^\d{1}/\d{1}/\d{4}' THEN 		
            TO_DATE(activity_date, 'MM/DD/YYYY')::DATE		
        ELSE NULL		
    END AS converted_date		
FROM daily_activity_2);		
		
-- Before column altering I am CHECKING for duplicates	
		
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
FROM daily_activity_2) AS duplicate_check		
WHERE rn > 1;		
		
-- Then I alter activity_date column		
		
		
ALTER TABLE daily_activity_2		
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
FROM daily_activity_2;		
		
-- Then I've checked with the query above if there are duplicates after column altering and the result is still 0.		
		
-- Now I will format the numeric columns to 2 decimal places.		
		
ALTER TABLE daily_activity_2		
ALTER COLUMN total_distance TYPE NUMERIC(10,2);		
		
ALTER TABLE daily_activity_2		
ALTER COLUMN tracker_distance TYPE NUMERIC(10,2);		
		
ALTER TABLE daily_activity_2		
ALTER COLUMN logged_activities_distance TYPE NUMERIC(10,2);		
		
ALTER TABLE daily_activity_2		
ALTER COLUMN very_active_distance TYPE NUMERIC(10,2);		
		
ALTER TABLE daily_activity_2		
ALTER COLUMN moderately_active_distance TYPE NUMERIC(10,2);		
		
ALTER TABLE daily_activity_2		
ALTER COLUMN light_active_distance TYPE NUMERIC(10,2);		
		
ALTER TABLE daily_activity_2		
ALTER COLUMN sedentary_active_distance TYPE NUMERIC(10,2);		
		
-- CHECKING if everything is ok	
		
SELECT *		
FROM daily_activity_2		
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


SELECT *
FROM daily_activity_2;


-- 2. Table heartrate_seconds_2

SELECT *
FROM heartrate_seconds_2;

SELECT 
    COUNT (*)
FROM heartrate_seconds_2;

-- 2483658 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if ALL different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM heartrate_seconds_2
WHERE time ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 1318199 rows

(SELECT COUNT(*)
FROM heartrate_seconds_2
WHERE time ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 436594 rows

(SELECT COUNT(*)
FROM heartrate_seconds_2
WHERE time ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 549001 rows

(SELECT COUNT(*)
FROM heartrate_seconds_2
WHERE time ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 179864 rows
)

=

(SELECT 
    COUNT (*)
FROM heartrate_seconds_2);

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
FROM heartrate_seconds_2) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 , 
because at 3:00 AM there is a time change because of Daylight Saving Time */

SELECT *
FROM heartrate_seconds_2
WHERE time LIKE '3/27/2016%';

-- In this data set this date doesn't exist.
-- Now I'll alter the time column
-- First Check it

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
    FROM heartrate_seconds_2);


-- Before column altering I am CHECKING for duplicates

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
FROM heartrate_seconds_2) AS duplicate_check
WHERE rn > 1;

-- Then I alter time column


ALTER TABLE heartrate_seconds_2
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
FROM heartrate_seconds_2;

-- Then I've checked with the query above if there are duplicates after column altering and the result is still 0.

-- CHECKING if everything is ok

SELECT *
FROM heartrate_seconds_2
WHERE 	id	IS NULL
    OR	time IS NULL	
    OR	value IS NULL;	



SELECT *
FROM heartrate_seconds_2
LIMIT 10;



-- 3. Table hourly_calories_2

SELECT *
FROM hourly_calories_2;

SELECT 
    COUNT (*)
FROM hourly_calories_2;

-- 22099 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if ALL different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM hourly_calories_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 11983 rows

(SELECT COUNT(*)
FROM hourly_calories_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 3988 rows

(SELECT COUNT(*)
FROM hourly_calories_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 4597 rows

(SELECT COUNT(*)
FROM hourly_calories_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 1531 rows
)

=

(SELECT 
    COUNT (*)
FROM hourly_calories_2);

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
FROM hourly_calories_2) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 , 
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour, that's why I will use exact match in WHERE clause*/

SELECT *
FROM hourly_calories_2
WHERE activity_hour = '3/27/2016 3:00:00 AM';

-- No data for this time
-- Checking conversion query

SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_hour,
    CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM hourly_calories_2);


-- Then I alter time column


ALTER TABLE hourly_calories_2
ALTER COLUMN activity_hour TYPE timestamp WITHOUT TIME ZONE
USING CASE 
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
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
FROM hourly_calories_2;

-- Then I'm checking for duplicates after column altering

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
FROM hourly_calories_2) AS duplicate_check
WHERE rn > 1;

-- CHECKING if everything is ok

SELECT *
FROM hourly_calories_2
WHERE 	id	IS NULL
    OR	activity_hour IS NULL	
    OR	calories IS NULL;	



SELECT *
FROM hourly_calories_2
LIMIT 10;


-- 4. Table hourly_intensities_2		
		
SELECT *		
FROM hourly_intensities_2;		
		
SELECT 		
    COUNT (*)		
FROM hourly_intensities_2;		
		
-- 22099 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
-- Check if ALL different types match to the whole number of rows		
		
SELECT(		
(SELECT COUNT(*)		
FROM hourly_intensities_2		
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 11983 rows		
		
(SELECT COUNT(*)		
FROM hourly_intensities_2		
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +		
		
-- 3988 rows		
		
(SELECT COUNT(*)		
FROM hourly_intensities_2		
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 4597 rows		
		
(SELECT COUNT(*)		
FROM hourly_intensities_2		
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')		
		
-- 1531 rows		
)		
		
=		
		
(SELECT 		
    COUNT (*)		
FROM hourly_intensities_2);		
		
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
FROM hourly_intensities_2) AS duplicate_check		
WHERE rn > 1;		
		
/* Now before altering the time column, I have to check are there records for 2016-03-27 , 		
because at 3:00 AM there is a time change because of Daylight Saving Time.		
Here we don't have seconds, only hour, that's why I will use exact match in WHERE clause*/		
		
SELECT *		
FROM hourly_intensities_2		
WHERE activity_hour = '3/27/2016 3:00:00 AM';		
		
-- No data for this time
-- Checking conversion query


SELECT DISTINCT pg_typeof(converted_date)		
FROM(		
SELECT		
    activity_hour,		
    CASE 		
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN	
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	   	
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 		
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN 		
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN 		
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
FROM hourly_intensities_2);		
			
		
-- Then I alter tiactivity_hour me column		
		
		
ALTER TABLE hourly_intensities_2		
ALTER COLUMN activity_hour TYPE timestamp WITHOUT TIME ZONE		
USING CASE 		
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN	
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	   	
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
FROM hourly_intensities_2;		
		
-- Then I'm checking for duplicates

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
FROM hourly_intensities_2) AS duplicate_check		
WHERE rn > 1;	
		
		
-- Now I will format the numeric column to 2 decimal places.		
		
ALTER TABLE hourly_intensities_2		
ALTER COLUMN average_intensity TYPE NUMERIC(10,2);		
		
-- CHECKING if everything is ok		
		
SELECT *		
FROM hourly_intensities_2		
WHERE 	id	IS NULL
    OR activity_hour IS NULL		
    OR	total_intensity IS NULL	
    OR	average_intensity IS NULL;	
		
		
SELECT *		
FROM hourly_intensities_2		
LIMIT 10;		


-- 5. Table hourly_steps_2      		
		
SELECT *		
FROM hourly_steps_2;		
		
SELECT		
 COUNT (*)		
FROM hourly_steps_2;		
		
-- 22099 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
-- Check if ALL different types match to the whole number of rows		
		
SELECT(		
(SELECT COUNT(*)		
FROM hourly_steps_2		
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 11983 rows		
		
(SELECT COUNT(*)		
FROM hourly_steps_2		
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +		
		
-- 3988 rows		
		
(SELECT COUNT(*)		
FROM hourly_steps_2		
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 4597 rows		
		
(SELECT COUNT(*)		
FROM hourly_steps_2		
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')		
		
-- 1531 rows		
)		
		
=		
		
(SELECT		
 COUNT (*)		
FROM hourly_steps_2);		
		
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
FROM hourly_steps_2) AS duplicate_check		
WHERE rn > 1;		
		
/* Now before altering the time column, I have to check are there records for 2016-03-27 ,		
because at 3:00 AM there is a time change because of Daylight Saving Time.		
Here we don't have seconds, only hour, that's why I will use exact match in WHERE clause*/		
		
SELECT *		
FROM hourly_steps_2		
WHERE activity_hour = '3/27/2016 3:00:00 AM';		
		
-- No data for this time
		
SELECT DISTINCT pg_typeof(converted_date)		
FROM(		
SELECT		
    activity_hour,		
    CASE		
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN	
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
FROM hourly_steps_2);		
			
		
-- Then I alter activity_hour column		
		
		
ALTER TABLE hourly_steps_2		
ALTER COLUMN activity_hour TYPE timestamp WITHOUT TIME ZONE		
USING CASE		
        WHEN activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN	
            TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
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
FROM hourly_steps_2;		
		
-- Then I'm checking for duplicates

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
FROM hourly_steps_2) AS duplicate_check		
WHERE rn > 1;

		
-- CHECKING if everything is ok		
		
SELECT *		
FROM hourly_steps_2		
WHERE id IS NULL		
    OR activity_hour IS NULL		
    OR step_total IS NULL;		
            
		
SELECT *		
FROM hourly_steps_2		
LIMIT 10;

-- 6. Table minute_calories_narrow_2      		
		
SELECT *		
FROM minute_calories_narrow_2;		
		
SELECT		
    COUNT (*)		
FROM minute_calories_narrow_2;		
		
-- 1325580 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
-- Check if ALL different types match to the whole number of rows		
		
SELECT(		
(SELECT COUNT(*)		
FROM minute_calories_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 718620 rows		
		
(SELECT COUNT(*)		
FROM minute_calories_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +		
		
-- 239280 rows		
		
(SELECT COUNT(*)		
FROM minute_calories_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 275820 rows		
		
(SELECT COUNT(*)		
FROM minute_calories_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')		
		
-- 91860 rows		
)		
		
=		
		
(SELECT		
    COUNT (*)		
FROM minute_calories_narrow_2);		
		
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
FROM minute_calories_narrow_2) AS duplicate_check		
WHERE rn > 1;		
		
/* Now before altering the time column, I have to check are there records for 2016-03-27 ,		
because at 3:00 AM there is a time change because of Daylight Saving Time.		
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/		
		
SELECT *		
FROM minute_calories_narrow_2		
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';		
		
-- No data for this date		
		
-- Checking the conversion query before column altering		
		
		
SELECT DISTINCT pg_typeof(converted_date)		
FROM(		
SELECT		
    activity_minute,		
    CASE		
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
FROM minute_calories_narrow_2);		
			
				
-- Then I alter activity_minute column		
		
		
ALTER TABLE minute_calories_narrow_2		
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE		
USING CASE		
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
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
FROM minute_calories_narrow_2;		
		
		
-- Now I will format the numeric column to 2 decimal places.		
		
ALTER TABLE minute_calories_narrow_2		
ALTER COLUMN calories TYPE NUMERIC(10,2);		
		
-- CHECKING if everything is ok		
		
SELECT *		
FROM minute_calories_narrow_2		
WHERE id IS NULL		
    OR activity_minute IS NULL		
    OR calories IS NULL;		
		
		
SELECT *		
FROM minute_calories_narrow_2		
LIMIT 10;		

-- 7. Table minute_intensities_narrow_2      		
		
SELECT *		
FROM minute_intensities_narrow_2;		
		
SELECT		
    COUNT (*)		
FROM minute_intensities_narrow_2;		
		
-- 1325580 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
-- Check if all different types match to the whole number of rows		
		
SELECT(		
(SELECT COUNT(*)		
FROM minute_intensities_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 718620 rows		
		
(SELECT COUNT(*)		
FROM minute_intensities_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +		
		
-- 239280 rows		
		
(SELECT COUNT(*)		
FROM minute_intensities_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 275820 rows		
		
(SELECT COUNT(*)		
FROM minute_intensities_narrow_2		
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')		
		
-- 91860 rows		
)		
		
=		
		
(SELECT		
    COUNT (*)		
FROM minute_intensities_narrow_2);		
		
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
FROM minute_intensities_narrow_2) AS duplicate_check		
WHERE rn > 1;		
		
/* Now before altering the time column, I have to check are there records for 2016-03-27 ,		
because at 3:00 AM there is a time change because of Daylight Saving Time.		
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/		
		
SELECT *		
FROM minute_intensities_narrow_2		
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';		
		
-- No data for the date	
			
-- Checking conversion query to before column altering		
		
		
SELECT DISTINCT pg_typeof(converted_date)		
FROM(		
SELECT		
    activity_minute,		
    CASE		
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
FROM minute_intensities_narrow_2);		
		
-- Checking the query for duplicates before column altering		
		
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
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
    FROM minute_intensities_narrow_2) AS duplicate_check)		
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
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
    FROM minute_intensities_narrow_2) AS duplicate_check)		
WHERE rn > 1;		
		
-- Then I alter activity_minute column		
		
		
ALTER TABLE minute_intensities_narrow_2		
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE		
USING CASE		
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
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
FROM minute_intensities_narrow_2;		
		
		
-- CHECKING if everything is ok		
		
SELECT *		
FROM minute_intensities_narrow_2		
WHERE id IS NULL		
    OR activity_minute IS NULL		
    OR intensity IS NULL;		
		
		
SELECT *		
FROM minute_intensities_narrow_2		
LIMIT 10;		

SELECT COUNT(*)		
FROM minute_intensities_narrow_2;	


-- 8. Table minute_met_narrow_2      

SELECT *
FROM minute_met_narrow_2;

SELECT
    COUNT (*)
FROM minute_met_narrow_2;

-- 1325580 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_met_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 718620 rows

(SELECT COUNT(*)
FROM minute_met_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 239080 rows

(SELECT COUNT(*)
FROM minute_met_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 275820 rows

(SELECT COUNT(*)
FROM minute_met_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 91860 rows
)

=

(SELECT
    COUNT (*)
FROM minute_met_narrow_2);

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
FROM minute_met_narrow_2) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_met_narrow_2
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- No data for this date

-- Checking conversion query before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_met_narrow_2);

-- Checking the query for duplicates before column altering

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
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_met_narrow_2) AS duplicate_check)
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
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_met_narrow_2) AS duplicate_check)
WHERE rn > 1;


-- Then I alter activity_minute column


ALTER TABLE minute_met_narrow_2
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
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
FROM minute_met_narrow_2;


-- CHECKING if everything is ok

SELECT *
FROM minute_met_narrow_2
WHERE id IS NULL
    OR activity_minute IS NULL
    OR mets IS NULL;


SELECT *
FROM minute_met_narrow_2
LIMIT 10;

SELECT COUNT(*)
FROM minute_met_narrow_2;


-- 9. Table minute_sleep_2      		
		
SELECT *		
FROM minute_sleep_2;		
		
SELECT		
    COUNT (*)		
FROM minute_sleep_2;		
		
-- 188521 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
-- Check if ALL different types match to the whole number of rows		
		
SELECT(		
(SELECT COUNT(*)		
FROM minute_sleep_2		
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 104971 rows		
		
(SELECT COUNT(*)		
FROM minute_sleep_2		
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +		
		
-- 30196 rows		
		
(SELECT COUNT(*)		
FROM minute_sleep_2		
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 42334 rows		
		
(SELECT COUNT(*)		
FROM minute_sleep_2		
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')		
		
-- 11020 rows		
)		
		
=		
		
(SELECT		
    COUNT (*)		
FROM minute_sleep_2);		
		
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
FROM minute_sleep_2) AS duplicate_check		
WHERE rn > 1;		
		
-- 543 duplicates		
-- I am checking one row of the duplicates to see if its really duplicated record		
		
SELECT *		
FROM minute_sleep_2		
WHERE id = 4702921684		
    AND date = '5/6/2016 10:15:00 PM'		
    AND value = 1		
    AND log_id = 11573168523		
		
-- When I' ve checked the id 4702921684 I came back to check another one, but I noticed that duplicates apper only for this id.		
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
FROM minute_sleep_2		
		
-- The only dulicate rows are for id 4702921684		
		
		
/* Now before altering the time column, I have to check are there records for 2016-03-27 ,		
because at 3:00 AM there is a time change because of Daylight Saving Time.		
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/		
		
SELECT *		
FROM minute_sleep_2		
WHERE date LIKE '%3/27/2016 3:__:__ AM';		
		
-- No data for this date
		
-- Checking conversion query before column altering		
		
		
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
FROM minute_sleep_2);		
		
-- Checking the query for duplicates before column altering		
		
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
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
    FROM minute_sleep_2) AS duplicate_check)		
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
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE	
        WHEN date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(date, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
    FROM minute_sleep_2) AS duplicate_check)		
WHERE rn > 1;	

-- They are still 543 as detected earlier.	
				
-- Then I alter date column		
		
		
ALTER TABLE minute_sleep_2		
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
FROM minute_sleep_2;		
		
-- Now when I have consistent data I'll delete duplicate rows		
		
CREATE TABLE minute_sleep_2_clean AS (		
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
    FROM minute_sleep_2) AS duplicate_check		
WHERE rn = 1);		
		
DROP TABLE minute_sleep_2;		
		
ALTER TABLE minute_sleep_2_clean		
RENAME TO minute_sleep_2;		
		
ALTER TABLE minute_sleep_2		
DROP COLUMN rn;		
		
-- CHECKING if everything is ok		
		
SELECT *		
FROM minute_sleep_2		
WHERE id IS NULL		
    OR date IS NULL		
    OR value IS NULL		
    OR log_id IS NULL;		
		
SELECT *		
FROM minute_sleep_2		
LIMIT 10;	


-- Checking if now we have the right number of rows after we deleted 543 duplicates from the entire 188521 which was before cleaning.
SELECT
(188521 - 543)
=
(SELECT COUNT(*)
FROM minute_sleep_2);


-- 10. Table minute_steps_narrow_2      

SELECT *
FROM minute_steps_narrow_2;

SELECT
    COUNT (*)
FROM minute_steps_narrow_2;

-- 1325580 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_steps_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 718620 rows

(SELECT COUNT(*)
FROM minute_steps_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 239280 rows

(SELECT COUNT(*)
FROM minute_steps_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 275820 rows

(SELECT COUNT(*)
FROM minute_steps_narrow_2
WHERE activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 91860 rows
)

=

(SELECT
    COUNT (*)
FROM minute_steps_narrow_2);

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
FROM minute_steps_narrow_2) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_steps_narrow_2
WHERE activity_minute LIKE '%3/27/2016 3:__:__ AM';

-- No data for this date.

-- Checking conversion query before column altering


SELECT DISTINCT pg_typeof(converted_date)
FROM(
SELECT
    activity_minute,
    CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
FROM minute_steps_narrow_2);

-- Checking the query for duplicates before column altering

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
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_steps_narrow_2) AS duplicate_check)
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
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        WHEN activity_minute ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
        ELSE NULL
    END AS converted_date
    FROM minute_steps_narrow_2) AS duplicate_check)
WHERE rn > 1;


-- Then I alter date column


ALTER TABLE minute_steps_narrow_2
ALTER COLUMN activity_minute TYPE timestamp WITHOUT TIME ZONE
USING CASE
        WHEN activity_minute ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN
            TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE
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
FROM minute_steps_narrow_2;



-- Checking if everything is ok

SELECT *
FROM minute_steps_narrow_2
WHERE id IS NULL
    OR activity_minute IS NULL
    OR steps IS NULL;


SELECT *
FROM minute_steps_narrow_2
LIMIT 10;


SELECT COUNT(*)
FROM minute_steps_narrow_2;



-- 11. Table sleep_day_2      		
		
SELECT *		
FROM sleep_day_2;		
		
SELECT		
    COUNT (*)		
FROM sleep_day_2;		
		
-- 413 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
-- Check if all different types match to the whole number of rows		
-- There are rows for two of the data type formats. And I'll put only them in the equation to check against the total number of rows.	
-- The other two formats I will leave outside the equation.
-- Here are formats without data:

SELECT COUNT(*)		
FROM sleep_day_2		
WHERE sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'	
-- 0 rows

		
SELECT COUNT(*)		
FROM sleep_day_2		
WHERE sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$'	
		
-- 0 rows

-- Here are the rows with data:

SELECT(				
(SELECT COUNT(*)		
FROM sleep_day_2		
WHERE sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +				
-- 296 rows		
				
(SELECT COUNT(*)		
FROM sleep_day_2		
WHERE sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')				
-- 117 rows		
)		
		
=		
		
(SELECT		
    COUNT (*)		
FROM sleep_day_2);		
		
-- Now I'm checking for duplicates		
		
SELECT		
 COUNT(rn)		
FROM (SELECT *,		
 ROW_NUMBER() OVER (PARTITION BY		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed	
 ORDER BY		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed		
 ) AS rn		
FROM sleep_day_2) AS duplicate_check		
WHERE rn > 1;	

-- 3 duplicates
-- I am checking one row of the duplicates to see if its really duplicated record	
	
SELECT *	
FROM sleep_day_2	
WHERE id = 4388161847	
    AND sleep_day = '5/5/2016 12:00:00 AM'	
    AND total_sleep_records = 1	
    AND total_minutes_asleep = 471
    AND total_time_in_bed = 495	
	
-- Yes, there are duplicated rows
-- I will delete them after sleep_day column conversion to date-time in order to ensure data consistency.

		
/* Now before altering the time column, I have to check are there records for 2016-03-27 ,		
because at 3:00 AM there is a time change because of Daylight Saving Time.		
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/		
		
SELECT *		
FROM sleep_day_2		
WHERE sleep_day LIKE '%3/27/2016 3:__:__ AM';		
		
-- No data for this time		
			
-- Now insert the conversion query to check it before column altering		
		
		
SELECT DISTINCT pg_typeof(converted_date)		
FROM(		
SELECT		
    sleep_day,		
    CASE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
FROM sleep_day_2);		
		
-- Checking the query for duplicates before column altering		
		
SELECT		
 sleep_day,		
 converted_date		
FROM (SELECT *,		
 ROW_NUMBER() OVER (PARTITION BY		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed		
 ORDER BY		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed		
 ) AS rn		
FROM (		
    SELECT		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,		
    CASE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
    FROM sleep_day_2) AS duplicate_check)		
WHERE rn > 1;		
		
		
		
SELECT		
 COUNT(rn)		
FROM (SELECT *,		
 ROW_NUMBER() OVER (PARTITION BY		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed		
 ORDER BY		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed		
 ) AS rn		
FROM (		
    SELECT		
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed,		
        CASE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END AS converted_date		
    FROM sleep_day_2) AS duplicate_check)		
WHERE rn > 1;		
		
-- Still 3 duplicates.		
-- Then I alter date column		
		
		
ALTER TABLE sleep_day_2		
ALTER COLUMN sleep_day TYPE timestamp WITHOUT TIME ZONE		
USING CASE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        WHEN sleep_day ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$' THEN		
            TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH24:MI:SS AM,PM')::timestamp WITHOUT TIME ZONE		
        ELSE NULL		
    END;		
		
-- Check data type in date column		
		
SELECT DISTINCT pg_typeof(sleep_day)		
FROM sleep_day_2;		

-- Now when I have consistent data I'll delete duplicate rows

CREATE TABLE sleep_day_2_clean AS (
SELECT
    *
FROM (SELECT *,
    ROW_NUMBER() OVER (PARTITION BY
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed
    ORDER BY
    id,
    sleep_day,
    total_sleep_records,
    total_minutes_asleep,
    total_time_in_bed
    ) AS rn
    FROM sleep_day_2) AS duplicate_check
WHERE rn = 1);

DROP TABLE sleep_day_2;

ALTER TABLE sleep_day_2_clean
RENAME TO sleep_day_2;

ALTER TABLE sleep_day_2
DROP COLUMN rn;
	
				
-- Checking if everything is ok		
		
SELECT *		
FROM sleep_day_2		
WHERE id IS NULL
    OR sleep_day IS NULL
    OR total_sleep_records IS NULL
    OR total_minutes_asleep IS NULL
    OR total_time_in_bed IS NULL;
		
		
SELECT *		
FROM sleep_day_2;	


-- Checking if now we have the right number of rows after we deleted 3 duplicates from the entire 413 which was before cleaning.
SELECT
(413 - 3)
=
(SELECT COUNT(*)
FROM sleep_day_2);


-- Double check
SELECT COUNT(*)
FROM sleep_day_2;



-- 12. Table daily_calories_2

SELECT *        
FROM daily_calories_2;      
       
SELECT      
    COUNT (*)      
FROM daily_calories_2;      
       
-- 940 rows    
       
-- First I will convert activity_day from 'character varying' to date.    
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.      
       
SELECT(    
(SELECT COUNT(*)    
FROM daily_calories_2      
WHERE activity_day ~ '^\d{1}/\d{2}/\d{4}') +          
-- 682 rows    
       
(SELECT COUNT(*)        
FROM daily_calories_2      
WHERE activity_day ~ '^\d{1}/\d{1}/\d{4}')    
-- 258 rows
)  

=

(SELECT        
    COUNT (*)      
FROM daily_calories_2);


       
-- Now I will convert the date based on the different structures        
-- First I'm checking if it works properly.    
       
SELECT DISTINCT pg_typeof(converted_date)      
FROM (SELECT        
    daily_calories_2,      
    CASE        
        WHEN activity_day ~ '^\d{1}/\d{2}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        WHEN activity_day ~ '^\d{1}/\d{1}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        ELSE NULL      
    END AS converted_date      
FROM daily_calories_2);    
       
-- Before column altering I am CHECKING for duplicates  
       
SELECT      
 COUNT(rn)      
FROM (SELECT *,    
 ROW_NUMBER() OVER (PARTITION BY        
    id,
    activity_day,
    calories        
 ORDER BY      
    id,
    activity_day,
    calories        
 ) AS rn        
FROM daily_calories_2) AS duplicate_check      
WHERE rn > 1;      

-- No duplicates      
-- Then I alter activity_day column        
       
       
ALTER TABLE daily_calories_2        
ALTER COLUMN activity_day TYPE date        
USING CASE      
        WHEN activity_day ~ '^\d{1}/\d{2}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        WHEN activity_day ~ '^\d{1}/\d{1}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        ELSE NULL      
    END;        
       
-- Check data type in activity_day column      
       
SELECT DISTINCT pg_typeof(activity_day)        
FROM daily_calories_2;      
       
-- Checking again for duplicates.

SELECT      
 COUNT(rn)      
FROM (SELECT *,    
 ROW_NUMBER() OVER (PARTITION BY        
    id,
    activity_day,
    calories        
 ORDER BY      
    id,
    activity_day,
    calories        
 ) AS rn        
FROM daily_calories_2) AS duplicate_check      
WHERE rn > 1; 

-- No duplicates           
       
-- Checking if everything is ok
       
SELECT *        
FROM daily_calories_2      
WHERE id IS NULL
    OR activity_day IS NULL
    OR calories IS NULL;



SELECT *
FROM daily_calories_2;



-- 13. Table daily_steps_2

SELECT *        
FROM daily_steps_2;      
       
SELECT      
    COUNT (*)      
FROM daily_steps_2;      
       
-- 940 rows    
       
-- First I will convert activity_day from 'character varying' to date.    
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.      
       
SELECT(    
(SELECT COUNT(*)    
FROM daily_steps_2      
WHERE activity_day ~ '^\d{1}/\d{2}/\d{4}') +          
-- 682 rows    
       
(SELECT COUNT(*)        
FROM daily_steps_2      
WHERE activity_day ~ '^\d{1}/\d{1}/\d{4}')    
-- 258 rows
)  

=

(SELECT        
    COUNT (*)      
FROM daily_steps_2);


       
-- Now I will convert the date based on the different structures        
-- First I'm checking if it works properly.    
       
SELECT DISTINCT pg_typeof(converted_date)      
FROM (SELECT        
    activity_day,      
    CASE        
        WHEN activity_day ~ '^\d{1}/\d{2}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        WHEN activity_day ~ '^\d{1}/\d{1}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        ELSE NULL      
    END AS converted_date      
FROM daily_steps_2);    
       
-- Before column altering I am CHECKING for duplicates  
       
SELECT      
 COUNT(rn)      
FROM (SELECT *,    
 ROW_NUMBER() OVER (PARTITION BY        
    id,
    activity_day,
    step_total        
 ORDER BY      
    id,
    activity_day,
    step_total        
 ) AS rn        
FROM daily_steps_2) AS duplicate_check      
WHERE rn > 1;      

-- No duplicates      
-- Then I alter activity_day column        
       
       
ALTER TABLE daily_steps_2        
ALTER COLUMN activity_day TYPE date        
USING CASE      
        WHEN activity_day ~ '^\d{1}/\d{2}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        WHEN activity_day ~ '^\d{1}/\d{1}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        ELSE NULL      
    END;        
       
-- Check data type in activity_day column      
       
SELECT DISTINCT pg_typeof(activity_day)        
FROM daily_steps_2;      
       
-- Checking again for duplicates.

SELECT      
 COUNT(rn)      
FROM (SELECT *,    
 ROW_NUMBER() OVER (PARTITION BY        
    id,
    activity_day,
    step_total        
 ORDER BY      
    id,
    activity_day,
    step_total        
 ) AS rn        
FROM daily_steps_2) AS duplicate_check      
WHERE rn > 1;

-- No duplicates          
       
-- Checking if everything is ok
       
SELECT *        
FROM daily_steps_2      
WHERE id IS NULL
    OR activity_day IS NULL
    OR step_total IS NULL;



SELECT *
FROM daily_steps_2;


-- 14. Table daily_intensities_2

SELECT *        
FROM daily_intensities_2;      
       
SELECT      
    COUNT (*)      
FROM daily_intensities_2;      
       
-- 940 rows    
       
-- First I will convert activity_day from 'character varying' to date.    
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.      
       
SELECT(    
(SELECT COUNT(*)    
FROM daily_intensities_2      
WHERE activity_day ~ '^\d{1}/\d{2}/\d{4}') +          
-- 682 rows    
       
(SELECT COUNT(*)        
FROM daily_intensities_2      
WHERE activity_day ~ '^\d{1}/\d{1}/\d{4}')    
-- 258 rows
)  

=

(SELECT        
    COUNT (*)      
FROM daily_intensities_2);


       
-- Now I will convert the date based on the different structures        
-- First I'm checking if it works properly.    
       
SELECT DISTINCT pg_typeof(converted_date)      
FROM (SELECT        
    activity_day,      
    CASE        
        WHEN activity_day ~ '^\d{1}/\d{2}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        WHEN activity_day ~ '^\d{1}/\d{1}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        ELSE NULL      
    END AS converted_date      
FROM daily_intensities_2);    
       
-- Before column altering I am CHECKING for duplicates  
       
SELECT      
 COUNT(rn)      
FROM (SELECT *,    
 ROW_NUMBER() OVER (PARTITION BY        
    id,
    activity_day,
    sedentary_minutes,
    lightly_active_minutes,
    fairly_active_minutes,
    very_active_minutes,
    sedentary_active_distance,
    light_active_distance,
    moderately_active_distance,
    very_active_distance       
 ORDER BY      
    id,
    activity_day,
    sedentary_minutes,
    lightly_active_minutes,
    fairly_active_minutes,
    very_active_minutes,
    sedentary_active_distance,
    light_active_distance,
    moderately_active_distance,
    very_active_distance       
 ) AS rn        
FROM daily_intensities_2) AS duplicate_check      
WHERE rn > 1;      

-- No duplicates      
-- Then I alter activity_day column        
       
       
ALTER TABLE daily_intensities_2        
ALTER COLUMN activity_day TYPE date        
USING CASE      
        WHEN activity_day ~ '^\d{1}/\d{2}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        WHEN activity_day ~ '^\d{1}/\d{1}/\d{4}' THEN      
            TO_DATE(activity_day, 'MM/DD/YYYY')::DATE      
        ELSE NULL      
    END;        
       
-- Check data type in activity_day column      
       
SELECT DISTINCT pg_typeof(activity_day)        
FROM daily_intensities_2;      
       
-- Checking again for duplicates.

SELECT      
 COUNT(rn)      
FROM (SELECT *,    
 ROW_NUMBER() OVER (PARTITION BY        
    id,
    activity_day,
    sedentary_minutes,
    lightly_active_minutes,
    fairly_active_minutes,
    very_active_minutes,
    sedentary_active_distance,
    light_active_distance,
    moderately_active_distance,
    very_active_distance        
 ORDER BY      
    id,
    activity_day,
    sedentary_minutes,
    lightly_active_minutes,
    fairly_active_minutes,
    very_active_minutes,
    sedentary_active_distance,
    light_active_distance,
    moderately_active_distance,
    very_active_distance         
 ) AS rn        
FROM daily_intensities_2) AS duplicate_check      
WHERE rn > 1;

-- No duplicates  

--Format numerics to 2 decimal places

ALTER TABLE daily_intensities_2
ALTER COLUMN very_active_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_intensities_2
ALTER COLUMN moderately_active_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_intensities_2
ALTER COLUMN light_active_distance TYPE NUMERIC(10,2);

ALTER TABLE daily_intensities_2
ALTER COLUMN sedentary_active_distance TYPE NUMERIC(10,2);

       
-- Checking if everything is ok
       
SELECT *        
FROM daily_intensities_2      
WHERE id IS NULL
    OR activity_day IS NULL
    OR sedentary_minutes IS NULL
    OR lightly_active_minutes IS NULL
    OR fairly_active_minutes IS NULL
    OR very_active_minutes IS NULL
    OR sedentary_active_distance IS NULL
    OR light_active_distance IS NULL
    OR moderately_active_distance IS NULL
    OR very_active_distance IS NULL;




SELECT *
FROM daily_intensities_2;



-- 15. Table weight_log_info_2      		
		
SELECT *		
FROM weight_log_info_2;		
		
SELECT		
    COUNT (*)		
FROM weight_log_info_2;		
		
-- 67 rows		
		
-- First I will convert activity_date from 'character varying' to date.		
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.		
		
-- Check if ALL different types match to the whole number of rows		
		
SELECT(		
(SELECT COUNT(*)		
FROM weight_log_info_2		
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 20 rows		
		
(SELECT COUNT(*)		
FROM weight_log_info_2		
WHERE date ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +		
		
-- 26 rows		
		
(SELECT COUNT(*)		
FROM weight_log_info_2		
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +		
		
-- 6 rows		
		
(SELECT COUNT(*)		
FROM weight_log_info_2		
WHERE date ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')		
		
-- 15 rows		
)		
		
=		
		
(SELECT		
    COUNT (*)		
FROM weight_log_info_2);		
		
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
FROM weight_log_info_2) AS duplicate_check		
WHERE rn > 1;		
		
/* Now before altering the time column, I have to check are there records for 2016-03-27 ,		
because at 3:00 AM there is a time change because of Daylight Saving Time.		
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/		
		
SELECT *		
FROM weight_log_info_2		
WHERE date LIKE '%3/27/2016 3:__:__ AM';		
		
-- No data for this time	
		
		
-- Now Insert the conversion query to check it before column altering		
		
		
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
FROM weight_log_info_2);		
		
-- Checking the query for duplicates Before column altering		
		
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
    FROM weight_log_info_2) AS duplicate_check)		
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
    FROM weight_log_info_2) AS duplicate_check)		
WHERE rn > 1;		
		
		
-- Then I alter date column		
		
		
ALTER TABLE weight_log_info_2		
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
FROM weight_log_info_2;		
		
		
-- Now I will format the numeric columns to 2 decimal places.		
		
ALTER TABLE weight_log_info_2		
ALTER COLUMN weight_kg TYPE NUMERIC(10, 2);		
		
ALTER TABLE weight_log_info_2		
ALTER COLUMN weight_pounds TYPE NUMERIC(10, 2);		
		
ALTER TABLE weight_log_info_2		
ALTER COLUMN bmi TYPE NUMERIC(10, 2);		
		
		
-- CHECKING if everything is ok		
		
SELECT *		
FROM weight_log_info_2		
WHERE id IS NULL		
    OR date IS NULL		
    OR weight_kg IS NULL		
    OR weight_pounds IS NULL		
    OR bmi IS NULL		
    OR is_manual_report IS NULL		
    OR log_id IS NULL;		
		
		
SELECT *		
FROM weight_log_info_2		
WHERE fat IS NULL;		
		
-- As only 'fat' column has 'NULL' values and I will use this information later in the analysis, for now I'll leave the column this way.		
		
SELECT *		
FROM weight_log_info_2;		



-- In a separate sql file I'll perform cleaning process for the rest 3 tables in 2nd set of data tables.