--- 
Author: Hristina Stoycheva
Last updated: November 28, 2024
---


## BELLABEAT PROJECT

The project I am presenting is a case study I worked on in connection with the course I completed - **Google Data Analytics Professional Certificate** course.

**Case study description:**
Bellabeat is a high-tech manufacturer of health-focused products for women, and meet different characters and team members.
The company manufactures health-focused smart products.
As a Junior data analyst my task is to discover a successful marketing strategy for the company as meeting the following objectives:
* Insights into how consumers use smart devices in general.
* Presenting marketing strategy recommendations for the Bellabeat app based on analytics insights.

## Step 1 
### Prepare for the analysis

* Data source: public data that explores smart device users’ daily habits, published on Kaggle (CC0: Public Domain, dataset made available through Mobius) - [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) .
  
* Data description: The data set contains personal fitness tracker from thirty five fitbit users. Thirty five eligible Fitbit users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits.
  
* Data organization: 29 csv. files separated in 2 sets:
  * First set of 11 csv. files for the period from 2016-03-12 to 2016-04-11;
  * Seecond set of 18 csv. files for the period from 2016-04-12 to 2016-05-12.

* Data license - public domain.

* Problems with the data:
  * too short period of time - only two months;
  * too small sample group - only 35 users;
  * information scattered across many tables;
  * incorrect data formatting.
 
## Step 2
### Process with the data

* To explore data types and columns
  * Software used: **R**.
    * I imported all the .csv files in R, beacause for this step I find R more visualy pleasant (personal opinion) and it's easy for me to struture next steps based on this observations.
    * I used str() function to find out data types and column names for all files.
    * Then I copied and pasted all this information in a so called by me "help spreadsheet file" .
    * I extracted file name, column names and data type in order to be ready to concatenate them in the right order when I create my queries for CREATE TABLE in **Postgresql** .

* To upload all data files
  * Software used: **Postgresql**
    * First I uploaded all the files from the first folder - "mturkfitbit_export_3.12.16-4.11.16". I copied and pasted all the file paths to my "help file".
    * I created tables in Postgresql for each dataset table from downloaded data which is 11 csv. files.
    * To ease the process I always have on hand the "help file" where I created simple CONCATENATE function (*with some not so simple conditions*) to create all the repeated queries and then I just copied and pasted them in Postgresql. I've already had all the information from R about data type , column names and file names. And from Postgresql I took the information about the file paths, so now I just concatenate all this in spreadsheets and then copy and paste it in Postgersql.
    * After I finished with table creations for the first data set, I continued with the second one which is 18 csv. files in folder "mturkfitbit_export_4.12.16-5.12.16". But here when I created table names I just added a "_2" at the end of each name in order to uploaded them right and to have a clear observation when I process with data.
   
* Data cleaning in **Postgresql**
  * First of all, right at the beginning I saw that the column that contains date or date and time information is formatted as 'character varying'. My experience in working with data, even if only in spreadsheets, was extremely useful here, and thanks to it, I started looking for potential problems right from the start.
    * First I had to identify different text structures that any of the dates contain and based on that to structure my conversion queries.
    * Then I discovered that this time period in which the data was collected also contains the date and time of the time change -Daylight saving time, which is at 3:00 AM on March 27, 2016. So I had to handle this issue together with the data type formatting.
    * After I had done everything necessary to format the date and time, I continued with formatting the other columns of numeric data where necessary.
    * At this stage, when the data in the individual columns already had consistent formatting, I checked for duplicates and deleted if any.
    * I didn't remove NULL values because I will use NULL values information for the analysis.
    * All the above processes you can find in details, with comments and the whole checking procedure in the .sql files attached.

* Creating a complete dataset from all 29 csv files from the both raw data datasets **Postgresql**
  * As I've explored each of the newly created tables, I found that files with same names have also columns with same name and input. Based on this I united each couple of data tables.
  *  In order to combine all data from all tables I got for a main one table where there is aggregated data by day.
  *  Then I created aggregated data for each of the other measures from the other tables. I made convertion and aggregation in one query.
  *  When I created all the aggregated tables, I JOINed them  with FULL OUTER JOIN to create a comprehensive dataset without risking losing any data in the process.
  *  At this stage there are lots of NULL values which will be more effectively managed in spreadsheets, so I continued the process in spreadsheets.
  *  All the above processes you can find in details, with comments and the whole checking procedure in the .sql files attached.

* In **spreadsheets** (**Excel** *to be punctual*)
  * Rearanged columns to group them by the same measurements, but taken from different tables, so that in the next step I can unite them by groups by calculating the average value. This way I provide more comprehensive information for the analysis.
  * For each of the groups I calculated average measured amount. For the columns with unique measurement, there are no changes.
  * Then I removed all duplicates based on both criteria id and activity date together. And I found the average for each measurement, merged by the above condition.
  * After that I calculated average amounts for each measurement by id and by date.
  * Then I counted the measurements used by id and by date.
  * And I made some additional calculations for smaller datasets to highlight my insights.

## Step 3
### Analyzing data
  * When my calculations were complete, I analyzed the results, found trends, and came to conclusions that showed me a pattern in the use of different measurements across users, both calculated per ID and across the entire group by date of entry.

## Step 4
### Sharing my findings
  * I created graphs in Excel to show my findings.
  * Then I made a presentation to tell the story to the stakeholders.
    * All graphs, presentation theme and conditional formatting are color-coordinated with the color scheme of Bellabeat's website.
   
* I'm working on visualizations in Tableau Public as well.

*You can find all the described steps in the attached files.*

