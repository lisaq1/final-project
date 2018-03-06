library("plotly")
library("shiny")
library("ggplot2")
library("dplyr")

source("ReadingKagg.R")
df <- getFile()

my.server <- function(input, output){
  output$scatter <- renderPlot({
    data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    data$seek_help[data$seek_help == "Don't know"] = "No" 
    #data <- group_by(data, Country, seek_help, care_options) %>%
    #  summarize(average_age = mean(Age), count = n())
    #data <- filter(data, Country == input$place)
    
    
    #ggplot(data = data) +
    #  geom_point(mapping = aes(x = average_age, y = care_options, color = seek_help, size = count)) 
    
    data <- group_by(data, Country, seek_help) %>%
      summarize(average_age = mean(Age), count = n())
    #data <- filter(data, Country == input$place)
    
    
    ggplot(data = data) +
      geom_point(mapping = aes(x = average_age, y = Country, color = seek_help, size = count)) +
      theme(
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        size = 0.5, linetype = "dotted"),
        panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                        colour = "gray"),
        panel.grid.minor = element_line(size = 0.25, linetype = 'dotted',
                                        colour = "lightgray")
      )
    
    
    # world <- map_data("world")
    # world <- mutate(world, Country.Code = iso.alpha(world$region, n = 3))
    # data <- mutate(data, Country.Code = iso.alpha(data$Country, n = 3))
    # data <- left_join(data, world)
    
    # ggplot(data = data) +
    #  geom_polygon(aes(x = long, y = lat, group = group, fill = Age)) +
    #  coord_quickmap()
  })
  
  output$bar <- renderPlotly({
    survey.data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    survey.data$Country[survey.data$Country == "Bahamas, The"] = "Bahamas"
    
    survey.data.1 <- group_by(survey.data, seek_help, care_options) %>%
      summarize(count = n())
    care_options <- c("Not Sure", "No", "Yes")
    survey.data.2 <- data.frame(care_options)
    # values = survey.data.1$count
    value1 = survey.data.1$count[survey.data.1$seek_help == "No"]
    value2 = survey.data.1$count[survey.data.1$seek_help == "Don't know"]
    value3 = survey.data.1$count[survey.data.1$seek_help == "Yes"]
    survey.data.2$No_help <- value1
    survey.data.2$Not_sure <- value2
    survey.data.2$Yes_help <- value3
    
    # data$seek_help[data$seek_help == "Don't know"] = "No" 

    #ggplot(data = survey.data, aes(x = care_options, fill = seek_help)) + 
    #  geom_bar() + scale_fill_brewer(palette = "Diverging") 
    
    plot_ly(survey.data.2, x = ~care_options, y = ~No_help, type = 'bar', name = 'No help seeked') %>%
      add_trace(y = ~Not_sure, name = 'Not sure') %>%
      add_trace(y = ~Yes_help, name = 'Help seeked') %>%
      layout(yaxis = list(title = 'Count'), barmode = 'group')
    
    
  })
  
  output$table <- renderTable({
    survey.data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    survey.data$Country[survey.data$Country == "Bahamas, The"] = "Bahamas"
    
    survey.data.1 <- group_by(survey.data, seek_help, care_options) %>%
      summarize(count = n())
    
  })
  
  filter_data <- reactive({
    data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    data$seek_help[data$seek_help == "Don't know"] = "No" 
    data <- filter(data, Country == input$place)
    data <- group_by(data, seek_help, care_options, Age) %>%
      summarize(count = n())
  })
  
  output$scatter_spec <- renderPlot({
      data1 <- filter_data()
      
      ggplot(data = data1) +
        geom_point(mapping = aes(x = Age, y = care_options, color = seek_help, size = count)) + 
        theme(
          panel.background = element_rect(fill = "white",
                                          colour = "white",
                                          size = 0.5, linetype = "dotted"),
          panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                          colour = "gray"),
          panel.grid.minor = element_line(size = 0.25, linetype = 'dotted',
                                          colour = "lightgray")
        )
      
  })
  
  output$us_scatter <- renderPlot({
    data <- select(df, Country, state, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0, Country == "United States") 
      ## Filter out outliers such as 99999 years old
    data$seek_help[data$seek_help == "Don't know"] = "No" 
    
    data <- group_by(data, state, seek_help) %>%
      summarize(average_age = mean(Age), count = n())
    #data <- filter(data, Country == input$place)
    
    
    ggplot(data = data) +
      geom_point(mapping = aes(x = average_age, y = state, color = seek_help, size = count)) +
      theme(
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        size = 0.5, linetype = "dotted"),
        panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                        colour = "gray"),
        panel.grid.minor = element_line(size = 0.25, linetype = 'dotted',
                                        colour = "lightgray")
      )
  })
  
  output$us_bar <- renderPlotly({
    survey.data <- select(df, Country, state, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0, Country == "United States") 
      ## Filter out outliers such as 99999 years old
    
    survey.data.1 <- group_by(survey.data, seek_help, care_options) %>%
      summarize(count = n())
    care_options <- c("Not Sure", "No", "Yes")
    survey.data.2 <- data.frame(care_options)
    # values = survey.data.1$count
    value1 = survey.data.1$count[survey.data.1$seek_help == "No"]
    value2 = survey.data.1$count[survey.data.1$seek_help == "Don't know"]
    value3 = survey.data.1$count[survey.data.1$seek_help == "Yes"]
    survey.data.2$No_help <- value1
    survey.data.2$Not_sure <- value2
    survey.data.2$Yes_help <- value3
    
    # data$seek_help[data$seek_help == "Don't know"] = "No" 
    
    #ggplot(data = survey.data, aes(x = care_options, fill = seek_help)) + 
    #  geom_bar() + scale_fill_brewer(palette = "Diverging") 
    
    plot_ly(survey.data.2, x = ~care_options, y = ~No_help, type = 'bar', name = 'No help seeked') %>%
      add_trace(y = ~Not_sure, name = 'Not sure') %>%
      add_trace(y = ~Yes_help, name = 'Help seeked') %>%
      layout(yaxis = list(title = 'Count'), barmode = 'group')
    
  })
}