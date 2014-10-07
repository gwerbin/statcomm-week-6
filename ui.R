library(shiny)
library(ggplot2)

source("SNU.R")

x_input <- selectInput("x", "Independent variable: ", regression_variables)
y_input <- selectInput("y", "Dependent variable: ", regression_variables)
  
shinyUI(fluidPage(
  column(6, plotOutput("coefplot", height = "600px")), column(6, x_input, y_input)
))
  
