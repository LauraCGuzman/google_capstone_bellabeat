#libraries
library(tidyverse)
library(ggplot2)
library(lubridate)
library(dplyr)
library(readr)
library(janitor)
library(data.table)
library(tidyr)

#Explore and clean the data
glimpse(dailyActivity_merged.csv)
str(dailyActivity_merged.csv)
colnames(dailyActivity_merged.csv)

colnames(dailyCalories_merged.csv)

#There may be equal data written in dailyCalories and dailyActivity_merged(Id, ActivityDay, Calories)
#Select columns to compare in both datasets
cols_to_compare <- c("Id", "ActivityDate", "Calories")
dailyCalories_subset <- dailyCalories_merged.csv
dailyActivity_merged_subset <- dailyActivity_merged.csv[, cols_to_compare]
dailyActivity_merged_subset <- dailyActivity_merged_subset %>% rename("ActivityDay" = "ActivityDate")
sorted_data_dailyCalories <- arrange(dailyCalories_subset, Id, ActivityDay)
sorted_data_dailyActivity <- arrange(dailyActivity_merged_subset, Id, ActivityDay)

# Verify if all the rows in dailyCalories are in dailyActivity_merged
identical(sorted_data_dailyCalories, sorted_data_dailyActivity) #they are identical

#remove subsets
remove(sorted_data_dailyActivity, sorted_data_dailyCalories, dailyActivity_merged_subset, dailyCalories_subset)
remove(cols_to_compare)

#check if dailyIntensities is inside dailyActivity_merged
anti_join(dailyIntensities_merged.csv, dailyActivity_merged.csv) #all rows are inside dailyActivity_merged

#check if daily Steps is inside dailyActivity_merged
#firstcreate a dataframe with column names equal to the other dataframe
changed_dailySteps <- dailySteps_merged.csv %>% rename(ActivityDate = ActivityDay) %>% rename(TotalSteps = StepTotal)
anti_join(changed_dailySteps, dailyActivity_merged.csv) #all rows inside dailyActivity_merged
remove(changed_dailySteps)

#dailyActivity_merged contains all data from the other daily tables

#is there any repeated Id ActivityDate?
dupla <- duplicated(dailyActivity_merged.csv[, c("Id", "ActivityDate")])
duplicated_values <- dailyActivity_merged.csv[dupla,] #no duplicated values

#Now hourly data will be analyzed.

dupla_hourly_calories <- duplicated(hourlyCalories_merged.csv[, c("Id", "ActivityHour")]) 
duplicated_hourlyCalories <- hourlyCalories_merged.csv[dupla_hourly_calories,] #no duplications
remove(dupla_hourly_calories, duplicated_hourlyCalories)

#check minutes tables and others
dupla_min_cal_narrow <- duplicated(minuteCaloriesNarrow_merged.csv[, c("Id", "ActivityMinute", "Calories")]) 
duplicated_min_cal_narrow <- minuteCaloriesNarrow_merged.csv[dupla_min_cal_narrow,] #non duplicated values
remove(dupla_min_cal_narrow, duplicated_min_cal_narrow)

dupla_min_cal_wide <- duplicated(minuteCaloriesWide_merged.csv[, c("Id", "ActivityHour")]) 
duplicated_min_cal_wide <- minuteCaloriesWide_merged.csv[dupla_min_cal_wide,] #no repeated data
remove(dupla_min_cal_wide, duplicated_min_cal_wide)

dupla_min_int_narrow <- duplicated(minuteIntensitiesNarrow_merged.csv[, c("Id", "ActivityMinute")]) 
duplicated_min_int_narrow <- minuteIntensitiesNarrow_merged.csv[dupla_min_int_narrow,] #no repeated data
remove(dupla_min_int_narrow, duplicated_min_int_narrow)

dupla_min_int_wide <- duplicated(minuteIntensitiesWide[, c("Id", "ActivityHour")]) 
duplicated_min_int_wide <- minuteIntensitiesWide[dupla_min_int_wide,] #no repeated data
remove(duplicated_min_int_wide, dupla_min_int_wide)

dupla_min_mets <- duplicated(minuteMETsNarrow_merged.csv[, c("Id", "ActivityMinute")]) 
duplicated_min_mets <- minuteMETsNarrow_merged.csv[dupla_min_mets,] #no repeated data
remove(dupla_min_mets, duplicated_min_mets)

remove(dupla_columns, dupla_rows, dupla_rows_to_eliminate, duplicated_values)

dupla_sleep <- duplicated(minuteSleep_merged.csv) 
duplicated_sleep <- minuteSleep_merged.csv[dupla_sleep,] #no repeated data
remove(dupla_sleep, duplicated_sleep)

dupla_ssteps <- duplicated(minuteStepsNarrow_merged.csv) 
duplicated_steps <- minuteStepsNarrow_merged.csv[dupla_ssteps,] #no repeated data
remove(dupla_ssteps, duplicated_steps)
