# Load GoogleDrive library to be able to fetch the data
library(googledrive)
library(googlesheets4)
library(glue)

# Only reimport from Google if we want to
import <- readline(prompt="Reimport data from Google? Type 'yes'")
if(toupper(import) == "YES") { source("import_script.R") }

source("create_normaldistribution_plots.R")

# Find means for all variables for all groups with NA removed
sapply(na.omit(control), mean)
sapply(na.omit(myalgia), mean)
sapply(na.omit(high_cholesterol), mean)
sapply(na.omit(non_myalgia), mean)

myalgi_bmi <- na.omit(myalgia$BMI)
control_bmi <- na.omit(control$BMI)

mean_myalgi <- mean(myalgi_bmi)
mean_bmi <- mean(control_bmi)
sd_bmi <- sd(control_bmi)

glue("Mean BMI for control is {round(mean_bmi, 2)} (±{round(sd_bmi,2)})")

mean(na.omit(high_cholesterol$`Total Cholesterol mmol/L`))
mean(na.omit(control$`Total Cholesterol mmol/L`))

t.test(control$`Total Cholesterol mmol/L`, high_cholesterol$`Total Cholesterol mmol/L`)
t.test(control$`LDL mmol/L`, high_cholesterol$`LDL mmol/L`)

