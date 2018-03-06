library("shiny")
library("plotly")

my.ui <- fluidPage(
    mainPanel(
    p("display"),
    tabsetPanel(tabPanel("World Wide Info", plotOutput("scatter"), br(),
                         p("The above scatterplot shows the average age of respondents in each
                           country as well as whether the respondents have seeked help in the past.
                           In the survey, individuals sometimes put 'Not sure' and that was 
                           interpretted as no help seeked."), br(),
                         plotlyOutput("bar"), br(), p("The bar graph shows in detail the TOTAL number of 
                                                respondents who have not seeked help and have. For a 
                                                better breakdown the respondents who said 'Not sure' are
                                                shown as well."), br(),
                         tableOutput("table"), br(), p("The table shows a breakdown on where all the data came
                                                 from.")),
                tabPanel("Countries", fluidRow(selectInput("place", "Country of Interest", 
                              c("Australia", "Austria", "Bahamas", "Belgium", "Bosnia and Herzegovina",
                                "Brazil", "Bulgaria", "Canada", "China", "Colombia", "Costa Rica", "Croatia",
                                "Czech Republic", "Denmark", "Finland", "France", "Georgia", "Germany",
                                "Greece", "Hungary", "India", "Ireland", "Israel", "Italy", "Japan", "Latvia",
                                "Mexico", "Moldova", "Netherlands", "New Zealand", "Nigeria", "Norway",
                                "Philippines", "Poland", "Portugal", "Romania", "Russia", "Singapore", "Slovenia",
                                "South Africa", "Spain", "Sweden", "Switzerland", "Thailand", "United Kingdom",
                                "United States", "Uruguay")), plotOutput("scatter_spec"))),
                tabPanel("United States", plotOutput("us_scatter"), plotlyOutput("us_bar")))
  )
)
