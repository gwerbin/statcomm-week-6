library(shiny)
library(ggplot2)

source("./SNU.R")

# shiny server ----

shinyServer(function (input, output, session) { 
  
  observe({
    updateSelectInput(session, "y",
                      choices = regression_variables[regression_variables != input$x]
    )})
  
  sortBy <- reactive({switch(input$sortBy,
    "Coefficient"             = expression( order(out$coef, decreasing = input$revSort) ),
    "Number of observations"  = expression( order(out$N, decreasing = input$revSort) ),
    "Country name"            = expression( order(row.names(out), decreasing = input$revSort) )
  )})
  
  snu_coef <- reactive({
    if (input$withCap) out <- snu_fit(input$x, input$y, dat = snu)
    else out <- snu_fit(input$x, input$y, dat = snu[snu$capital!=1,])
    
    sortBy <- switch(input$sortBy,
           "Coefficient"             = order(out$coef, decreasing = input$revSort),
           "Number of observations"  = order(out$N, decreasing = input$revSort),
           "Country name"            = order(row.names(out), decreasing = input$revSort)
    )
    
    out$country <- factor(out$country, levels(out$country)[sortBy])
    
    out
  })
  
  output$coefplot <- renderPlot( snu_coefplot(snu_coef()) )
  
})
