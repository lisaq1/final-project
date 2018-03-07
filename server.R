library("plotly")
library("shiny")
library("ggplot2")
library("dplyr")

source("ReadingKagg.R")
df <- getFile()

my.server <- function(input, output){
  
  output$scatter <- renderPlotly({
    data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    
    data$seek_help[data$seek_help == "Don't know"] = "No" 
    
    data <- group_by(data, Country, seek_help) %>%
      summarize(average_age = mean(Age), count = n())
    
    plot_ly(data = data, x = ~average_age, y = ~Country, color = ~seek_help, size = ~count, colors = "Set1", type = 'scatter',
            text = ~paste(Country, paste0("Average Age: ", round(average_age, digits = 1), 
                                          paste0("\nNumber of respondents: ", count)), sep = "<br />"), hoverinfo = "text") %>%
      layout(title = 'World Wide View of Age and Seeking Mental Health Help Trend \n(hover for more information)\n',
             xaxis = list(title = 'Average Age'),
             yaxis = list(title = 'Country'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
    
  })
  
  output$bar <- renderPlotly({
    survey.data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    survey.data$Country[survey.data$Country == "Bahamas, The"] = "Bahamas"
    
    survey.data.1 <- group_by(survey.data, seek_help, care_options) %>%
      summarize(count = n())
    care_options <- c("Not Sure", "No", "Yes")
    survey.data.2 <- data.frame(care_options)
    
    value1 = survey.data.1$count[survey.data.1$seek_help == "No"]
    value2 = survey.data.1$count[survey.data.1$seek_help == "Don't know"]
    value3 = survey.data.1$count[survey.data.1$seek_help == "Yes"]
    survey.data.2$No_help <- value1
    survey.data.2$Not_sure <- value2
    survey.data.2$Yes_help <- value3
    
    plot_ly(survey.data.2, x = ~care_options, y = ~No_help, type = 'bar', name = 'No help seeked') %>%
      add_trace(y = ~Not_sure, name = 'Not sure') %>%
      add_trace(y = ~Yes_help, name = 'Help seeked') %>%
      layout(yaxis = list(title = 'Count'), xaxis = list(title = 'Company Offered Care Options'),
             title = 'World Wide View of Seeking Mental Health Help and Offered Care Options', 
             barmode = 'group') 
    
    
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
  
  output$scatter_spec <- renderPlotly({
    data1 <- filter_data()
    
    plot_ly(data = data1, x = ~Age, y = ~care_options, color = ~seek_help, size = ~count, colors = "Set1", type = 'scatter', 
            text = ~paste(paste0("Age: ", Age), paste0("\nNumber of respondents: ", count), paste0("\nHelp Seeked: ", seek_help), 
                          sep = "<br />"), hoverinfo = "text") %>%
      layout(title = paste('Age v. Offered Care Options \n(w/ influence of company offered care options)\n'),
             yaxis = list(title = 'Company Offered Care Options'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
  })
  
  output$us_scatter <- renderPlotly({
    data <- select(df, Country, state, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0, Country == "United States") 
    ## Filter out outliers such as 99999 years old
    data$seek_help[data$seek_help == "Don't know"] = "No" 
    
    data <- group_by(data, state, seek_help) %>%
      summarize(average_age = mean(Age), count = n())
    #data <- filter(data, Country == input$place)
    
    plot_ly(data = data, x = ~average_age, y = ~state, color = ~seek_help, size = ~count, colors = "Set1", type = 'scatter', 
            text = ~paste(state, paste0("Average Age: ", round(average_age, digits = 1), 
                                        paste0("\nNumber of respondents: ", count)), sep = "<br />"), hoverinfo = "text") %>%
      layout(title = 'United States Detailed View of Age and Seeking Mental Health Help Trend \n(hover for more information) \n',
             xaxis = list(title = 'Average Age'),
             yaxis = list(title = 'State (abbreviated)')) 
    
    
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
    
    plot_ly(survey.data.2, x = ~care_options, y = ~No_help, type = 'bar', name = 'No help seeked') %>%
      add_trace(y = ~Not_sure, name = 'Not sure') %>%
      add_trace(y = ~Yes_help, name = 'Help seeked') %>%
      layout(title = 'United States Detailed View of Seeking Mental Health Help and Offered Care Options Trend',
             xaxis = list(title = 'Company Offered Care Options'),
             yaxis = list(title = 'Count'), width = 800, height = 500)
  })
}