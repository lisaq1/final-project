library("plotly")
library("shiny")
library("ggplot2")
library("dplyr")

source("ReadingKagg.R")
df <- getFile()

my.server <- function(input, output){
  output$table <- renderPlot({
    data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    data$seek_help[data$seek_help == "Don't know"] = "No" 
    data <- group_by(data, Country, seek_help, care_options) %>%
      summarize(average_age = mean(Age), count = n())
    data <- filter(data, Country == input$place)
    
    
    ggplot(data = data) +
      geom_point(mapping = aes(x = average_age, y = care_options, color = seek_help, size = count)) 
    
    # world <- map_data("world")
    # world <- mutate(world, Country.Code = iso.alpha(world$region, n = 3))
    # data <- mutate(data, Country.Code = iso.alpha(data$Country, n = 3))
    # data <- left_join(data, world)
    
    # ggplot(data = data) +
    #  geom_polygon(aes(x = long, y = lat, group = group, fill = Age)) +
    #  coord_quickmap()
  })
}