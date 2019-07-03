# TODO: Write functions for common plotting tasks

# Creates a bar plot with standard errors. Must be given a summarised tibble grouped by Label and what variable name to work with
createMeanBarPlot <- function(data_input, variable_name) {
  variableSD <- str_interp("${variable_name}_sd")
  variableSE <- str_interp("${variable_name}_se")
  coord_max_value <- max(data_input[[variable_name]]) + data_input[[variableSD]]
  coord_min_value <- min(data_input[[variable_name]]) - data_input[[variableSD]]
  
  plot <- ggplot(data = data_input) +
    geom_bar(aes(x = Label, y = data_input[[variable_name]], fill = Label), stat = "identity") +
    geom_errorbar(aes(x = Label,
                      ymin = (data_input[[variable_name]] - data_input[[variableSE]]),
                      ymax = (data_input[[variable_name]] + data_input[[variableSE]])),
                  width=0.1, colour="black", alpha=0.9, size=0.5
                  ) + 
    geom_label(aes(x = Label, y = data_input[[variable_name]], label = data_input[[variable_name]]) ) +
    coord_cartesian(ylim = c(coord_min_value, coord_max_value)) +
    labs(title = str_interp("Means for ${variable_name}"), y = variable_name)
  print(plot)
}