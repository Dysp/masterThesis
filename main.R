# Load GoogleDrive library to be able to fetch the data
library(googledrive)
library(googlesheets4)
library(tidyverse)

# Only reimport from Google if we want to (if there is new data)
import_question = readline(prompt="Reimport data from Google? Type 'yes'")
if(toupper(import_question) == "YES") { source("import_script.R") }

# WIP: Learning with R for Data Science
#source("learning_r_chapter_3.R")
#source("learning_r_chapter_5.R")

# WIP: Create normal distribution plots for
source("create_normaldistribution_plots.R")

# TODO: Create box plots comparing means between the 4 groups
source("create_boxplots.R")

# TODO: Create script that runs T tests for means of all 3 groups comparable to the control group

########### Below this line is just messing around ########### 

# Find means for all variables for all groups with NA removed

ggplot(data = all_data) + 
  stat_summary(
    mapping = aes(x = Label, y = `Total Cholesterol mmol/L`, color = Label),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median) +
  geom_rug(mapping = aes(y = `Total Cholesterol mmol/L`, color = Label)) + 
  coord_flip()

?geom_rug
(new_all_data <- mutate(all_data, fitness_pr_kg = `ml/min`/ all_data$Weight))
ggplot(data = new_all_data) + geom_boxplot(mapping = aes(y = fitness_pr_kg, color = Label))


(grouped_by_label <- group_by(all_data, Label))
(chol_summary <- summarise(grouped_by_label, 
                          mean_chol = mean(`Total Cholesterol mmol/L`, na.rm = TRUE),
                          sd_chol = sd(`Total Cholesterol mmol/L`, na.rm = TRUE),
                          n_chol = n(),
                          SE_chol = sd(`Total Cholesterol mmol/L`, na.rm = TRUE)/sqrt(n())))

ggplot(data = chol_summary, mapping = aes(x = Label, y = mean_chol, fill = Label)) +
  geom_bar(stat ="identity") +
  geom_errorbar(aes(ymin = mean_chol - SE_chol, ymax = mean_chol + SE_chol), width=0.05)
  
?ylim

(weight_summary <- summarise(grouped_by_label, 
                             mean_weight = mean(Weight, na.rm = TRUE),
                             sd_weight = sd(Weight, na.rm = TRUE),
                             n_weight = n(),
                             SE_weight = sd(Weight, na.rm = TRUE)/sqrt(n())))

weight_plot <- ggplot(data = weight_summary, mapping = aes(x = Label, y = mean_weight, fill = Label)) +
  geom_bar(stat ="identity") +
  geom_errorbar(aes(ymin = mean_weight - sd_weight, ymax = mean_weight + sd_weight), width=0.01, color = "grey") +
  geom_errorbar(aes(ymin = mean_weight - SE_weight, ymax = mean_weight + SE_weight), width=0.05)

  ?geom_bar

sapply(na.omit(control), mean)
sapply(na.omit(myalgia), mean)
sapply(na.omit(high_cholesterol), mean)
sapply(na.omit(non_myalgia), mean)

myalgi_bmi <- na.omit(myalgia$BMI)
control_bmi <- na.omit(control$BMI)

mean_myalgi <- mean(myalgi_bmi)
mean_bmi <- mean(control_bmi)
sd_bmi <- sd(control_bmi)

mean(na.omit(high_cholesterol$`Total Cholesterol mmol/L`))
mean(na.omit(control$`Total Cholesterol mmol/L`))

t.test(control$`Total Cholesterol mmol/L`, high_cholesterol$`Total Cholesterol mmol/L`)
t.test(control$`LDL mmol/L`, high_cholesterol$`LDL mmol/L`)

