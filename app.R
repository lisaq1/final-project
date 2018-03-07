library("dplyr")
library("ggplot2")
library("shiny")
library("tidyr")
library("DT")

tech.data <- read.csv('data/survey.csv', stringsAsFactors = FALSE) 
tech.df <- data.frame(tech.data)
View(tech.df)



# Define UI for application that draws a histogram
ui <- navbarPage(strong("Mental Health in Tech"),
  tabPanel("Introduction",
        wellPanel(
        h4(strong("Overview")),
        p("Mental health of tech workers is an important topic because...."),
        br(),
        
        h4(strong("Research")),
        p("In considering the topic of mental health of tech employees, we reviewed the following sources:"),
        
        p(em("World Health Organization's Report 'Mental Health and Work': Impact, Issues and Good Practices, 2000.")),
        p("This report highlights the fact that worlwide 5 of the 10 most frequent causes of disability result from mental health issues
          and that mental health problems are expected to increase in the future.  The negative effect of mental health on work productivity
          is very important and estimates show that 20% of working adults have some form of a mental health problem. (source)"),       
        
        p("ADD:info re: mental health for tech workers specifically"),
        br(),
        
        h4(strong("Dataset")),
        p("This analysis is based upon 2014 survey results from Open Sourcing Mental Illness.  
          This dataset includes responses from 1260 tech workers to 27 different questions about mental health. 
          The source states that this was the largest survey completed on the topic of tech workers and their mental health.
          Respondents from the U.S. make up the largest group of respondents by country (59.6%), of which the largest state
          participation is from California (18.5% ).  The data collected includes details about the respondents' work, 
          mental health history, and attitudes and experiences towards mental health and work.
          "),
        br(),
        
        
        h4(strong("Questions")),
        p("We focused our analysis of this dataset on the following questions:"),
        br(),
        p(em("How easy is it for you to take medical leave for a mental health condition?")),
        p("Analysis for all countries vs. individual countries with the highest response rate (U.S., United Kingdom, Canada, and Germany)"),
        # (info relating to importance of medical leave for mental health)
        br(),
        p(em("Lisa's question")),
        p("description of question")
  )
  ),
  tabPanel("Medical Leave",  
           sidebarLayout(  
             sidebarPanel(   
               
               # Left column - widgets
               
               # Widget 1: Radio buttons for choosing country
               helpText(em("Choose a Country to Compare")),  # Help text italicized
               radioButtons("countryInput", "Country",
                            choices = c("USA","United Kingdom","Canada","Germany")
               ),
               br(),
               br(),
               # Widget 2: Drop-down for choosing one of all possible responses
               helpText(em("Choose a Response to Compare")),  # Help text italicized
               selectInput(
                 "responseInput", 
                 "Response Data",
                  choices = c("Very Easy", "Somewhat Easy","Somewhat Difficult","Very Difficult","Don't Know")
               )            
            ),
            mainPanel(  
              tabsetPanel(
                tabPanel(
                  "Table",
                  br(),
                  br(),
                  h4("Data Table Analysis"),
                  h2("Selected Country vs. All Countries"),
                  tableOutput("table1")
                ),
                tabPanel(
                  "Plot",
                  br(),
                  h4("Bar Graph - Selected Country vs. All Countries"),
                  h2("Selected Country"),
                  plotOutput("plot1"),
                  br(),
                  h2("All Countries"),
                  plotOutput("plot2")
                  
                )
              )
            )
          )
           
    ),
    tabPanel("Lisa"),  
    
    navbarMenu("Documentation",  # drop-down menu from main menu
             tabPanel("Dataset",
              fluidRow(
              column(3, 
               img(src="OSMI.png", width = "75%")
                ),
              column(9,
                   h4(strong("Dataset Details")),
                   br(),
                   p("This work was based upon a dataset from Open Sourcing Mental Illness,"),
                   p("of their  2014 survey of tech workers on mental health topics, found at:"),
                   br(),
                   a(href="https://osmihelp.org/research",
                    "Open Source Mental Illness")
                        )
                      )
             ),
                      
                      
            tabPanel("References",
                     wellPanel(
                     h4(strong("References")),  
                      br(),
                      p("The following sources were used this presentation:"),
                      p("source1"),# enter sources for research on topic, and for each question.
                      p("source2"),
                      p("source3"),
                      p("source4")
                     )
            ),
                                  
            tabPanel("Team Info",
                     wellPanel(
                     h4(strong("Team Information")), # bold section title
                      br(),
                      p("Class: INFO201"),
                      br(),
                      p("Quarter: Winter 2018"),
                      br(),
                      p("Team Members: Nicole Kuhn, Lisa Qing")
                     )
            )
    )
)



server <- function(input, output) {

# total <- length(tech.df$leave)
# leave.very.easy <- filter(tech.df, leave == "Very easy"
# leave.somewhat.easy <- filter(tech.df, leave == "Somewhat easy"
# leave.somewhat.difficult <- filter(tech.df, leave == "Somewhat difficult"
# leave.very.difficult <- filter(tech.df, leave == "Very difficult")
# leave.dont.know <- filter(tech.df, leave == "Don't know")
# leave.rows <- c("Very Easy", "Somewhat Easy", "Somewhat Difficult", "Very Difficult", "Don't Know")
# leave.all.totals <- c(length(leave.very.easy$leave), length(leave.somewhat.easy$leave),
#     length(leave.somewhat.difficult$leave), length(leave.very.difficult$leave),
#     length(leave.dont.know$leave))  #total for each response
# percentage.all <- leave.all.totals / total *100  #percentage of all responses
# percentage.all.rounded <- round(percentage, digits = 1)
# 
# leave.df <- data.frame(Response = leave.rows, # Row names = each response
#   Total_All_Countries = leave.all.totals,  # all countries - totals
#   Percentage_All_Countries = percentage.all,  # all countries - percentage
#   Total_Country = leave.country.all.totals,  # selected country - totals
#   Percentage_Country = percentage.country)  # selected country - percentage
# View(leave.df)

  
# Selected Country Responses
  
country.answer <- reactive ({
  tech.df %>%
  filter(Country == input$countryInput) %>%
  filter(leave == input$responseInput)%>%
  length()
  return(country.answer)
})     

country.count <- reactive ({
  tech.df %>%
  filter(Country == input$countryInput) %>%
  length()
  return(country.count)
})
  
country.percent <- (country.answer() / country.count())*100 %>%
  round(country.percent, digits = 1)
View(country.percent)


# All Countries Responses 

all.countries.answer <- reactive ({
  tech.df %>%
  filter(leave == input$responseInput)%>%
  length()
  return(all.countries.answer)  
})

all.countries.count <- length(tech.df, Country)

all.countries.percent <- (all.countries.answer()/all.countries.count * 100) %>%
  round(all.countries.percent, digits = 1)
View(all.countries.percent)

# New Dataframe
leave.df <- data.frame(Country_total = country.answer(), Country_percent = country.percent,
                       All_total = all.countries.answer(), All_percent = all.countries.percent)

output$table1 <- renderTable({
  ## parameter?  leave.df
})
  
# Bar Chart
  

output$plot1 <- renderPlot ({
  ggplot(data = )
  
})

  # output$phonePlot <- renderPlot({
  #   
  #   # Render a barplot
  #   barplot(WorldPhones[,input$region]*1000, 
  #           main=input$region,
  #           ylab="Number of Telephones",
  #           xlab="Year")
  # })

})
  


# Run the application 
shinyApp(ui = ui, server = server)

