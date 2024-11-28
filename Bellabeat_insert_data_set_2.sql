-- Import data into the tables	
		
-- Insert data into'daily_activity_2'table		
		
COPY	daily_activity_2(	
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
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\dailyActivity_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'daily_calories_2'table		
		
COPY	daily_calories_2(	
	id,	
	activity_day,	
	calories	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\dailyCalories_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'daily_intensities_2'table		
		
COPY	daily_intensities_2(	
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
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\dailyIntensities_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'daily_steps_2'table		
		
COPY	daily_steps_2(	
	id,	
	activity_day,	
	step_total	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\dailySteps_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'heartrate_seconds_2'table		
		
COPY heartrate_seconds_2(		
	id,	
	time,	
	value	
)		
FROM 'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\heartrate_seconds_merged.csv'		
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'hourly_calories_2'table		
		
COPY hourly_calories_2(		
	id,	
	activity_hour,	
	calories	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\hourlyCalories_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'hourly_intensities_2'table		
		
COPY hourly_intensities_2(		
	id,	
	activity_hour,	
	total_intensity,	
	average_intensity	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\hourlyIntensities_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'hourly_steps_2'table		
		
COPY hourly_steps_2(		
	id,	
	activity_hour,	
	step_total	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\hourlySteps_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_calories_narrow_2'table		
		
COPY minute_calories_narrow_2(		
	id,	
	activity_minute,	
	calories	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteCaloriesNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_calories_wide_2'table		
		
COPY minute_calories_wide_2(		
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
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteCaloriesWide_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_intensities_narrow_2'table		
		
COPY minute_intensities_narrow_2(		
	id,	
	activity_minute,	
	intensity	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteIntensitiesNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_intensities_wide_2'table		
		
COPY minute_intensities_wide_2(		
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
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteIntensitiesWide_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'minute_met_narrow_2'table		
		
COPY minute_met_narrow_2(		
	id,	
	activity_minute,	
	mets	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteMETsNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_sleep_2'table		
		
COPY minute_sleep_2(		
	id,	
	date,	
	value,	
	log_id	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteSleep_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_steps_narrow_2'table		
		
COPY minute_steps_narrow_2(		
	id,	
	activity_minute,	
	steps	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteStepsNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'minute_steps_wide_2'table		
		
COPY	minute_steps_wide_2(	
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
)		
FROM 'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\minuteStepsWide_merged.csv'		
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'sleep_day_2'table		
		
COPY sleep_day_2(		
	id,	
	sleep_day,	
	total_sleep_records,	
	total_minutes_asleep,	
	total_time_in_bed	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\sleepDay_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'weight_log_info_2'table		
		
COPY weight_log_info_2(		
	id,	
	date,	
	weight_kg,	
	weight_pounds,	
	fat,	
	bmi,	
	is_manual_report,	
	log_id	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets_2\weightLogInfo_merged.csv'	
DELIMITER ','		
CSV		
HEADER;	