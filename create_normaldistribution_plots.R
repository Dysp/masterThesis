# Iterate over all variables and run the plotDistribution function for them
sapply(control, plotDistribution)

plotDistribution <- function(data_points) {
  if (is.numeric(data_points) && length(data_points) > 2) {
    # Store length of the data points
    original_length <- length(data_points)
    # Remove N/A
    data_points_without_na <- na.omit(data_points)
    # Create plot
    d <- density(data_points_without_na)
    plot(d)
    rug(data_points)
    # Return how many N/A's were omitted
    glue("{original_length - length(data_points_without_na)} N/As were omitted from the data set)")
  }
}