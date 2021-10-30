# Program: shiny_app_01
# Description: 1st simply shiny app for horror movie data set
# Author: Jose S. Lopez

# library setup
library(tidyverse)
library(shiny)
library(plotly)

hmdata <- read_csv("/home/rstudio/work/derived_data/hmdata.csv", col_types = cols()) %>%
          select(-title, -genres, -release_date, -release_country, 
                 -plot, -cast, -language, -filming_locations, -date,
                 -review_vs_median, -movie_lead, -num_of_genres, -budget)

ui <- fluidPage(
  selectInput("choice", "Choose", choices = names(hmdata), selected = NULL),
  plotlyOutput("graph")
)

server <- function(input, output, session){
  
  output$graph <- renderPlotly({
    plot_ly(hmdata, x = ~get(input$choice), y = ~review_rating, type = 'scatter', mode = 'markers')
  })
}

shinyApp(ui=ui, server=server,
         options=list(port=8080, host="0.0.0.0"))
