/* Creating the second set of tables:
daily_activity_2
daily_calories_2
daily_intensities_2
daily_steps_2
heartrate_seconds_2
hourly_calories_2
hourly_intensities_2
hourly_steps_2
minute_calories_narrow_2
minute_calories_wide_2
minute_intensities_narrow_2
minute_intensities_wide_2
minute_met_narrow_2
minute_sleep_2
minute_steps_narrow_2
minute_steps_wide_2
sleep_day_2
weight_log_info_2 */

CREATE TABLE	daily_activity_2(	
	id NUMERIC,	
	activity_date VARCHAR,	
	total_steps INTEGER,	
	total_distance NUMERIC,	
	tracker_distance NUMERIC,	
	logged_activities_distance NUMERIC,	
	very_active_distance NUMERIC,	
	moderately_active_distance NUMERIC,	
	light_active_distance NUMERIC,	
	sedentary_active_distance NUMERIC,	
	very_active_minutes INTEGER,	
	fairly_active_minutes INTEGER,	
	lightly_active_minutes INTEGER,	
	sedentary_minutes INTEGER,	
	calories INTEGER	
);	
		
CREATE TABLE	daily_calories_2(	
	id NUMERIC,	
	activity_day VARCHAR,	
	calories INTEGER	
);		
		
CREATE TABLE	daily_intensities_2(	
	id NUMERIC,	
	activity_day VARCHAR,	
	sedentary_minutes INTEGER,	
	lightly_active_minutes INTEGER,	
	fairly_active_minutes INTEGER,	
	very_active_minutes INTEGER,	
	sedentary_active_distance NUMERIC,	
	light_active_distance NUMERIC,	
	moderately_active_distance NUMERIC,	
	very_active_distance NUMERIC	
);
		
CREATE TABLE	daily_steps_2(	
	id NUMERIC,	
	activity_day VARCHAR,	
	step_total INTEGER	
);		
		
CREATE TABLE	heartrate_seconds_2(	
	id NUMERIC,	
	time VARCHAR,	
	value INTEGER	
);		
		
CREATE TABLE	hourly_calories_2(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	calories INTEGER	
);		
		
CREATE TABLE	hourly_intensities_2(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	total_intensity INTEGER,	
	average_intensity NUMERIC	
);		
		
CREATE TABLE	hourly_steps_2(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	step_total INTEGER	
);		
		
CREATE TABLE	minute_calories_narrow_2(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	calories NUMERIC	
);		
		
CREATE TABLE	minute_calories_wide_2(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	calories00 NUMERIC,	
	calories01 NUMERIC,	
	calories02 NUMERIC,	
	calories03 NUMERIC,	
	calories04 NUMERIC,	
	calories05 NUMERIC,	
	calories06 NUMERIC,	
	calories07 NUMERIC,	
	calories08 NUMERIC,	
	calories09 NUMERIC,	
	calories10 NUMERIC,	
	calories11 NUMERIC,	
	calories12 NUMERIC,	
	calories13 NUMERIC,	
	calories14 NUMERIC,	
	calories15 NUMERIC,	
	calories16 NUMERIC,	
	calories17 NUMERIC,	
	calories18 NUMERIC,	
	calories19 NUMERIC,	
	calories20 NUMERIC,	
	calories21 NUMERIC,	
	calories22 NUMERIC,	
	calories23 NUMERIC,	
	calories24 NUMERIC,	
	calories25 NUMERIC,	
	calories26 NUMERIC,	
	calories27 NUMERIC,	
	calories28 NUMERIC,	
	calories29 NUMERIC,	
	calories30 NUMERIC,	
	calories31 NUMERIC,	
	calories32 NUMERIC,	
	calories33 NUMERIC,	
	calories34 NUMERIC,	
	calories35 NUMERIC,	
	calories36 NUMERIC,	
	calories37 NUMERIC,	
	calories38 NUMERIC,	
	calories39 NUMERIC,	
	calories40 NUMERIC,	
	calories41 NUMERIC,	
	calories42 NUMERIC,	
	calories43 NUMERIC,	
	calories44 NUMERIC,	
	calories45 NUMERIC,	
	calories46 NUMERIC,	
	calories47 NUMERIC,	
	calories48 NUMERIC,	
	calories49 NUMERIC,	
	calories50 NUMERIC,	
	calories51 NUMERIC,	
	calories52 NUMERIC,	
	calories53 NUMERIC,	
	calories54 NUMERIC,	
	calories55 NUMERIC,	
	calories56 NUMERIC,	
	calories57 NUMERIC,	
	calories58 NUMERIC,	
	calories59 NUMERIC	
);		
		
CREATE TABLE	minute_intensities_narrow_2(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	intensity INTEGER	
);		
		
CREATE TABLE	minute_intensities_wide_2(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	intensity00 INTEGER,	
	intensity01 INTEGER,	
	intensity02 INTEGER,	
	intensity03 INTEGER,	
	intensity04 INTEGER,	
	intensity05 INTEGER,	
	intensity06 INTEGER,	
	intensity07 INTEGER,	
	intensity08 INTEGER,	
	intensity09 INTEGER,	
	intensity10 INTEGER,	
	intensity11 INTEGER,	
	intensity12 INTEGER,	
	intensity13 INTEGER,	
	intensity14 INTEGER,	
	intensity15 INTEGER,	
	intensity16 INTEGER,	
	intensity17 INTEGER,	
	intensity18 INTEGER,	
	intensity19 INTEGER,	
	intensity20 INTEGER,	
	intensity21 INTEGER,	
	intensity22 INTEGER,	
	intensity23 INTEGER,	
	intensity24 INTEGER,	
	intensity25 INTEGER,	
	intensity26 INTEGER,	
	intensity27 INTEGER,	
	intensity28 INTEGER,	
	intensity29 INTEGER,	
	intensity30 INTEGER,	
	intensity31 INTEGER,	
	intensity32 INTEGER,	
	intensity33 INTEGER,	
	intensity34 INTEGER,	
	intensity35 INTEGER,	
	intensity36 INTEGER,	
	intensity37 INTEGER,	
	intensity38 INTEGER,	
	intensity39 INTEGER,	
	intensity40 INTEGER,	
	intensity41 INTEGER,	
	intensity42 INTEGER,	
	intensity43 INTEGER,	
	intensity44 INTEGER,	
	intensity45 INTEGER,	
	intensity46 INTEGER,	
	intensity47 INTEGER,	
	intensity48 INTEGER,	
	intensity49 INTEGER,	
	intensity50 INTEGER,	
	intensity51 INTEGER,	
	intensity52 INTEGER,	
	intensity53 INTEGER,	
	intensity54 INTEGER,	
	intensity55 INTEGER,	
	intensity56 INTEGER,	
	intensity57 INTEGER,	
	intensity58 INTEGER,	
	intensity59 INTEGER	
);		
		
CREATE TABLE	minute_met_narrow_2(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	mets INTEGER	
);		
		
CREATE TABLE	minute_sleep_2(	
	id NUMERIC,	
	date VARCHAR,	
	value INTEGER,	
	log_id NUMERIC	
);		
		
CREATE TABLE	minute_steps_narrow_2(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	steps INTEGER	
);		
		
CREATE TABLE	minute_steps_wide_2(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	steps00 INTEGER,	
	steps01 INTEGER,	
	steps02 INTEGER,	
	steps03 INTEGER,	
	steps04 INTEGER,	
	steps05 INTEGER,	
	steps06 INTEGER,	
	steps07 INTEGER,	
	steps08 INTEGER,	
	steps09 INTEGER,	
	steps10 INTEGER,	
	steps11 INTEGER,	
	steps12 INTEGER,	
	steps13 INTEGER,	
	steps14 INTEGER,	
	steps15 INTEGER,	
	steps16 INTEGER,	
	steps17 INTEGER,	
	steps18 INTEGER,	
	steps19 INTEGER,	
	steps20 INTEGER,	
	steps21 INTEGER,	
	steps22 INTEGER,	
	steps23 INTEGER,	
	steps24 INTEGER,	
	steps25 INTEGER,	
	steps26 INTEGER,	
	steps27 INTEGER,	
	steps28 INTEGER,	
	steps29 INTEGER,	
	steps30 INTEGER,	
	steps31 INTEGER,	
	steps32 INTEGER,	
	steps33 INTEGER,	
	steps34 INTEGER,	
	steps35 INTEGER,	
	steps36 INTEGER,	
	steps37 INTEGER,	
	steps38 INTEGER,	
	steps39 INTEGER,	
	steps40 INTEGER,	
	steps41 INTEGER,	
	steps42 INTEGER,	
	steps43 INTEGER,	
	steps44 INTEGER,	
	steps45 INTEGER,	
	steps46 INTEGER,	
	steps47 INTEGER,	
	steps48 INTEGER,	
	steps49 INTEGER,	
	steps50 INTEGER,	
	steps51 INTEGER,	
	steps52 INTEGER,	
	steps53 INTEGER,	
	steps54 INTEGER,	
	steps55 INTEGER,	
	steps56 INTEGER,	
	steps57 INTEGER,	
	steps58 INTEGER,	
	steps59 INTEGER	
);		
		
CREATE TABLE	sleep_day_2(	
	id NUMERIC,	
	sleep_day VARCHAR,	
	total_sleep_records INTEGER,	
	total_minutes_asleep INTEGER,	
	total_time_in_bed INTEGER	
);		
		
CREATE TABLE	weight_log_info_2(	
	id NUMERIC,	
	date VARCHAR,	
	weight_kg NUMERIC,	
	weight_pounds NUMERIC,	
	fat INTEGER,	
	bmi NUMERIC,	
	is_manual_report VARCHAR,	
	log_id NUMERIC	
);		
		
		
