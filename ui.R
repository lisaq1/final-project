library("shiny")
library("plotly")
# library(DT)

my.ui <- fluidPage(
  titlePanel(strong("Mental Health in Tech")),  # Project Title bolded
  mainPanel(
      tabsetPanel(tabPanel("World Wide Info", br(), h4("World Wide Trends Plots"), plotlyOutput("scatter"), br(),
                           p("The above scatterplot shows the average age of respondents in each
                             country as well as whether the respondents have seeked help in the past.
                             In the survey, individuals sometimes put 'Not sure' and that was 
                             interpretted as no help seeked. The size of the dot depends on the number of respondents
                             that responded in that certain way of that country."), br(),
                           plotlyOutput("bar"), br(), p("The bar graph shows in detail the TOTAL number of 
                                                        respondents who have not seeked help and have. For a 
                                                        better breakdown the respondents who said 'Not sure' are
                                                        shown as well."), br(),
                           tableOutput("table"), br(), p("The table shows a breakdown on where all the data came
                                                         from.")),
                  tabPanel("United States", br(), plotlyOutput("us_scatter"), br(), br(), 
                           plotlyOutput("us_bar")),
                  tabPanel("Countries", br(), h4("Specific Country Age v. Company Offering Care Options"), 
                            fluidRow(p("Select a country of interest (the first four countries have more documented 
                                        data than others - the United States, United Kingdom, Canada, and Germany consist 
                                         a majority of the data)"), 
                                     selectInput("place", "Country of Interest",
                                                  c("United States", "United Kingdom", "Canada", "Germany", "Australia", "Austria", 
                                                    "Bahamas", "Belgium", "Bosnia and Herzegovina", "Brazil", "Bulgaria", "China", 
                                                    "Colombia", "Costa Rica", "Croatia", "Czech Republic", "Denmark", "Finland", 
                                                    "France", "Georgia", "Greece", "Hungary", "India", "Ireland", "Israel", "Italy", 
                                                    "Japan", "Latvia", "Mexico", "Moldova", "Netherlands", "New Zealand", "Nigeria", 
                                                    "Norway", "Philippines", "Poland", "Portugal", "Romania", "Russia", "Singapore", 
                                                    "Slovenia", "South Africa", "Spain", "Sweden", "Switzerland", "Thailand", "Uruguay")), 
                                                    plotlyOutput("scatter_spec")))
                   
      )
    )
)
           
    