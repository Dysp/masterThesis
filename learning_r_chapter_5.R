# Load 'flights' data before we begin
library(nycflights13)

# 5.1.2 Data introduction
  flights
  View(flights)
  # Instead of using default dataframes, 'flights' is a 'tibbe'; a modified version of a data frame used in the Tidyverse
  # int = integer, dbl = double, chr = character, dttm = date-times, lgl = logical, fctr = factors (categorical variables), date = date

# 5.1.3 dplyr basics
  # Pick observations by their values (logical statement where something is TRUE)
  filter(flights, origin == "EWR")
  # Pick variables by their name
  select(flights, origin)
  # Arrange (sort) by variable
  arrange(flights, dest)
  # Mutate: Not sure what it does
  ?mutate
  mutate(flights, hour*1000)
  # Collapse many values down to a single summary. Not sure what it does.
  summarise(flights)

# 5.2 filter
  # Filter the data by some statement, here only return flights that occured on the first day of the first month:
  filter(flights, day == 1, month == 1)
  
  # 5.2.1 Comparisons
    # Instead of using an equal operator == for comparison with numbers, use near(). == is very literal
    sqrt(2) ^ 2 == 2
    near(sqrt(2)^2, 2)
  
  # 5.2.2 Logical operators
    filter(flights, month == 11 | month == 12)
    # Can be written easier like
    filter(flights, month %in% c(11, 12))
    