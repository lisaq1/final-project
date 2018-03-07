library("plotly")
library("shiny")
library("ggplot2")
library("dplyr")
library("maps")

# If opening zip
# source("ReadingKagg.R")
df <- read.csv("data/survey.csv", stringsAsFactors = FALSE)

my.server <- function(input, output){
  
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
  
  worldWideFilter <- function(){
    data <- select(df, Country, Age, seek_help, care_options) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    
    return(data)
  }
  
  output$scatterWorld <- renderTable({
    if(input$checkbox1 == TRUE){
      data <- worldWideFilter()
      data$seek_help[data$seek_help == "Don't know"] = "No" 
      data <- group_by(data, Country, seek_help) %>%
        summarize(average_age = mean(Age), count = n())
    }
  })
  
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
  
  output$barWorld<- renderTable({
    if(input$checkbox2 == TRUE){
      survey.data <- worldWideFilter()
      survey.data.1 <- group_by(survey.data, seek_help, care_options) %>%
        summarize(count = n())
    }
  })
  
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
  
  output$barUS <- renderTable({
    if(input$checkbox4 == TRUE){
      data <- filterUSBar();
    }
  })
  
  output$bar <- renderPlotly({
    survey.data.2 <- filterUSBar();
    
    plot_ly(survey.data.2, x = ~care_options, y = ~No_help, type = 'bar', name = 'No help seeked') %>%
      add_trace(y = ~Not_sure, name = 'Not sure') %>%
      add_trace(y = ~Yes_help, name = 'Help seeked') %>%
      layout(yaxis = list(title = 'Count'), xaxis = list(title = 'Company Offered Care Options'),
             title = 'World Wide View of Seeking Mental Health Help and Offered Care Options', 
             barmode = 'group') 
    
    
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
  
  
  filter_data <- reactive({
    data <- worldWideFilter()
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
  
  
  
  ######## Tab: Work Interference & Medical Leave
  
# select from dataset: Country, Age, work_intereference, leave
  
  worldWideFilter2 <- function(){
    data <- select(df, Country, Age, work_interfere, leave) %>% 
      filter(Age < 100, Age > 0) ## Filter out outliers such as 99999 years old
    data$Country[data$Country == "Bahamas, The"] = "Bahamas"
    
    return(data)
  }
 
## Scatterplot - Select country 
  
   filter_data2 <- reactive({
    data <- worldWideFilter2()
    data <- filter(data, Country == input$country_leave)
    data <- group_by(data, work_interfere, leave, Age) %>%
       summarize(count = n())
   })
   
  output$scatter_leave <- renderPlotly({
     data2 <- filter_data2()
  
     plot_ly(data = data2, x = ~Age, y = ~work_interfere, color = ~leave, size = ~count, colors = "Set1", type = 'scatter',
             text = ~paste(paste0("Age: ", Age), paste0("\nNumber of respondents: ", count), paste0("\nMedical Leave: ", leave),
                          sep = "<br />"), hoverinfo = "text") %>%
      layout(title = paste('Work Interference by Age \n& Ability to take Medical Leave\n'),
               yaxis = list(title = 'Work Interference'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
    })

  
###  Scatterplot - Worldwide

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
      layout(title = paste('Work Interference by Age \n& Ability to take Medical Leave\n'),
             yaxis = list(title = 'Work Interference'), margin=list(l = 100), yaxis=list(tickprefix="\t"))
  })
  
  
 #  ###### Bar Graph - Select Country - output: bar_leave1
 #  
 #  filter_data3 <- reactive({
 #    data <- worldWideFilter2()
 #    data <- filter(data, Country == input$country_leave2) #input from dropdown on this page
 #    data <- group_by(data, work_interfere, leave, Age) %>%
 #      summarize(count = n())
 #  })
 #  
 #    filterLeave <- function(){
 #      survey.data.leave <- filter_data3()  # get filtered data from Reactive function for input
 #      survey.data.1.leave <- group_by(survey.data.leave, leave, work_interfere) %>%
 #        summarize(count = n())
 #      work_interfere <- c("Never", "Rarely", "Sometimes", "Often")
 #      survey.data.2.leave <- data.frame(work_interfere)
 #      
 #      value1 = survey.data.1.leave$count[survey.data.1.leave$leave == "Very easy"]
 #      value2 = survey.data.1.leave$count[survey.data.1.leave$leave == "Somewhat easy"]
 #      value3 = survey.data.1.leave$count[survey.data.1.leave$leave == "Somewhat difficult"]
 #      value4 = survey.data.1.leave$count[survey.data.1.leave$leave == "Very difficult"]
 #      value5 = survey.data.1.leave$count[survey.data.1.leave$leave == "Don't know"]
 #      survey.data.2.leave$v_easy <- value1
 #      survey.data.2.leave$s_easy <- value2
 #      survey.data.2.leave$s_diff <- value3
 #      survey.data.2.leave$v_diff <- value4
 #      survey.data.2.leave$d_know <- value5
 #      return(survey.data.2)
 #    }
 #    #static bar -- change to world 
 #    #plotlyOutput("bar_leave")
 #    
 #    output$bar_leave2 <- renderPlotly({
 #      survey.data.2.leave <- filterLeave();
 #      
 #      plot_ly(survey.data.2.leave, x = ~care_options, y = ~v_easy, type = 'bar', name = 'Very Easy') %>%
 #        add_trace(y = ~s_easy, name = 'Somewhat Easy') %>%
 #        add_trace(y = ~s_diff, name = 'Somewhat Difficult') %>%
 #        add_trace(y = ~v_diff, name = 'Very Difficult') %>%
 #        add_trace(y = ~d_know , name = 'Does Not Know') %>%
 #        layout(yaxis = list(title = 'Count'), xaxis = list(title = 'Work Interference'),
 #               title = 'Work Interference & Ability to take Medical Leave', 
 #               barmode = 'group') 
 #    })
 #  
 #  #### Worldwide Data (static, no input, data for all countries) - output: bar_leave2
 #  
 #  filterLeave <- function(){
 #    survey.data.leave <- worldWideFilter2()
 #    
 #    survey.data.1.leave <- group_by(survey.data.leave, leave, work_interfere) %>%
 #      summarize(count = n())
 #    work_interfere <- c("Never", "Rarely", "Sometimes", "Often")
 #    survey.data.2.leave <- data.frame(work_interfere)
 #    
 #    value1 = survey.data.1.leave$count[survey.data.1.leave$leave == "Very easy"]
 #    value2 = survey.data.1.leave$count[survey.data.1.leave$leave == "Somewhat easy"]
 #    value3 = survey.data.1.leave$count[survey.data.1.leave$leave == "Somewhat difficult"]
 #    value4 = survey.data.1.leave$count[survey.data.1.leave$leave == "Very difficult"]
 #    value5 = survey.data.1.leave$count[survey.data.1.leave$leave == "Don't know"]
 #    survey.data.2.leave$v_easy <- value1
 #    survey.data.2.leave$s_easy <- value2
 #    survey.data.2.leave$s_diff <- value3
 #    survey.data.2.leave$v_diff <- value4
 #    survey.data.2.leave$d_know <- value5
 #    return(survey.data.2)
 #  }
 #  
 #  output$bar_leave2 <- renderPlotly({
 #    survey.data.2.leave <- filterLeave();
 #    
 #    plot_ly(survey.data.2.leave, x = ~care_options, y = ~v_easy, type = 'bar', name = 'Very Easy') %>%
 #      add_trace(y = ~s_easy, name = 'Somewhat Easy') %>%
 #      add_trace(y = ~s_diff, name = 'Somewhat Difficult') %>%
 #      add_trace(y = ~v_diff, name = 'Very Difficult') %>%
 #      add_trace(y = ~d_know , name = 'Does Not Know') %>%
 #      layout(yaxis = list(title = 'Count'), xaxis = list(title = 'Work Interference'),
 #             title = 'Work Interference & Ability to take Medical Leave', 
 #             barmode = 'group') 
 #    
 # 
 #  })
 # 
 # ############ 
 #  
}