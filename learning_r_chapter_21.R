library(nycflights13)
# 21 Iteration

# 21.2 For loops
  # Given a tibble
    df <- tibble(
      a = rnorm(10),
      b = rnorm(10),
      c = rnorm(10),
      d = rnorm(10))
  # We want the median of each column
  # Firstly, create a 'container' for the data. here we create a new vector of 'doubles' with the length of the amount of columns in df
    output <- vector("double", ncol(df))
  # Secondly, the sequence; it determines what to loop over. Here for i in the range (sequence) of 'df'
    for (i in seq_along(df)) {
      # The body: at each index, calculate median of that index
      output[[i]] <- median(df[[i]])
    }
    output
  # 21.2.1 Exercises
    # 1 Compute the mean of every column in mtcars.
      output_mtcars <- vector("double", ncol(mtcars))
      for (i in seq_along(mtcars)) {
        output_mtcars[[i]] <- mean(mtcars[[i]])
      }
      output_mtcars
    # 2 Determine the type of each column in nycflights13::flights
      output_flights <- vector("list", ncol(flights))
      names(output_flights) <- names(flights)
      for (i in seq_along(flights)) {
        output_flights[[i]] <- class(flights[[i]])
      }
      output_flights
    # 3 Compute the number of unique values in each column of iris.

# 21.3 For loops variations
  # There are 4 variations on loops    
  # 1. Modifying an existing object, instead of creating a new object.
  # 2. Looping over names or values, instead of indices.
  # 3. Handling outputs of unknown length.
  # 4. Handling sequences of unknown length.
  
  # 21.3.1 Modifying an existing object
  # 21.3.1 21.3.2 Looping patterns
    # There are more ways of looping than going through the indices:
    # 1. Loop over the elements: for (x in xs). This is most useful if you only care about side-effects, like plotting or saving a file, because it’s difficult to save the output efficiently.
    # 2. Loop over the names: for (nm in names(xs)). This gives you name, which you can use to access the value with x[[nm]]
    # This is useful if you want to use the name in a plot title or a file name. If you’re creating named output, make sure to name the results vector like so:  
    # results <- vector("list", length(x))
    # names(results) <- names(x)
      
      