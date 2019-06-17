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
  
  # 5.2.3 Missing values
    x <- NA
    is.na(x)
    # filter() only includes values that are TRUE; NA and FALSE are omitted. If they should be included, ask for them explicitly
    df <- tibble(x = c(1, NA, 3))
    # Will not show NA
    filter(df, x > 1)
    # Will show NA (is.na(x) will equal to TRUE and thus include the NA)
    filter(df, is.na(x) | x > 1)
    
  # 5.2.4 Exercises
    # 1 Find all flights that
      # 1.1 Find all that had a delay of 2 or more hours
        filter(flights, arr_delay >= 120)
      # 1.2 Flew to Houston (IAH or HOU)
        filter(flights, dest %in% c("IAH", "HOU"))
      # 1.3 Were operated by United, American or Delta
        # Cant find that parameter
      # 1.4 Departed in summer (July, August or September)
        filter(flights, month %in% c(7, 8, 9))
      # 1.5 Arrived more than two hours late, but didn't leave late
        filter(flights, arr_delay >= 120 & dep_delay < 1)
      # 1.6 Were delayed by at least an hour, but made up over 30 mins in flight
        filter(flights, arr_delay >= 60 & air_time > 30)
      # 1.7 Departed between midnight and 6am
        filter(flights, dep_time %in% (0:600))
    # 2 Another useful dplyr filter is between. What does it do?
      ?between
      filter(flights, between(dep_time, 0, 600))
    # 3 How many flights have a missing dep_time?
      filter(flights, is.na(dep_time))
      # Probably cancellations
    # 4 NA
  
  # 5.3 Arrange rows with arrange()
    # arrange() works similiar to filter(); instead of selecting rows, it changes their order.
    arrange(flights, year, month, day)
    # Default is ascending order; use desc() to re-order in a descending order
    arrange(flights, arr_delay)
    arrange(flights, desc(arr_delay))
    # Missing values are always sorted in the end, regardless of ascending / descending order
    
    # 5.3.1 Exercises
      # 1 How could you use arrange() to sort all missing values to the start?
      arrange(flights, desc(is.na(dep_time)))
      # 2 Sort flights to find the most delayed flights. Find the flights that left earliest.
      arrange(flights, desc(dep_delay))
      arrange(flights, dep_delay)
      # 3 Sort flights to find the fastest flights.
      arrange(flights, arr_delay)
      # 4 Which flights travelled the longest? Which travelled the shortest?
      arrange(flights, desc(distance))
      # JFK -> HNL
      arrange(flights, distance)
      # EWR -> PHL