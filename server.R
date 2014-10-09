library(shiny)
library(ggplot2)

source("SNU.R")

# shiny server ----

shinyServer(function (input, output, session) { 
  
  observe({
    updateSelectInput(session, "y",
                      choices = regression_variables[regression_variables != input$x]
    )})
    
  snu_coef <- reactive(snu_fit(input$x, input$y, dat = snu))
  
  output$coefplot <- renderPlot({
    snu_coefplot(output$snu_coef <- snu_coef())
#     text(0.5, 0.5, snu_coef)
  })
  
})
