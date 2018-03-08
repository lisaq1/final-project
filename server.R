library("plotly")
library("shiny")
library("ggplot2")
library("dplyr")
library("maps")

# If opening zip
# source("ReadingKagg.R")
df <- read.csv("data/survey.csv", stringsAsFactors = FALSE)

my.server <- function(input, output){
  
  # Introduction Map! Shows where the data came from
  output$worldMap <- renderPlot({
    data <- select(df, Country)
    data <- group_by(df, Country) %>%
      summarize(respondents = n())
    ## need to account for the weirdly named ones
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    data$Country[data$Country == "United States"] = "USA"
    data$Country[data$Country == "United Kingdom"] = "UK"
    map <- map_data("world")
    names <- c("long", "lat", "group", "order", "Country", "subregion")
    colnames(map) = names
    data <- left_join(data, map)
    ggplot(data = data) +
      borders("world", fill = "black", colour = "grey50")+ 
      geom_polygon(aes(x = long, y = lat, group = group, fill = respondents)) +
      coord_quickmap() +
      labs(title = "World Map of Collected Data Density")
  })
  
  ##### TAB: SEEKING HELP & CARE OPTIONS
  
  # Filters the data that was commonly used in the World Wide view
  worldWideFilter <- function(){
    data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    
    return(data)
  }
  
  # Renders the table of data used to create the World Wide scatter plot upon request
  output$scatterWorld <- renderTable({
    if(input$checkbox1 == TRUE){
      data <- worldWideFilter()
      data$seek_help[data$seek_help == "Don't know"] = "No" 
      data <- group_by(data, Country, seek_help) %>%
        summarize(average_age = mean(Age), count = n())
    }
  })
  
  # Creates the scatter plot of ave age v. country with influence of seeking help (World Wide)
  output$scatter <- renderPlotly({
    data <- worldWideFilter()
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
  
  # Renders the table used to create the World Wide bar graph of seeking help and care options upon request
  output$barWorld<- renderTable({
    if(input$checkbox2 == TRUE){
      survey.data <- worldWideFilter()
      survey.data.1 <- group_by(survey.data, seek_help, care_options) %>%
        summarize(count = n())
    }
  })
  
  # Creates the bar graph of seeking help and care options (World Wide)
  output$bar <- renderPlotly({
    survey.data.2 <- filterUSBar();
    
    plot_ly(survey.data.2, x = ~care_options, y = ~No_help, type = 'bar', name = 'No help seeked') %>%
      add_trace(y = ~Not_sure, name = 'Not sure') %>%
      add_trace(y = ~Yes_help, name = 'Help seeked') %>%
      layout(yaxis = list(title = 'Count'), xaxis = list(title = 'Company Offered Care Options'),
             title = 'World Wide View of Seeking Mental Health Help and Offered Care Options', 
             barmode = 'group') 
    
    
  })
  
  # Renders the data used to create the US scatter plot by the states 
  output$scatterUS <- renderTable({
    if(input$checkbox3){
      data <- select(df, Country, state, state_full, Age, seek_help, care_options) %>% 
        filter(Age < 100, Age > 0, Country == "United States") 
      ## Filter out outliers such as 99999 years old
      data$seek_help[data$seek_help == "Don't know"] = "No" 
      
      data <- group_by(data, state, state_full, seek_help) %>%
        summarize(average_age = mean(Age), count = n())
    }
  })
  
  # Creates the scatter plot by state for the US by age v. states while showing a trend of seeking help and age
  output$us_scatter <- renderPlotly({
    data <- select(df, Country, state, state_full, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0, Country == "United States") 
    ## Filter out outliers such as 99999 years old
    data$seek_help[data$seek_help == "Don't know"] = "No" 
    
    data <- group_by(data, state, state_full, seek_help) %>%
      summarize(average_age = mean(Age), count = n())
    
    plot_ly(data = data, x = ~average_age, y = ~state, color = ~seek_help, size = ~count, colors = "Set1", type = 'scatter', 
            text = ~paste(state_full, paste0("Average Age: ", round(average_age, digits = 1), 
                                             paste0("\nNumber of respondents: ", count)), sep = "<br />"), hoverinfo = "text") %>%
      layout(title = 'United States Detailed View of Age and Seeking Mental Health Help Trend \n(hover for more information) \n',
             xaxis = list(title = 'Average Age'),
             yaxis = list(title = 'State (abbreviated)')) 
    
    
  })
  
  # Filters the data to the desired data for the US Bar Graph of seeking help and care options
  filterUSBar <- function(){
    survey.data <- worldWideFilter()
    
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
    return(survey.data.2)
  }
  
  # Renders the data used to create the US bar graph
  output$barUS <- renderTable({
    if(input$checkbox4 == TRUE){
      data <- filterUSBar();
    }
  })
  
  # Creates the US bar graph showing the relationship between seeking help and offered care options
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
  
  # Makes the input of Country in the third tab reactive
  filter_data <- reactive({
    data <- worldWideFilter()
    data <- filter(data, Country == input$place)
    data <- group_by(data, seek_help, care_options, Age) %>%
      summarize(count = n())
  })
  
  # Creates a scatter plot of the country of interest of its trend in age, seeking help, and offered care options
  output$scatter_spec <- renderPlotly({
    data1 <- filter_data()
    
    plot_ly(data = data1, x = ~Age, y = ~care_options, color = ~seek_help, size = ~count, colors = "Set1", type = 'scatter', 
            text = ~paste(paste0("Age: ", Age), paste0("\nNumber of respondents: ", count), paste0("\nHelp Seeked: ", seek_help), 
                          sep = "<br />"), hoverinfo = "text") %>%
      layout(title = paste('Age v. Offered Care Options \n(w/ influence of company offered care options)\n'),
             yaxis = list(title = 'Company Offered Care Options'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
  })
  
  ## Tab: Work Interference & Medical Leave
  
  # select from dataset: Country, Age, work_intereference, leave
  
  worldWideFilter2 <- function(){
    data <- select(df, Country, Age, work_interfere, leave) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    
    return(data)
  }
  
  ###  Tab 1 - Country & World
  
  # Select Country 
  
  filter_data2 <- reactive({
    data <- worldWideFilter2()
    data <- filter(data, Country == input$country_leave)
    data <- group_by(data, work_interfere, leave, Age) %>%
      summarize(count = n())
  })
  
  # Tab 1 - Scatterplot 1
  
  output$scatter_leave <- renderPlotly({
    data2 <- filter_data2()
    
    plot_ly(data = data2, x = ~Age, y = ~work_interfere, color = ~leave, size = ~count, colors = "Set1", type = 'scatter',
            text = ~paste(paste0("Age: ", Age), paste0("\nNumber of respondents: ", count), paste0("\nMedical Leave: ", leave),
                          sep = "<br />"), hoverinfo = "text") %>%
      layout(title = paste('Work Interference by Age \n& Ability to take Medical Leave\n'),
             yaxis = list(title = 'Work Interference'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
  })
  
  
  # Tab 1 - Scatterplot 2 - scatter_leave_world
  filter_data3 <- reactive({
    data <- worldWideFilter2()
    #data <- filter(data, Country == input$country_leave)
    data <- group_by(data, work_interfere, leave, Age) %>%
      summarize(count = n())
  })
  
  
  output$scatter_leave_world <- renderPlotly({
    data3 <- filter_data3()
    
    plot_ly(data = data3, x = ~Age, y = ~work_interfere, color = ~leave, size = ~count, colors = "Set1", type = 'scatter',
            text = ~paste(paste0("Age: ", Age), paste0("\nNumber of respondents: ", count), paste0("\nMedical Leave: ", leave),
                          sep = "<br />"), hoverinfo = "text") %>%
      layout(title = paste('World - Work Interference by Age \n& Ability to take Medical Leave\n'),
             yaxis = list(title = 'Work Interference'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
  })
  
  # Tab 2 - United States - us_leave1 - scatterplot
  output$us_leave1 <- renderPlotly({
    data2 <- worldWideFilter2()
    data2 <- filter(data2, Country == "United States")
    data2 <- group_by(data2, work_interfere, leave, Age) %>%
      summarize(count = n())
    
    plot_ly(data = data2, x = ~Age, y = ~work_interfere, color = ~leave, size = ~count, colors = "Set1", type = 'scatter',
            text = ~paste(paste0("Age: ", Age), paste0("\nNumber of respondents: ", count), paste0("\nMedical Leave: ", leave),
                          sep = "<br />"), hoverinfo = "text") %>%
      layout(title = paste('Work Interference by Age \n& Ability to take Medical Leave\n'),
             yaxis = list(title = 'Work Interference'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
  })
  
  
  
  # Tab 2 - United States tab - bar_leave1 
  
  output$bar_leave1 <- renderPlotly({
    data <- worldWideFilter2()
    data <- filter(data, Country == "United States") #input from dropdown on this page
    data <- group_by(data, work_interfere, leave) %>%
      summarize(count = n())
    
    data <- filter(data, !is.na(work_interfere))
    interference <- c("Never", "Often", "Rarely", "Sometimes")
    dont_know = data$count[data$leave == "Don't know"]
    somewhat_difficult = data$count[data$leave == "Somewhat difficult"]
    somewhat_easy = data$count[data$leave == "Somewhat easy"]
    very_difficult = data$count[data$leave == "Very difficult"]
    very_easy = data$count[data$leave == "Very easy"]
    data.1 <- data.frame(interference, very_difficult, somewhat_difficult,
                         somewhat_easy, very_easy)
    plot_ly(data.1, x = ~interference, y = ~dont_know, type = 'bar', name = 'Not Sure') %>%
      add_trace(y = ~very_difficult, name = 'Very Difficult') %>%
      add_trace(y = ~somewhat_difficult, name = 'Somewhat Difficult') %>%
      add_trace(y = ~somewhat_easy, name = 'Somewhat Easy') %>%
      add_trace(y = ~very_easy, name = 'Very Easy') %>%
      layout(title = 'U.S. Work Interference vs. Leave Difficulty',
             xaxis = list(title = 'Work Interference Level'),
             yaxis = list(title = 'Leave Difficulty (# respondents)'), width = 800, height = 500)
  })
  # Tab 1 - Country & World tab - bar graph
  output$bar_leave2 <- renderPlotly({
    data <- worldWideFilter2()
    data <- group_by(data, work_interfere, leave) %>%
      summarize(count = n())
    
    data <- filter(data, !is.na(work_interfere))
    interference <- c("Never", "Often", "Rarely", "Sometimes")
    dont_know = data$count[data$leave == "Don't know"]
    somewhat_difficult = data$count[data$leave == "Somewhat difficult"]
    somewhat_easy = data$count[data$leave == "Somewhat easy"]
    very_difficult = data$count[data$leave == "Very difficult"]
    very_easy = data$count[data$leave == "Very easy"]
    data.1 <- data.frame(interference, very_difficult, somewhat_difficult,
                         somewhat_easy, very_easy)
    plot_ly(data.1, x = ~interference, y = ~dont_know, type = 'bar', name = 'Not Sure') %>%
      add_trace(y = ~very_difficult, name = 'Very Difficult') %>%
      add_trace(y = ~somewhat_difficult, name = 'Somewhat Difficult') %>%
      add_trace(y = ~somewhat_easy, name = 'Somewhat Easy') %>%
      add_trace(y = ~very_easy, name = 'Very Easy') %>%
      layout(title = 'Selected Country - Work Interference vs. Leave Difficulty',
             xaxis = list(title = 'Work Interference Level'),
             yaxis = list(title = 'Leave Difficulty (# respondents)'), width = 800, height = 500)
  })
  
  
}