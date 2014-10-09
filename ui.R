library(shiny)
library(ggplot2)

source("SNU.R")

x_input <- selectInput("x", "Independent variable:", regression_variables, width = "150%")
y_input <- selectInput("y", "Dependent variable:", regression_variables, width = "150%")
sort_input <- selectInput("sortby", "Sort by:", sortby_variables, width = "150%")
cap_input <- checkboxInput("withCap", "Include Capital Regions?", value = FALSE)

## this probably doesn't work as written. need to figure out how to access
##  the `reactive` object snu_coef() created in server.R
# sort_options <- list(
#   "Alphabetical" = order(row.names(output$snu_coef)),
#   # etc...
# )

# sort_by <- selectInput("sortby", "Sort by:", sort_options, width = "150%")

shinyUI(fluidPage(
  column(8, plotOutput("coefplot", height = "675px")), column(6, x_input, y_input, sort_input, cap_input)
))
  
