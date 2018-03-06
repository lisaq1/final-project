library("dplyr")
library("ggplot2")
library("shiny")
library("tidyr")
library("DT")


# Define UI for application that draws a histogram
ui <- navbarPage("Mental Health in Tech",
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
               helpText(em("Choose a country to view its results")),  # Help text italicized
               radioButtons("countryInput", "Country",
                            choices = c("USA","United Kingdom","Canada","Germany")
               ),
            
               # Widget 2: Drop-down for choosing one of all possible responses
               helpText(em("View Totals for each Survey Response")),  # Help text italicized
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
                  h4("Table of Responses - All Countries vs. Chosen Country"),
                  tableOutput("table1")
                ),
                tabPanel(
                  "Plot",
                  h4("Selected Response for Chosen Country"),
                  plotOutput("plot1")
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
                      p("Quarter: Winter 2018"),
                      p("Team Members: Nicole Kuhn, Lisa Qing")
                     )
            )
    )
)

