/*Cleaning and organizing tables:

minute_calories_wide_2
minute_intensities_wide_2
minute_steps_wide_2

I perform it separately because of the different structure of the data sets */


-- 1. Table minute_calories_wide_2

SELECT *
FROM minute_calories_wide_2;

SELECT
    COUNT (*)
FROM minute_calories_wide_2;

-- 21645 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if ALL different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_calories_wide_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 11657 rows

(SELECT COUNT(*)
FROM minute_calories_wide_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 3860 rows

(SELECT COUNT(*)
FROM minute_calories_wide_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 4597 rows

(SELECT COUNT(*)
FROM minute_calories_wide_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 1531 rows
)

=

(SELECT
    COUNT (*)
FROM minute_calories_wide_2);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ORDER BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ) AS rn
FROM minute_calories_wide_2) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_calories_wide_2
WHERE activity_hour LIKE '%3/27/2016 3:__:__ AM';

-- No data for this time

-- Now insert the conversion query to check it before column altering


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
FROM minute_calories_wide_2);

-- CHECKING the query for duplicates Before column altering

SELECT
 activity_hour,
 converted_activity_hour
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ORDER BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ) AS rn
FROM (
    SELECT
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59,
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
    END AS converted_activity_hour
    FROM minute_calories_wide_2) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ORDER BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ) AS rn
FROM (
    SELECT
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59,
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
    END AS converted_activity_hour
    FROM minute_calories_wide_2) AS duplicate_check)
WHERE rn > 1;

-- Then I alter activity_hour column

ALTER TABLE minute_calories_wide_2		
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

 
-- Checking for duplicates again

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ORDER BY
    id,
    activity_hour,
    calories00,
    calories01,
    calories02,
    calories03,
    calories04,
    calories05,
    calories06,
    calories07,
    calories08,
    calories09,
    calories10,
    calories11,
    calories12,
    calories13,
    calories14,
    calories15,
    calories16,
    calories17,
    calories18,
    calories19,
    calories20,
    calories21,
    calories22,
    calories23,
    calories24,
    calories25,
    calories26,
    calories27,
    calories28,
    calories29,
    calories30,
    calories31,
    calories32,
    calories33,
    calories34,
    calories35,
    calories36,
    calories37,
    calories38,
    calories39,
    calories40,
    calories41,
    calories42,
    calories43,
    calories44,
    calories45,
    calories46,
    calories47,
    calories48,
    calories49,
    calories50,
    calories51,
    calories52,
    calories53,
    calories54,
    calories55,
    calories56,
    calories57,
    calories58,
    calories59
 ) AS rn
FROM minute_calories_wide_2) AS duplicate_check
WHERE rn > 1;

-- No duplicates

-- Check data type in date column

SELECT DISTINCT pg_typeof(activity_hour)
FROM minute_calories_wide_2;

SELECT COUNT(*)
FROM minute_calories_wide_2;

-- Create a table with more useful aggregation for the analysis
/* each column from 0 to 59 contains information about how many calories were burned in that exact minute. 
Since the analysis will not use minute-based information, 
I will sum the columns for each hour and each id. */

SELECT *
FROM minute_calories_wide_2
LIMIT 10;

CREATE TABLE minute_calories_summed_to_hour AS
SELECT
    id,
    activity_hour,
    SUM(
        calories00 +
        calories01 +
        calories02 +
        calories03 +
        calories04 +
        calories05 +
        calories06 +
        calories07 +
        calories08 +
        calories09 +
        calories10 +
        calories11 +
        calories12 +
        calories13 +
        calories14 +
        calories15 +
        calories16 +
        calories17 +
        calories18 +
        calories19 +
        calories20 +
        calories21 +
        calories22 +
        calories23 +
        calories24 +
        calories25 +
        calories26 +
        calories27 +
        calories28 +
        calories29 +
        calories30 +
        calories31 +
        calories32 +
        calories33 +
        calories34 +
        calories35 +
        calories36 +
        calories37 +
        calories38 +
        calories39 +
        calories40 +
        calories41 +
        calories42 +
        calories43 +
        calories44 +
        calories45 +
        calories46 +
        calories47 +
        calories48 +
        calories49 +
        calories50 +
        calories51 +
        calories52 +
        calories53 +
        calories54 +
        calories55 +
        calories56 +
        calories57 +
        calories58 +
        calories59
        )::NUMERIC(10,2) AS calories_per_hour
FROM minute_calories_wide_2
GROUP BY id, activity_hour;

-- Checking new table

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    calories_per_hour
 ORDER BY
    id,
    activity_hour,
    calories_per_hour
 ) AS rn
FROM minute_calories_summed_to_hour) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM minute_calories_summed_to_hour;

SELECT *
FROM minute_calories_summed_to_hour
WHERE id IS NULL
    OR activity_hour IS NULL
    OR calories_per_hour IS NULL;




-- 2. Table minute_steps_wide_2

SELECT *
FROM minute_steps_wide_2;

SELECT
    COUNT (*)
FROM minute_steps_wide_2;

-- 21645 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if all different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_steps_wide_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 11657 rows

(SELECT COUNT(*)
FROM minute_steps_wide_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 3860 rows

(SELECT COUNT(*)
FROM minute_steps_wide_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 4597 rows

(SELECT COUNT(*)
FROM minute_steps_wide_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 1531 rows
)

=

(SELECT
    COUNT (*)
FROM minute_steps_wide_2);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ORDER BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ) AS rn
FROM minute_steps_wide_2) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_steps_wide_2
WHERE activity_hour LIKE '%3/27/2016 3:__:__ AM';

-- No data for this time

-- Now insert the conversion query to check it before column altering


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
FROM minute_steps_wide_2);

-- CHECKING the query for duplicates Before column altering

SELECT
 activity_hour,
 converted_activity_hour
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ORDER BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ) AS rn
FROM (
    SELECT
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59,
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
    END AS converted_activity_hour
    FROM minute_steps_wide_2) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ORDER BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ) AS rn
FROM (
    SELECT
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59,
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
    END AS converted_activity_hour
    FROM minute_steps_wide_2) AS duplicate_check)
WHERE rn > 1;

-- Then I alter activity_hour column

ALTER TABLE minute_steps_wide_2      
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

 
-- Checking for duplicates again

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ORDER BY
    id,
    activity_hour,
    steps00,
    steps01,
    steps02,
    steps03,
    steps04,
    steps05,
    steps06,
    steps07,
    steps08,
    steps09,
    steps10,
    steps11,
    steps12,
    steps13,
    steps14,
    steps15,
    steps16,
    steps17,
    steps18,
    steps19,
    steps20,
    steps21,
    steps22,
    steps23,
    steps24,
    steps25,
    steps26,
    steps27,
    steps28,
    steps29,
    steps30,
    steps31,
    steps32,
    steps33,
    steps34,
    steps35,
    steps36,
    steps37,
    steps38,
    steps39,
    steps40,
    steps41,
    steps42,
    steps43,
    steps44,
    steps45,
    steps46,
    steps47,
    steps48,
    steps49,
    steps50,
    steps51,
    steps52,
    steps53,
    steps54,
    steps55,
    steps56,
    steps57,
    steps58,
    steps59
 ) AS rn
FROM minute_steps_wide_2) AS duplicate_check
WHERE rn > 1;

-- No duplicates

-- Check data type in date column

SELECT DISTINCT pg_typeof(activity_hour)
FROM minute_steps_wide_2;

SELECT COUNT(*)
FROM minute_steps_wide_2;

-- Create a table with more useful aggregation for the analysis
/* each column from 0 to 59 contains information about how many steps were burned in that exact minute.
Since the analysis will not use minute-based information,
I will sum the columns for each hour and each id. */

SELECT *
FROM minute_steps_wide_2
LIMIT 10;

CREATE TABLE minute_steps_summed_to_hour AS
SELECT
    id,
    activity_hour,
    SUM(
        steps00 +
        steps01 +
        steps02 +
        steps03 +
        steps04 +
        steps05 +
        steps06 +
        steps07 +
        steps08 +
        steps09 +
        steps10 +
        steps11 +
        steps12 +
        steps13 +
        steps14 +
        steps15 +
        steps16 +
        steps17 +
        steps18 +
        steps19 +
        steps20 +
        steps21 +
        steps22 +
        steps23 +
        steps24 +
        steps25 +
        steps26 +
        steps27 +
        steps28 +
        steps29 +
        steps30 +
        steps31 +
        steps32 +
        steps33 +
        steps34 +
        steps35 +
        steps36 +
        steps37 +
        steps38 +
        steps39 +
        steps40 +
        steps41 +
        steps42 +
        steps43 +
        steps44 +
        steps45 +
        steps46 +
        steps47 +
        steps48 +
        steps49 +
        steps50 +
        steps51 +
        steps52 +
        steps53 +
        steps54 +
        steps55 +
        steps56 +
        steps57 +
        steps58 +
        steps59
        )::NUMERIC(10,2) AS steps_per_hour
FROM minute_steps_wide_2
GROUP BY id, activity_hour;

-- Checking new table

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    steps_per_hour
 ORDER BY
    id,
    activity_hour,
    steps_per_hour
 ) AS rn
FROM minute_steps_summed_to_hour) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM minute_steps_summed_to_hour;

SELECT *
FROM minute_steps_summed_to_hour
WHERE id IS NULL
    OR activity_hour IS NULL
    OR steps_per_hour IS NULL;




-- 3. Table minute_intensities_wide_2

SELECT *
FROM minute_intensities_wide_2;

SELECT
    COUNT (*)
FROM minute_intensities_wide_2;

-- 21645 rows

-- First I will convert activity_date from 'character varying' to date.
-- As I can see that there are different structures of date in the 'character varying' string, I will first idetify them.

-- Check if ALL different types match to the whole number of rows

SELECT(
(SELECT COUNT(*)
FROM minute_intensities_wide_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 11657 rows

(SELECT COUNT(*)
FROM minute_intensities_wide_2
WHERE activity_hour ~ '^\d{1}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$') +

-- 3860 rows

(SELECT COUNT(*)
FROM minute_intensities_wide_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{1}:\d{2}:\d{2} [AP]M$') +

-- 4597 rows

(SELECT COUNT(*)
FROM minute_intensities_wide_2
WHERE activity_hour ~ '^\d{1}/\d{1}/\d{4} \d{2}:\d{2}:\d{2} [AP]M$')

-- 1531 rows
)

=

(SELECT
    COUNT (*)
FROM minute_intensities_wide_2);

-- Now I'm checking for duplicates

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ORDER BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ) AS rn
FROM minute_intensities_wide_2) AS duplicate_check
WHERE rn > 1;

/* Now before altering the time column, I have to check are there records for 2016-03-27 ,
because at 3:00 AM there is a time change because of Daylight Saving Time.
Here we don't have seconds, only hour and minutes, that's why I will use LIKE match in WHERE clause*/

SELECT *
FROM minute_intensities_wide_2
WHERE activity_hour LIKE '%3/27/2016 3:__:__ AM';

-- No data for this time

-- Now insert the conversion query to check it before column altering


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
FROM minute_intensities_wide_2);

-- CHECKING the query for duplicates Before column altering

SELECT
 activity_hour,
 converted_activity_hour
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ORDER BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ) AS rn
FROM (
    SELECT
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59,
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
    END AS converted_activity_hour
    FROM minute_intensities_wide_2) AS duplicate_check)
WHERE rn > 1;



SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ORDER BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ) AS rn
FROM (
    SELECT
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59,
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
    END AS converted_activity_hour
    FROM minute_intensities_wide_2) AS duplicate_check)
WHERE rn > 1;

-- Then I alter activity_hour column

ALTER TABLE minute_intensities_wide_2      
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

 
-- Checking for duplicates again

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ORDER BY
    id,
    activity_hour,
    intensity00,
    intensity01,
    intensity02,
    intensity03,
    intensity04,
    intensity05,
    intensity06,
    intensity07,
    intensity08,
    intensity09,
    intensity10,
    intensity11,
    intensity12,
    intensity13,
    intensity14,
    intensity15,
    intensity16,
    intensity17,
    intensity18,
    intensity19,
    intensity20,
    intensity21,
    intensity22,
    intensity23,
    intensity24,
    intensity25,
    intensity26,
    intensity27,
    intensity28,
    intensity29,
    intensity30,
    intensity31,
    intensity32,
    intensity33,
    intensity34,
    intensity35,
    intensity36,
    intensity37,
    intensity38,
    intensity39,
    intensity40,
    intensity41,
    intensity42,
    intensity43,
    intensity44,
    intensity45,
    intensity46,
    intensity47,
    intensity48,
    intensity49,
    intensity50,
    intensity51,
    intensity52,
    intensity53,
    intensity54,
    intensity55,
    intensity56,
    intensity57,
    intensity58,
    intensity59
 ) AS rn
FROM minute_intensities_wide_2) AS duplicate_check
WHERE rn > 1;

-- No duplicates

-- Check data type in date column

SELECT DISTINCT pg_typeof(activity_hour)
FROM minute_intensities_wide_2;

SELECT COUNT(*)
FROM minute_intensities_wide_2;

-- Create a table with more useful aggregation for the analysis
/* each column from 0 to 59 contains information about how many intensity were burned in that exact minute.
Since the analysis will not use minute-based information,
I will sum the columns for each hour and each id. */


SELECT *
FROM minute_intensities_wide_2
LIMIT 10;

CREATE TABLE minute_intensity_summed_to_hour AS
SELECT
    id,
    activity_hour,
    SUM(
        intensity00 +
        intensity01 +
        intensity02 +
        intensity03 +
        intensity04 +
        intensity05 +
        intensity06 +
        intensity07 +
        intensity08 +
        intensity09 +
        intensity10 +
        intensity11 +
        intensity12 +
        intensity13 +
        intensity14 +
        intensity15 +
        intensity16 +
        intensity17 +
        intensity18 +
        intensity19 +
        intensity20 +
        intensity21 +
        intensity22 +
        intensity23 +
        intensity24 +
        intensity25 +
        intensity26 +
        intensity27 +
        intensity28 +
        intensity29 +
        intensity30 +
        intensity31 +
        intensity32 +
        intensity33 +
        intensity34 +
        intensity35 +
        intensity36 +
        intensity37 +
        intensity38 +
        intensity39 +
        intensity40 +
        intensity41 +
        intensity42 +
        intensity43 +
        intensity44 +
        intensity45 +
        intensity46 +
        intensity47 +
        intensity48 +
        intensity49 +
        intensity50 +
        intensity51 +
        intensity52 +
        intensity53 +
        intensity54 +
        intensity55 +
        intensity56 +
        intensity57 +
        intensity58 +
        intensity59
        )::NUMERIC(10,2) AS intensity_per_hour
FROM minute_intensities_wide_2
GROUP BY id, activity_hour;

-- Checking new table

SELECT
 COUNT(rn)
FROM (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY
    id,
    activity_hour,
    intensity_per_hour
 ORDER BY
    id,
    activity_hour,
    intensity_per_hour
 ) AS rn
FROM minute_intensity_summed_to_hour) AS duplicate_check
WHERE rn > 1;


SELECT *
FROM minute_intensity_summed_to_hour;


SELECT *
FROM minute_intensity_summed_to_hour
WHERE id IS NULL
    OR activity_hour IS NULL
    OR intensity_per_hour IS NULL;

