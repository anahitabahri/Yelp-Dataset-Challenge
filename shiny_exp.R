library(shiny)
library(leaflet)
library(readr)
library(dplyr)

data <- read_csv("../yelp-data/new_data/final_data/manip_data.csv")
data <- data.frame(data)
unique(data$state)
colnames(data)
# REMOVE EDH, MLN, KHL, ELN, FIF, RP

data <- data %>% filter(!state %in% c('EDH','MLN','KHL','ELN','FIF','RP','BW'))

ui <- fluidPage(
  selectInput("rt", "Rating:",
              c("5" = "5", "4" = "4",
                "3" = "3","2" = "2", 
                "1" = "1")),
  sliderInput(inputId = "ds",
              "Dot size", min=10, max=60, value=35, step=1),
  leafletOutput(outputId="map")
)


server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet(data = subset(data, ReviewStars==input$rt)) %>% 
      addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png') %>%
      setView(-100.044345, 41.314352, zoom = 4) %>%
      addCircles(~longitude, ~latitude, weight = 3, radius=40, color = "#ffa500", stroke = TRUE, fillOpacity = 0.8) 
  })
}

shinyApp(ui = ui, server = server)
