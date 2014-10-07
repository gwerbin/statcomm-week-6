library(shiny)

load("snu.RData")

shinyServer(function(input,output,session) { 

  output$coefplot <- snu_coefplot(
    snu_model(input$x, input$y, dat = snu)
  )
  
})
