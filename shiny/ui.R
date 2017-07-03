library(shiny)

shinyUI(fluidPage(
  
  sidebarLayout(
    sidebarPanel('Na spodnjem grafu lahko vidimo predikcijo števila prihodov ali prenočitev turistov iz izbrane države v izbrani občini na podlagi linearne regresije.'), 
    mainPanel()
    ),
  
  selectInput(inputId = 'obcina', 
              label = 'Občina:', 
              choices = prihodi_prenocitve$obcina,
              selected = 'Ljubljana',
              multiple = FALSE),
  
  selectInput(inputId = 'drzava',
              label = 'Država:',
              choices = prihodi_prenocitve$drzava,
              selected = 'TUJI',
              multiple = FALSE),
  
  radioButtons(inputId = 'vrsta',
               label = '',
               choiceValues = list('Prihodi turistov - SKUPAJ', 'Prenočitve turistov - SKUPAJ'),
               choiceNames = list('Prihodi', 'Prenočitve')),
  
  plotOutput('lin')
  
  
  
))
