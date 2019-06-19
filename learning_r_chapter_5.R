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
  # 5.4 Select columns with select()
    # select() will select only the specified columns; aka it will remove the remainders
    ?select
    select(flights, year, month, day)
    # Select all columns between year and day (which will include month as well)
    select(flights, year:day)
    # Select all columns except
    select(flights, -(year:day))
    # A number of helper functions exist to aid select()
    # see all here:
    ?select_helpers
    # Examples:
    # starts_with("abc"), here we expect "year" to be the only one left
    select(flights, starts_with("ye"))
    # ends_with("xyz")
    select(flights, ends_with("ar"))
    # contains("ijk")
    select(flights, contains("ea"))
    # matches("(.)\\1") - matches a regular expression
    select(flights, matches(regex("ea")))
    # While select() will remove all non-explicitly mentioned variables, rename() will keep them (and rename whatever chosen)
    rename(flights, my_awesome_new_variable_year_name = year)
    # The helper everything() describes all the variables. We can move variables around by this (moving distance and air_time to the left):
    select(flights, distance, air_time, everything())
    
    # 5.4.1 Exercises
      # 1
        select(flights, dep_time, dep_delay, arr_time, arr_delay)
      # 2 Duplicates are ignored 
        select(flights, dep_time, dep_time, dep_time)
      # 3 one_of? Matches variable names in a character vector. Not sure how it's different from just selecting them
        ?one_of
        vars <- c("year", "month", "day", "dep_delay", "arr_delay")
        select(flights, one_of(vars))
        select(flights, vars)
      # 4 By default the helper functions ignore case. It can be toggled off; and the following will find nothing
        select(flights, contains("TIME", ignore.case = FALSE))

#5.5 Add variables with mutate()
  # It's helpful to add new columns; typically ones that are functions of already existing columns. For instance this could be height and weight columns combined into a BMI column
  flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
  mutate(flights_sml, gain = dep_delay - arr_delay, speed = distance / air_time * 60)
  mutate(flights_sml, gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain / hours)
  # If we only want to keep the new columns, use transmute - it will get rid of the existing columns
  transmute(flights_sml, gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain / hours)
  
  # 5.5.1 Useful creation functions
    # The function must be vectorized: it must take a vector of values as input, return a vector with the same number of values as output.
    # Arithmetic operators can be used: +, -, *, / etc
    # Modular arithmetic: %/% is integer division, %% is 'remainder',
    # Logs: log(), log2(), log10() etc
    # Offsets: lead(), lag()
    # Cumulative and rolling aggregates; such as sums, products, mins, maxs: cumsum(), cumprod(), cummin(), cummax() & cummean()
    # Logical comparisons such as <, <=, == etc.
    # Ranking: min_rank(), row_number(), dense_rank(), percent_rank(), cume_dist(), ntile()
  
  # 5.5.2 Exercises
    # It's mostly math exercises. I'm not here to learn math. The key take away message is that we can define our own functions and call them with mutate()/transmute()
  
# 5.6 Grouped summaries with summaries()
  # It collapses a data frame into a single row. Here we find the means of dep_delay and air_time.
  summarise(flights, delay = mean(dep_delay, na.rm = TRUE), mean(air_time, na.rm =TRUE ))
  # summarise is very useful with group_by. "Then, when you use the dplyr verbs on a grouped data frame they’ll be automatically applied “by group”". Here we group by month and can therefore calculate the mean departure delay for that month
  grouped_by_day <- group_by(flights, month)
  summarise(grouped_by_day, delay = mean(dep_delay, na.rm = TRUE))
  
  # 5.6.1 Combining multiple operations with the pipe
    # We might want to do this: Group flights by destination; summarise stuff; filter and then lastly; create a plot.
    by_dest <- group_by(flights, dest)
    delay <- summarise(by_dest,
                       count = n(),
                       dist = mean(distance, na.rm = TRUE),
                       delay = mean(arr_delay, na.rm = TRUE)
    )
    delay <- filter(delay, count > 20, dest != "HNL")
    ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
      geom_point(aes(size = count), alpha = 1/3) +
      geom_smooth(se = FALSE)
    
    # Clean up the objects:
    rm(by_dest, delay)
    
    # This can be rewritten with the Pipe
    # This focuses on the transformations, not what’s being transformed, which makes the code easier to read. You can read it as a series of imperative statements: group, then summarise, then filter. As suggested by this reading, a good way to pronounce %>% when reading code is “then”.
    
    delays <- flights %>% 
      group_by(dest) %>% 
      summarise(
        count = n(),
        dist = mean(distance, na.rm = TRUE),
        delay = mean(arr_delay, na.rm = TRUE)
      ) %>% 
      filter(count > 20, dest != "HNL")
    ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
      geom_point(aes(size = count), alpha = 0.33) +
      geom_smooth(se = FALSE)
    
  # 5.6.2 Missing values (NA)
    # na.rm = TRUE will remove NA when running most aggregation function (aggregation = the formation of a number of things into a cluster.)
  
  # 5.6.3
    # Whenever you do any aggregation, it’s always a good idea to include either a count (n()), or a count of non-missing values (sum(!is.na(x))). That way you can check that you’re not drawing conclusions based on very small amounts of data.
  
  # 5.6.4
    # Measures of location: mean(x), median(x)
    # Measures of spread: sd(x), IQR(x), mad(x)
      # The interquartile range IQR(x) and median absolute deviation mad(x) are robust equivalents (to SD) that may be more useful if you have outliers
    # Measures of rank: min(x), quantile(x), max(x). Quantiles are a generalisation of the median. For example, quantile(x, 0.25) will find a value of x that is greater than 25% of the values, and less than the remaining 75%.
    # Measures of position: first(x), nth(x, 2), last(x)
    # Counts: n() takes no arguments and returns the size of the current group. To count NA, do sum(!is.na(x)). To count the number of distinct (unique) values, use n_distinct(x)
      # A simple count() also exists. You can optionally provide a weight variable, here seeing which plane travelled the longest distance
      flights %>%
        filter(!is.na(dep_delay), !is.na(arr_delay)) %>%
        count(tailnum, wt = distance) %>%
        arrange(desc(n))
    # Counts and proportions of logical values: sum(x > 10), mean(y == 0)
      
  # 5.6.5 Grouping by multiple variables
    
# 5.7 Grouped mutates (and filters)
      