# 3.2
  # mpg is a dataset that comes with ggplot2 as an example
  ggplot2::mpg
  # ggplot() creates a coordinate system upon which we add layers. Here the mpg dataset will be used for the graph
  ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
  # 3.2.4 - Exercises
    # 1 - I see nothing, because the data set is loaded without further commands
    ggplot(data = mpg)
    # 2 - 234 & 11
    nrow(mpg)
    ncol(mpg)
    #3 - Front vs rear wheel vs 4 wheel drive
    ?mpg
    #4 - That's a shitty scatterplot, alright
    ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl))
    #5 - Because class is a category
    ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))

# 3.3 Aesthetic mappings
  # Setting the color to class, will each class have its own color. Uniqeness will automatically be assigned
  ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = class))
  ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = class))
  ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
  ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = class))
  # 3.3.1 Exercises
    # 1 Place color outside
    ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
    # 2 If character strings, they must be categorical. If int/double they are continuous
    mpg
    # 3 & 4
    ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = cyl, color = cyl))
    # 5 Adds a stroke to the point, it seems
    ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = cyl, stroke = 2))
    # 6 Interesting.
    ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = cyl, color = displ < 5))

# 3.5 Facets
  # facet_wrap splits the plot into 'facets', best used with categorical variables
  ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ class, nrow = 2)
  # facet_grid splits the plot into 'facets', but by 2 variables
  ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ cyl)
  
  # 3.5.1 Exercises
    # 1 Facets are created for each unique step of the continuous variable
      ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ displ)
    # 2
      ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl)) + facet_grid(drv ~ cyl)
      ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl))
    # 3 The dot remove either column or row facet variable thingy
      ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ .)
      ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)
    # 4 Groups data point together; easier to look for outliers; easier with larger data sets
      ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ class, nrow = 2)
    # 5
      ?facet_wrap
    # 6
      
# 3.6 Geometric Objects
  # geom_smooth = smooth line from data; geom_point = scatter plot; etc. Geom functions take different aesthetics; such as 'linetype' for lines
  # or 'shape' for points
  ggplot(data = mpg) +
    geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv)) +
    geom_point(mapping = aes(x = displ, y = hwy, color = drv))
  # group = {variable} can be used to group data together
  ggplot(data = mpg) +
    geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
  # Adding more geoms will require duplicate code. Adding the mapping to the ggplot() function will instead create a 'global' (for that plot) mapping
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + geom_smooth()
  # The 'global' mapping can be overriden for an individual geom by passing in a mapping for that one
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(mapping = aes(color = class)) +
    geom_smooth()
  # Same principle can be used to provide different data for different geoms, here a smooth line only for class == 'subcompact'
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point(mapping = aes(color = class)) + 
    geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
  
  # 3.6.1 Exercises
    # 1 
      ?geom_line
      ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_line(mapping = aes(color = class))
    # 2
      ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
        geom_point() + 
        geom_smooth(se = FALSE)
    # 3 Removes legend. Do'h.
    # 4 Shows/hides Standard Error 'shadow'
    # 5 The same. One has global setting, the other has duplicate local settings
    # 6
      ggplot(data = mpg, mapping = aes(x = displ, y = hwy, stroke = 2)) +
        geom_point() +
        geom_smooth(se = FALSE)
      ggplot(data = mpg, mapping = aes(x = displ, y = hwy, stroke = 2)) +
        geom_point() +
        geom_smooth(mapping = aes(group = drv), se = FALSE)
      # etc...

# 3.7 Statistical transformations
  # The bar chart shows counts on the Y axis - that's an example of a STAT; Statistical Transformation.
  ggplot(data = diamonds ) + geom_bar(mapping = aes(x = cut))
  # A geom can use a default stat, as described here. "geom_bar() uses stat_count() as default"
  ?geom_bar
  # "You can generally use geoms and stats interchangeably. For example, you can recreate the previous plot using stat_count() instead of geom_bar()"
  ggplot(data = diamonds) + stat_count(mapping = aes(x = cut))
  # A geom has a default stat, and a stat has a default geom. That's the reason for the posibility above
  
  # Example demo data prepared
  demo <- tribble(
    ~cut,         ~freq,
    "Fair",       1610,
    "Good",       4906,
    "Very Good",  12082,
    "Premium",    13791,
    "Ideal",      21551)
  
  # This overrides the default stat for the geom_bar; this way we can map frequences on the y axis.
  ggplot(data = demo) +
    geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")
  
  # Overrides default mapping from transformed variables to aesthetics. A bar chart of proportion instead of count
  ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
  
  # Provides data about variable range (min to max) around the median.
  ggplot(data = diamonds) + 
    stat_summary(
      mapping = aes(x = cut, y = depth),
      fun.ymin = min,
      fun.ymax = max,
      fun.y = median)
  ?stat_summary
  
  # 3.7.1 Exercises
    # 1 It's geom_pointrange
    # 2 geom_bar uses stat_count (counts entries in the bin), geom_col uses stat_identity - it leaves the data as is. It seems like it just adds each
    # entry point on top of each other
      ?geom_col
      ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
      ggplot(data = diamonds) + geom_col(mapping = aes(x = cut, y = carat, color = carat, group = carat))
    # 3 They are often named the same
    # 4 Y is computed
      ?stat_smooth
    # 5 See solution
      ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, y = ..prop..))
      ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
                                         