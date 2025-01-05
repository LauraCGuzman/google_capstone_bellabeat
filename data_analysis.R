#libraries
library(tidyverse)
library(ggplot2)
library(lubridate)
library(dplyr)
library(readr)
library(janitor)
library(data.table)
library(tidyr)

numberofusers <- unique(dailyActivity_merged.csv["Id"]) #there are 33 users
numberofdays <- unique(dailyActivity_merged.csv["ActivityDate"]) #there are 31 days

#weight analysis
unique(weightLogInfo_merged.csv["Id"]) #from 33 users, only 8 registered weight.

weightLogInfo_merged.csv$Id_label <- paste0("User_", substr(weightLogInfo_merged.csv$Id, 2, 5))  #Create new labels

weightLogInfo_merged.csv$Id_label <- as.factor(weightLogInfo_merged.csv$Id_label)

weightLogInfo_merged.csv$Date <- mdy_hms(weightLogInfo_merged.csv$Date)
weightLogInfo_merged.csv$Date_only <- date(weightLogInfo_merged.csv$Date)


ggplot(data = weightLogInfo_merged.csv, aes(x = Date_only, y = BMI, group = Id_label, color = Id_label)) +
  geom_line() +
  geom_point() +
  geom_hline(yintercept = c(19, 25), linetype = "dashed", linewidth=1,  color = "gray") + 
  labs(x = "Date", y = "BMI", color = "User") +
  ggtitle("BMI evolution per user")

ggsave("BMI_evolution_per_user.png") 

#only 2 users registered weight regularly, 4 did it occasionally, 2 just once
# devices should encourage register the weight more often. Maybe allow connection with smart scales.
# stablishing a weight objective may be usefull to achieve/maintain
# Only BMI is incomplete, % of body fat could be another measurement. But you will need another device.

weightLogInfo_merged.csv %>% group_by(Id_label) %>% count()
#only 8 users registered weight. 

#sleep analysis
sleepDay_merged.csv$Id_label <- paste0("User_", substr(sleepDay_merged.csv$Id, 2, 5))  #Create new labels

sleepDay_merged.csv$Id_label <- as.factor(sleepDay_merged.csv$Id_label)

sleepDay_merged.csv$Date_only <- as.Date(sleepDay_merged.csv$SleepDay, format = "%m/%d/%Y %I:%M:%S %p")

ggplot(data = sleepDay_merged.csv, aes(x = Date_only, y = TotalTimeInBed, group = Id_label, color = Id_label)) +
  geom_line() +
  geom_point() +
  geom_hline(yintercept = 420, linetype = "dashed", linewidth=1,  color = "gray") + 
  labs(x = "Date", y = "minutes in bed", color = "User") +
  ggtitle("Time in bed")

ggplot(data = sleepDay_merged.csv %>%
         group_by(Id_label) %>%
         count(),
       aes(x = Id_label, y = n)) +
  geom_bar(stat = "identity") +
  labs(x = "User (Id_label)",
       y = "Number of records",
       title = "Number of records per user") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Why do we have 9 users with less than 12 records? Are the devices failing?
ggsave("Number_of_recods_sleep_per_user.png") 

#Daily activity
dailyActivity_merged.csv$Id_label <- paste0("User_", substr(dailyActivity_merged.csv$Id, 2, 5))  #Create new labels

dailyActivity_merged.csv$Id_label <- as.factor(dailyActivity_merged.csv$Id_label)

ggplot(data = dailyActivity_merged.csv, aes( x = TotalSteps, y = Calories)) + 
  geom_point()+
  geom_smooth()+
  labs(title ="Total Steps vs. Calories")
ggsave("Total_steps_calories.png") 


ggplot(data = dailyActivity_merged.csv, aes( x = VeryActiveDistance, y = Calories)) + 
  geom_point()+
  geom_smooth()+
  labs(title ="Very active distance vs. Calories")
ggsave("Total_distance_calories.png") 

