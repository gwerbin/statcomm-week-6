library(shiny)

source("SNU.R")

# shiny server ----

shinyServer(function (input, output, session) { 
  
#   observe({
#     dependent_variables <- reactive({
#       regression_variables[regression_variables != input$x]
#     })
#     
#     output$y <- renderUI({
#       selectInput("y", "Dependent variable: ", dependent_variables())
#     })
    
  output$coefplot <- renderPlot({
    snu_coefplot(
      snu_model(input$x, input$y, dat = snu)
    )
  })
#   })
  
})
