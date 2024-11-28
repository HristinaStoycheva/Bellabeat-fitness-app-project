-- Insert data into the newly created tables with COPY query		
		
-- Insert data into 'daily_activity' table		
		
COPY	daily_activity(	
	id,	
	activity_date,	
	total_steps	,
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
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\dailyActivity_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'heartrate_seconds'table		
		
COPY	heartrate_seconds(	
	id,	
	time,	
	value	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\heartrate_seconds_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'hourly_calories'table		
		
COPY	hourly_calories(	
	id,	
	activity_hour,	
	calories	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\hourlyCalories_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'hourly_intensities'table		
		
COPY	hourly_intensities(	
	id,	
	activity_hour,	
	total_intensity,	
	average_intensity	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\hourlyIntensities_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'hourly_steps'table		
		
COPY	hourly_steps(	
	id,	
	activity_hour,	
	step_total	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\hourlySteps_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'minute_calories_narrow'table		
		
COPY	minute_calories_narrow(	
	id,	
	activity_minute,	
	calories	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\minuteCaloriesNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'minute_intensities_narrow'table		
		
COPY	minute_intensities_narrow(	
	id,	
	activity_minute,	
	intensity	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\minuteIntensitiesNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_met_narrow'table		
		
COPY	minute_met_narrow(	
	id,	
	activity_minute,	
	mets	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\minuteMETsNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
		
-- Insert data into'minute_sleep'table		
		
COPY	minute_sleep(	
	id,	
	date,	
	value,	
	log_id	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\minuteSleep_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'minute_steps_narrow'table		
		
COPY	minute_steps_narrow(	
	id,	
	activity_minute,	
	steps	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\minuteStepsNarrow_merged.csv'	
DELIMITER ','		
CSV		
HEADER;		
		
-- Insert data into'weight_loginfo'table		
		
COPY	weight_loginfo(	
	id,	
	date,	
	weight_kg,	
	weight_pounds,	
	fat,	
	bmi,	
	is_manual_report,	
	log_id	
)		
FROM	'D:\My docs\Google Data Analysis course\Capstone\CASE STUDY\archive\mturkfitbit_export_3.12.16-4.11.16\Fitabase Data 3.12.16-4.11.16\project_1_bellabeat_datasets\weightLogInfo_merged.csv'	
DELIMITER ','		
CSV		
HEADER;