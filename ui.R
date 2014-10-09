library(shiny)
library(ggplot2)

source("SNU.R")

x_input <- selectInput("x", "Independent variable:", regression_variables, width = "150%")
y_input <- selectInput("y", "Dependent variable:", regression_variables, width = "150%")
sort_input <- selectInput("sortBy", "Sort by:", sortby_variables, width = "150%")
sort_reverse <- checkboxInput("revSort", "Reverse sort order?", value = FALSE)
cap_input <- checkboxInput("withCap", "Include capital regions?", value = TRUE)

shinyUI(fluidPage(
  column(8, plotOutput("coefplot", height = "675px")),
  column(6, x_input, y_input, hr(), cap_input, hr(), sort_input, sort_reverse)
))
  
