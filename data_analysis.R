# Load GoogleDrive library to be able to fetch the data
library(googledrive)
library(googlesheets4)
library(glue)

# Fetch the Data spreadsheet from Google sheets by ID
id <-
google_data <- drive_get(id = "1SxL0kpm8xXyslRKradFv03R6Sbr-YUkx09jOVW8RF8E")
sheets <- sheets_get(google_data)

high_cholesterol <- read_sheet(sheets$spreadsheet_id, range="+CHOL, -Statin!A2:AL39")
myalgia <- read_sheet(sheets$spreadsheet_id, range="+Myalgi, +Statin!A2:AL20")
non_myalgia <- read_sheet(sheets$spreadsheet_id, range="-Myalgi, +Statin!A2:AL29")
control <- read_sheet(sheets$spreadsheet_id, range="Kontrol!A2:AL18")

high_cholesterol
myalgia
non_myalgia
control

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
