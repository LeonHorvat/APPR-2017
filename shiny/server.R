library(shiny)

shinyServer(function(input, output) {
   
  output$lin <- renderPlot({
    data <- filter(prihodi_prenocitve, 
                   obcina == input$obcina, 
                   drzava == input$drzava, 
                   prihod_prenocitev == input$vrsta)
    g5 <- ggplot(data, aes(x = leto, y = stevilo)) +
      geom_point()
    
    g5 + xlim(2008, 2022) +
      geom_smooth(method = 'lm', fullrange = TRUE, se = FALSE) +
      xlab("Leto") + ylab("Prihodi turistov")
  })
})
