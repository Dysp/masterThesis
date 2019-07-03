# Load GoogleDrive library to be able to fetch the data
library(googledrive)
library(googlesheets4)
# Use Tidyverse to include ggplot, dplyr etc
library(tidyverse)
# Import data from Google Sheets
source("import_script.R")
# Import own helper functions
source("functions.R")
# Data can now be found in the variable allData
allData
# Include custom scripts for making plots
source("plotting_scripts.R")

# WIP: Learning with R for Data Science
# Don't load these; just use them for reference for now
#source("learning_r_chapter_3.R")
#source("learning_r_chapter_5.R")

grouped_data <- allData %>%
  group_by(Label)

grouped_data

control_group <- filter(grouped_data, Label == "Control")
myst_group <- filter(grouped_data, Label == "Myalgia, Statins")
st_group <- filter(grouped_data, Label == "Statins")
hc_group <- filter(grouped_data, Label == "High cholesterol")

our_results <- tibble(attribute = character(), myst_p_value = numeric(), st_p_value = numeric(), hc_p_value = numeric())
for (name in names(grouped_data) ) {
  if(is.numeric(grouped_data[[name]])) {
    print(name)
    myst_vector <- myst_group[[name]]
    st_vector <- st_group[[name]]
    hc_vector <- hc_group[[name]]
    control_vector <- control_group[[name]]
    
    if(!all(is.na(control_vector))) {
      myst_t_test <- t.test(myst_vector, control_vector, na.action = na.omit)
      st_t_test <- t.test(st_vector, control_vector, na.action = na.omit)
      hc_t_test <- t.test(hc_vector, control_vector, na.action = na.omit)
      
      our_results <- our_results %>%
        add_row(attribute = str_interp("${name}"), myst_p_value = myst_t_test$p.value, st_p_value = st_t_test$p.value, hc_p_value = hc_t_test$p.value)
    }
  }
}

our_results




t_test2 <- t.test(age_st, age_control)
our_results <- our_results %>%
  add_row(attribute = "age_st", p_value = t_test2$p.value)
our_results







# <rickyrick> I'd try allData %>% group_by(Label) %>% summarize_if(is.numeric, functions) or something
allData %>%
  group_by(Label) %>%
  summarize_if(is.numeric, mean, na.rm = TRUE)

for (variableName in names(allData)) {
  if (is.numeric(allData[[variableName]])) {
    print(str_interp("Running for '${variableName}'"))
    sumData <- allData %>%
      group_by(Label) %>%
      select(allData[[variableName]]) %>%
      summarise(
        variableName = mean(allData[[variableName]], na.rm = TRUE),
        variableName_sd = sd(allData[[variableName]], na.rm = TRUE),
        variableName_se = se(allData[[variableName]], na.rm = TRUE))
    print(sumData)
    createMeanBarPlot(sumData, variableName) 
  }
}

sumData <- allData %>%
            group_by(Label) %>%
            select(Age) %>%
            summarise(
              age = mean(Age, na.rm = TRUE),
              age_sd = sd(Age, na.rm = TRUE),
              age_se = se(Age, na.rm = TRUE))

createMeanBarPlot(sumData, variable_name = "age")


# Hardcoding: Group by label, calculate means and summarise
anthropometricMeans <- allData %>%
  group_by(Label) %>%
  summarise(age = mean(Age, na.rm=TRUE),
            bmi = mean(BMI, na.rm=TRUE),
            sys = mean(Sys, na.rm=TRUE),
            dia = mean(Dia, na.rm=TRUE),
            heartRate = mean(HR, na.rm=TRUE),
            hip = mean(Hip, na.rm=TRUE),
            waist = mean(Waist, na.rm=TRUE),
            rightThigh = mean(`Right thigh`, na.rm = TRUE),
            leftThigh = mean(`Left thigh`, na.rm = TRUE),
            leanBodyMass = mean(LBM, na.rm = TRUE),
            fatPercentage = mean(`Fat tissue percentage`, na.rm = TRUE)
  )

# Iterate over all columns and create bar plots for each grouped by label.

for (anthroVariable in names(anthropometricMeans)) {
  createMeanBarPlot(data_input = anthropometricMeans, variable_name = anthroVariable)
}

