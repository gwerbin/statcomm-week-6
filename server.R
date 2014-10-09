library(shiny)
library(ggplot2)

source("SNU.R")

# shiny server ----

shinyServer(function (input, output, session) { 
  
  observe({
    updateSelectInput(session, "y",
                      choices = regression_variables[regression_variables != input$x]
    )})
    
  #snu_coef <- reactive(snu_fit(input$x, input$y, dat = snu))
  
  output$coefplot <- renderPlot({
#      snu_coefplot(output$snu_coef <- snu_coef())
#      text(0.5, 0.5, paste(input$x, " ", input$y))
#      text(0.2, 0.2, snu_fit(input$x, input$y))
#      snu_coefplot(snu_fit(input$x, input$y))
    if(input$withCap == TRUE) {snu_coefplot(snu_fit(input$x, input$y, dat = snu))}
    else {snu_coefplot(snu_fit(input$x, input$y, dat = snu[snu$capital!=1,]))}

 #   text(0.5, 0.5, paste(input$withCap, "", input$x, "", input$sortby))
  })
  
})
