/* Creating the first set of tables:		
daily_activity		
heartrate_seconds		
hourly_calories		
hourly_intensities		
hourly_steps		
minute_calories_narrow		
minute_intensities_narrow		
minute_met_narrow		
minute_sleep		
minute_steps_narrow		
weight_loginfo */		
		
CREATE TABLE	daily_activity(	
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
		
CREATE TABLE	heartrate_seconds(	
	id NUMERIC,	
	time VARCHAR,	
	value INTEGER	
);		
		
CREATE TABLE	hourly_calories(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	calories INTEGER	
);	
		
CREATE TABLE	hourly_intensities(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	total_intensity INTEGER,	
	average_intensity NUMERIC	
);		
		
CREATE TABLE	hourly_steps(	
	id NUMERIC,	
	activity_hour VARCHAR,	
	step_total INTEGER	
);		
		
CREATE TABLE	minute_calories_narrow(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	calories NUMERIC	
);		
		
CREATE TABLE	minute_intensities_narrow(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	intensity INTEGER	
);		
		
CREATE TABLE	minute_met_narrow(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	mets INTEGER	
);		
		
CREATE TABLE	minute_sleep(	
	id NUMERIC,	
	date VARCHAR,	
	value INTEGER,	
	log_id NUMERIC	
);		
		
CREATE TABLE	minute_steps_narrow(	
	id NUMERIC,	
	activity_minute VARCHAR,	
	steps INTEGER	
);		
		
		
CREATE TABLE	weight_loginfo(	
	id NUMERIC,	
	date VARCHAR,	
	weight_kg NUMERIC,	
	weight_pounds NUMERIC,	
	fat INTEGER,	
	bmi NUMERIC,	
	is_manual_report VARCHAR,	
	log_id NUMERIC	
);