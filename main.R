# Load GoogleDrive library to be able to fetch the data
library(googledrive)
library(googlesheets4)
# Use Tidyverse to include ggplot, dplyr etc
library(tidyverse)
# Import data from Google Sheets
source("import_script.R")
# Include custom scripts for making plots
source("plotting_scripts.R")

# WIP: Learning with R for Data Science
# Don't load these; just use them for reference for now
#source("learning_r_chapter_3.R")
#source("learning_r_chapter_5.R")
allData

grouped_by_label <- group_by(dataFrame, Label)

summary <- summarise(grouped_by_label, 
                     mean_chol = mean(`Total Cholesterol mmol/L`, na.rm = TRUE),
                     sd_chol = sd(`Total Cholesterol mmol/L`, na.rm = TRUE),
                     n_chol = n(),
                     SE_chol = sd(`Total Cholesterol mmol/L`, na.rm = TRUE)/sqrt(n()))


ggplot(data = summary, mapping = aes(x = Label, y = mean_chol, fill = Label)) +
  geom_bar(stat ="identity") +
  geom_errorbar(aes(ymin = mean_chol - SE_chol, ymax = mean_chol + SE_chol), width=0.05)


# TODO: Create script that runs T tests for means of all 3 groups comparable to the control group

########### Below this line is just messing around ########### 

# Find means for all variables for all groups with NA removed
ggplot(data = data) + 
  stat_summary(
    mapping = aes(x = Label, y = `Total Cholesterol mmol/L`, color = Label),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median) +
  geom_rug(mapping = aes(y = `Total Cholesterol mmol/L`, color = Label)) + 
  coord_flip()

?geom_rug
(new_data <- mutate(data, fitness_pr_kg = `ml/min`/ data$Weight))
ggplot(data = new_data) + geom_boxplot(mapping = aes(y = fitness_pr_kg, color = Label))

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

