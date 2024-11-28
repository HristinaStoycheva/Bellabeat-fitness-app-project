
/* 1. I will unite the 2 main tables which contain daily data for each id.
   2. Then I will unite and transform the other tables so that they 
   will match time formatting of the main tables in order to join them appropriately. */


-- Uniting main tables

CREATE TABLE daily_activity_all AS
(SELECT * FROM daily_activity)
UNION
(SELECT * FROM daily_activity_2);

SELECT *
FROM daily_activity_all;

-- CHECKING for duplicates

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
FROM daily_activity_all) AS duplicate_check
WHERE rn > 1;

-- No duplicates

-- All the following tables I will aggregate in a way to fit the measurement per day as it is in the main table above.


-- 2. Heartrate tables	

SELECT *
FROM heartrate_seconds
LIMIT 10;


-- I will aggregate them by average heart rate per day.
		
CREATE TABLE daily_heartrate_avg AS (		
	SELECT 	
	 	id,
		time::date AS calculated_date,
		AVG(value):: NUMERIC(10,2) AS average_heartrate
	FROM heartrate_seconds	
	WHERE value IS NOT NULL AND value > 0	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	)	
UNION (		
	SELECT 	
		id,
		time::date AS calculated_date,
		AVG(value):: NUMERIC(10,2) AS average_heartrate
	FROM heartrate_seconds_2	
	WHERE value IS NOT NULL AND value > 0	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	);	

		
SELECT *		
FROM daily_heartrate_avg		
ORDER BY id, calculated_date DESC;		

-- Check for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    average_heartrate
 ORDER BY
    id,
    calculated_date,
    average_heartrate
 ) AS rn
FROM daily_heartrate_avg) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_heartrate_avg;

-- No duplicates

-- 3. hourly_intensities tables	


-- First I make an observation based on one is to decide how to aggregate
SELECT 
    id,
    activity_hour::date AS calculated_date,
    SUM(total_intensity):: NUMERIC(10,0) AS total,
    AVG(total_intensity):: NUMERIC(10,2) AS avg_intensity
FROM hourly_intensities
WHERE id = 7007744171
GROUP BY id, calculated_date	
ORDER BY id, calculated_date;

-- Then I create the new table
		
CREATE TABLE daily_intensity_aggregated AS (		
    SELECT 
        id,
        activity_hour::date AS calculated_date,
        SUM(total_intensity):: NUMERIC(10,0) AS sum_intensity,
        AVG(total_intensity):: NUMERIC(10,2) AS avg_intensity
    FROM hourly_intensities
    GROUP BY id, calculated_date	
    ORDER BY id, calculated_date	
	)	
UNION (		
    SELECT 
        id,
        activity_hour::date AS calculated_date,
        SUM(total_intensity):: NUMERIC(10,0) AS sum_intensity,
        AVG(total_intensity):: NUMERIC(10,2) AS avg_intensity
    FROM hourly_intensities_2
    GROUP BY id, calculated_date	
    ORDER BY id, calculated_date	
	);	
		


SELECT *		
FROM daily_intensity_aggregated		
ORDER BY id, calculated_date DESC;		


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    sum_intensity,
    avg_intensity
 ORDER BY
    id,
    calculated_date,
    sum_intensity,
    avg_intensity
 ) AS rn
FROM daily_intensity_aggregated) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_intensity_aggregated;

-- No duplicates


-- 4. hourly_steps tables			

SELECT *
FROM hourly_steps;			
			
CREATE TABLE daily_steps_aggregated AS (			
	SELECT 		
	 	id,	
		activity_hour::date AS calculated_date,	
		SUM(step_total):: NUMERIC(10,0) AS sum_steps	
	FROM hourly_steps		
	GROUP BY id, calculated_date		
	ORDER BY id, calculated_date		
	)		
UNION (			
	SELECT 		
		id,	
		activity_hour::date AS calculated_date,	
		SUM(step_total):: NUMERIC(10,0) AS sum_steps	
	FROM hourly_steps_2		
	GROUP BY id, calculated_date		
	ORDER BY id, calculated_date		
	);		

			
SELECT *			
FROM daily_steps_aggregated			
ORDER BY id, calculated_date DESC;	


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    sum_steps
 ORDER BY
    id,
    calculated_date,
    sum_steps
 ) AS rn
FROM daily_steps_aggregated) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_steps_aggregated;

-- No duplicates


-- 5. minute_calories_narrow tables				

SELECT *
FROM minute_calories_narrow;


				
CREATE TABLE daily_calories_m_aggregared AS (				
	SELECT 			
	 	id,		
		activity_minute::date AS calculated_date,		
		SUM(calories):: NUMERIC(10,2) AS sum_calories_m		
	FROM minute_calories_narrow			
	GROUP BY id, calculated_date			
	ORDER BY id, calculated_date			
	)			
UNION (				
	SELECT 			
		id,		
		activity_minute::date AS calculated_date,		
		SUM(calories):: NUMERIC(10,2) AS sum_calories_m		
	FROM minute_calories_narrow_2			
	GROUP BY id, calculated_date			
	ORDER BY id, calculated_date			
	);			
				
				
SELECT *				
FROM daily_calories_m_aggregared				
ORDER BY id, calculated_date DESC;	


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    sum_calories_m
 ORDER BY
    id,
    calculated_date,
    sum_calories_m
 ) AS rn
FROM daily_calories_m_aggregared) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_calories_m_aggregared;

-- No duplicates


-- 6. minute_intensities_narrow tables	


			
CREATE TABLE daily_intensity_m_aggregared AS (			
	SELECT 		
	 	id,	
		activity_minute::date AS calculated_date,
        SUM(intensity):: NUMERIC(10,0) AS sum_intensity_m,	
		AVG(intensity):: NUMERIC(10,2) AS avg_intensity_m	
	FROM minute_intensities_narrow				
	GROUP BY id, calculated_date		
	ORDER BY id, calculated_date		
	)		
UNION (			
	SELECT 		
	 	id,	
		activity_minute::date AS calculated_date,
        SUM(intensity):: NUMERIC(10,0) AS sum_intensity_m,	
		AVG(intensity):: NUMERIC(10,2) AS avg_intensity_m	
	FROM minute_intensities_narrow_2				
	GROUP BY id, calculated_date		
	ORDER BY id, calculated_date		
	);		
			
			
SELECT *			
FROM daily_intensity_m_aggregared			
ORDER BY id, calculated_date DESC;	



-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    sum_intensity_m,
    avg_intensity_m
 ORDER BY
    id,
    calculated_date,
    sum_intensity_m,
    avg_intensity_m
 ) AS rn
FROM daily_intensity_m_aggregared) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_intensity_m_aggregared;

-- No duplicates



-- 7. minute_met_narrow tables		

SELECT *
FROM minute_met_narrow;

		
CREATE TABLE daily_mets_m_aggregared AS (		
	SELECT 	
	 	id,
		activity_minute::date AS calculated_date,
		AVG(mets):: NUMERIC(10, 2) AS avg_mets_m
	FROM minute_met_narrow	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	)	
UNION (		
	SELECT 	
	 	id,
		activity_minute::date AS calculated_date,
		AVG(mets):: NUMERIC(10, 2) AS avg_mets_m
	FROM minute_met_narrow_2	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	);	
		
		
SELECT *		
FROM daily_mets_m_aggregared		
ORDER BY id, calculated_date DESC;	


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    avg_mets_m
 ORDER BY
    id,
    calculated_date,
    avg_mets_m
 ) AS rn
FROM daily_mets_m_aggregared) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_mets_m_aggregared;

-- No duplicates




-- 8. minute_sleep tables	

SELECT *
FROM minute_sleep;


/* Here I will calculate value column as average because as we have 3 values - 1, 2 and 3 		
I suppose that here is measured sleep stage, not minutes. */		
		
CREATE TABLE daily_sleep_m_aggregared AS (		
	SELECT 	
	 	id,
		date::date AS calculated_date,
		AVG(value):: NUMERIC(10, 2) AS avg_sleep_m,
        log_id
	FROM minute_sleep	
	GROUP BY id, calculated_date, log_id	
	ORDER BY id, calculated_date, log_id	
	)	
UNION (		
	SELECT 	
	 	id,
		date::date AS calculated_date,
		AVG(value):: NUMERIC(10, 2) AS avg_sleep_m,
        log_id
	FROM minute_sleep_2	
	GROUP BY id, calculated_date, log_id	
	ORDER BY id, calculated_date, log_id	
	);	
		
		
SELECT *		
FROM daily_sleep_m_aggregared		
ORDER BY id, calculated_date DESC;		


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    avg_sleep_m,
    log_id
 ORDER BY
    id,
    calculated_date,
    avg_sleep_m,
    log_id
 ) AS rn
FROM daily_sleep_m_aggregared) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_sleep_m_aggregared;

-- No duplicates
-- I'll change the name of the column log_id because I'll need to keep the column in the final joined table where this column name has a duplicate in another column

ALTER TABLE daily_sleep_m_aggregared
RENAME COLUMN log_id TO log_id_sleep;

-- 9. minute_steps_narrow tables		

SELECT *
FROM minute_steps_narrow;	

		
CREATE TABLE daily_steps_m_aggregared AS (		
	SELECT 	
	 	id,
		activity_minute::date AS calculated_date,
		SUM(steps):: NUMERIC(10,0) AS sum_steps_m
	FROM minute_steps_narrow	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	)	
UNION (		
	SELECT 	
	 	id,
		activity_minute::date AS calculated_date,
		SUM(steps):: NUMERIC(10,0) AS sum_steps_m
	FROM minute_steps_narrow_2	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	);	
		
		
SELECT *		
FROM daily_steps_m_aggregared		
ORDER BY id, calculated_date DESC;		


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    sum_steps_m
 ORDER BY
    id,
    calculated_date,
    sum_steps_m
 ) AS rn
FROM daily_steps_m_aggregared) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_steps_m_aggregared;

-- No duplicates



-- 10. weight_loginfo tables	

SELECT *
FROM weight_loginfo;
		
		
CREATE TABLE weight_loginfo_all AS (		
	SELECT 	
	 	id,
		date::date AS calculated_date,
		AVG(weight_kg):: NUMERIC(10,2) AS avg_weight_kg,
		AVG(weight_pounds):: NUMERIC(10,2) AS avg_weight_pounds,
		AVG(bmi):: NUMERIC(10,2) AS avg_bmi,
        fat,
        is_manual_report,
        log_id
	FROM weight_loginfo		
	GROUP BY id, calculated_date, log_id, is_manual_report, fat	
	ORDER BY id, calculated_date	
	)	
UNION (		
	SELECT 	
	 	id,
		date::date AS calculated_date,
		AVG(weight_kg):: NUMERIC(10,2) AS avg_weight_kg,
		AVG(weight_pounds):: NUMERIC(10,2) AS avg_weight_pounds,
		AVG(bmi):: NUMERIC(10,2) AS avg_bmi,
        fat,
        is_manual_report,
        log_id
	FROM weight_log_info_2
	GROUP BY id, calculated_date, log_id, is_manual_report, fat	
	ORDER BY id, calculated_date	
	);	
		
		
SELECT *		
FROM weight_loginfo_all		
ORDER BY id, calculated_date DESC;		


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
 ORDER BY
    id,
    calculated_date,
    avg_weight_kg,
    avg_weight_pounds,
    avg_bmi,
    fat,
    is_manual_report,
    log_id
 ) AS rn
FROM weight_loginfo_all) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM weight_loginfo_all;


-- 11. Hourly calories tables	

SELECT *
FROM hourly_calories;


		
CREATE TABLE daily_calories_aggregated AS (		
	SELECT 	
	 	id,
		activity_hour::date AS calculated_date,
		SUM(calories):: NUMERIC(10,0) AS calories_daily
	FROM hourly_calories	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	)	
UNION (		
	SELECT 	
		id,
		activity_hour::date AS calculated_date,
		SUM(calories):: NUMERIC(10,0) AS calories_daily
	FROM hourly_calories_2	
	GROUP BY id, calculated_date	
	ORDER BY id, calculated_date	
	);	
		
		
SELECT *		
FROM daily_calories_aggregated		
ORDER BY id, calculated_date DESC;		


-- Checking for duplicates


SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    calories_daily
 ORDER BY
    id,
    calculated_date,
    calories_daily
 ) AS rn
FROM daily_calories_aggregated) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM daily_calories_aggregated;

-- No duplicates


-- Checking the rest of the tables where the data is in only one table and don't need uniting.
/* Tables:
    daily_calories_2
    daily_intensities_2
    daily_steps_2
    sleep_day_2 */



SELECT *
FROM daily_calories_2;

SELECT *
FROM daily_intensities_2;

SELECT *
FROM daily_steps_2;

SELECT *
FROM sleep_day_2;

-- I'll only rename columns which diplicated the ones in the daily_activity_all table because in the next step I'll join tables.

ALTER TABLE daily_calories_2
RENAME COLUMN calories TO calories_2;


ALTER TABLE daily_intensities_2
RENAME COLUMN sedentary_minutes TO sedentary_minutes_2;

ALTER TABLE daily_intensities_2
RENAME COLUMN lightly_active_minutes TO lightly_active_minutes_2;

ALTER TABLE daily_intensities_2
RENAME COLUMN fairly_active_minutes TO fairly_active_minutes_2;

ALTER TABLE daily_intensities_2
RENAME COLUMN very_active_minutes TO very_active_minutes_2;

ALTER TABLE daily_intensities_2
RENAME COLUMN sedentary_active_distance TO sedentary_active_distance_2;

ALTER TABLE daily_intensities_2
RENAME COLUMN light_active_distance TO light_active_distance_2;

ALTER TABLE daily_intensities_2
RENAME COLUMN moderately_active_distance TO moderately_active_distance_2;

ALTER TABLE daily_intensities_2
RENAME COLUMN very_active_distance TO very_active_distance_2;


ALTER TABLE daily_steps_2
RENAME COLUMN step_total TO step_total_2;



-- They are ready for join

/* Now the last 3 tables:
    minute_calories_summed_to_hour
    minute_intensity_summed_to_hour
    minute_steps_summed_to_hour */

SELECT *
FROM minute_calories_summed_to_hour;

SELECT *
FROM minute_intensity_summed_to_hour;

SELECT *
FROM minute_steps_summed_to_hour;

-- They have an equal number of rows, so I will aggregate them to day and I will join them in one table.

CREATE TABLE calories_intensity_steps_w_joined AS (
SELECT 
    calories_w.*,
    intensity_w.daily_intensity_sum_w,
    intensity_w.daily_intensity_avg_w,
    steps_w.daily_steps_sum_w
FROM 
    (SELECT 
        id,
        activity_hour::date AS calculated_date,
        SUM(calories_per_hour)::NUMERIC(10,2) AS daily_calories_sum_w
    FROM minute_calories_summed_to_hour
    GROUP BY id, calculated_date) AS calories_w
JOIN 
    (SELECT
        id,
        activity_hour::date AS calculated_date,
        SUM(intensity_per_hour)::NUMERIC(10,0) AS daily_intensity_sum_w,
        AVG(intensity_per_hour)::NUMERIC(10,2) AS daily_intensity_avg_w
    FROM minute_intensity_summed_to_hour
    GROUP BY id, calculated_date) AS intensity_w 
ON calories_w.id = intensity_w.id 
AND calories_w.calculated_date = intensity_w.calculated_date
JOIN 
    (SELECT
        id,
        activity_hour::date AS calculated_date,
        SUM(steps_per_hour)::NUMERIC(10,0) AS daily_steps_sum_w
    FROM minute_steps_summed_to_hour
    GROUP BY id, calculated_date) AS steps_w 
ON calories_w.id = steps_w.id 
AND calories_w.calculated_date = steps_w.calculated_date
);


-- Checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    calculated_date,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w
 ORDER BY
    id,
    calculated_date,
    daily_calories_sum_w,
    daily_intensity_sum_w,
    daily_intensity_avg_w,
    daily_steps_sum_w
 ) AS rn
FROM calories_intensity_steps_w_joined) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM calories_intensity_steps_w_joined;

-- No duplicates

