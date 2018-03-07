#install.packages("plotly")
#install.packages("maps")
library("dplyr")
library("ggplot2")
library("shiny")
library("tidyr")
library("plotly")

# latest as of Mar 7

# Define UI for application that draws a histogram
ui <- navbarPage("Mental Health in Tech",
  
  tabPanel("Introduction",
    wellPanel(
      h3(strong("Mental Health in the Tech Workplace")),
      br(),
      h4(strong("Overview")),
      # img(src="https://osmihelp.org", width = "50%", height = "50%"),
      p("Mental health of tech workers is an important topic because...."),
      br(),
      
      h4(strong("Current Research")),
      p("In considering the topic of mental health of tech employees, we reviewed the following sources:"),
      
      p(em("World Health Organization's Report 'Mental Health and Work': Impact, Issues and Good Practices, 2000.")),
      p("This report highlights the fact that worlwide 5 of the 10 most frequent causes of disability result from mental health issues
        and that mental health problems are expected to increase in the future.  The negative effect of mental health on work productivity
        is very important and estimates show that 20% of working adults have some form of a mental health problem. (source)"),       
      
      p("ADD:info re: mental health for tech workers specifically")
      )
      ),
  
  tabPanel("Dataset",
     sidebarLayout(  
     
       sidebarPanel(   
               
               h4(strong("Dataset")),
               br(),
               p("This project is based on a 2014 survey of tech workers on mental health topics conducted by Open Sourcing Mental Illness, found at:"),
               br(),
               img(src="OSMI.png", width = "75%"),
               br(),  
               br(),
               a(href="https://osmihelp.org/research",
                 "Open Source Mental Illness")
               
             ),
     
       mainPanel(  
         tabsetPanel(
           tabPanel(
             "Dataset", 
             br(),
             h4(strong("OMSI Dataset")),
             br(),
             p("explains and frames the data set for a specific target audience and usage."),
             p("introduce your data, cite its source, and otherwise structure how the user will approach your system."),
             
             p("This analysis is based upon 2014 survey results from Open Sourcing Mental Illness (OSMI). 
               OSMI is a non-profit orgnanization that was established in 2103 and works to raise awareness and provide education
               and resources to support mental wellness in the tech and open source communities (OSMI, n.d.)"),
             br(),  
             p("This dataset includes responses from 1260 tech workers to 27 different questions about mental health. 
               The source states that this was the largest survey completed on the topic of tech workers and their mental health.
               Respondents from the U.S. make up the largest group of respondents by country (59.6%), of which the largest state
               participation is from California (18.5% ).  The data collected includes details about mental health history, 
               and attitudes and experiences towards mental health and work.")
           ),
              
           tabPanel(
             "Survey Questions", 
             br(),
             h4(strong("Survey Overview")),
             br(),
             p("This 2014 survey was believed to be the largest survey at that time of attitudes towards mental health in the tech workplace.
               There were 1400 total responses from over 48 countries to the following questions.  The survey was administered online and completed voluntarily???:"),
             br(),
             h4(strong("Survey Questions")),
             br(),
             p("This survey contained the following questions:"),
             br(),
             p("1. Age"),
             p("2. Gender"),
             p("3. Country: "),
             p("4. State: If you live in the United States, which state or territory do you live in?"),
             p("5. Self Employed: Are you self-employed?"),
             p("6. Family History: Do you have a family history of mental illness?"),
             p("7. Treatment: Have you sought treatment for a mental health condition?"),
             p("8. Work Interference: If you have a mental health condition, do you feel that it interferes with your work?"),
             p("9. Number of Employees: How many employees does your company or organization have?"),
             p("10. Remote Work: Do you work remotely (outside of an office) at least 50% of the time?"),
             p("11. Tech Company: Is your employer primarily a tech company/organization?"),
             p("12. Benefits: Does your employer provide mental health benefits?"),
             p("13. Care Options: Do you know the options for mental health care your employer provides?"),
             p("14. Wellness Program: Has your employer ever discussed mental health as part of an employee wellness program?"),
             p("15. Seek Help: Does your employer provide resources to learn more about mental health issues and how to seek help?"),
             p("16. Anonymity: Is your anonymity protected if you choose to take advantage of mental health or substance abuse treatment resources?"),
             p("17. Leave: How easy is it for you to take medical leave for a mental health condition?"),
             p("18. Mental Health Consequence: Do you think that discussing a mental health issue with your employer would have negative consequences?"),
             p("19. Physical Health Consequence: Do you think that discussing a physical health issue with your employer would have negative consequences?"),
             p("20. Coworkers: Would you be willing to discuss a mental health issue with your coworkers?"),
             p("21. Supervisor: Would you be willing to discuss a mental health issue with your direct supervisor(s)?"),
             p("22. Mental Health in Interviews: Would you bring up a mental health issue with a potential employer in an interview?"),
             p("23. Physical Health in Interview: Would you bring up a physical health issue with a potential employer in an interview?"),
             p("24. Mental vs Physical: Do you feel that your employer takes mental health as seriously as physical health?"),
             p("25. Observed Consequence: Have you heard of or observed negative consequences for coworkers with mental health conditions in your workplace?"),
             p("26. Comments: Any additional notes or comments")
           ),
           
           tabPanel(
             "Analysis Questions", 
             br(),
             h4(strong("Questions Considered for Our Analysis")),
             br(),
             p("We focused our analysis of this dataset on the following questions:"),
             br(),
             hr(),
             br(),
             p(strong("Tab: Seeking Help & Care Options")),
             br(),
             p("For this section of our analysis, we considered responses to the following survey questions:"),
             p(em("1. Age")),
             p(em("3. Country")),
             p(em("13. Care Options: Do you know the options for mental health care your employer provides?")),
             p(em("15. Seek Help: Does your employer provide resources to learn more about mental health issues and how to seek help?")),
             br(),
             hr(),
             br(),
             p(strong("Tab: Work Interference & Medical Leave")),
             br(),
             p("For this section of our analysis, we considered responses to the following survey questions:"),
             p(em("1. Age")),
             p(em("3. Country")),
             p(em("8. Work Interference: If you have a mental health condition, do you feel that it interferes with your work?")),
             p(em("17. Leave: How easy is it for you to take medical leave for a mental health condition?")),
             br(),
             hr()
           )
         ) 
       )
 )
),

  tabPanel("Seeking Help & Care Options", 
  sidebarLayout(  
    sidebarPanel(
     h3(strong("Seeking Help & Care Options")),
     br(),
     h4("Overview"),
     br(),
     p("Overview of Analysis")
     
    ), 
    mainPanel(
     tabsetPanel(
       tabPanel("World Wide Info", 
          br(), 
          h4("World Wide Trends Plots"), 
          plotlyOutput("scatter"), 
          br(),
          p("The above scatterplot shows the average age of respondents in each
            country as well as whether the respondents have seeked help in the past.
            In the survey, individuals sometimes put 'Not sure' and that was 
            interpretted as no help seeked. The size of the dot depends on the number of respondents
            that responded in that certain way of that country."), 
          br(),
          plotlyOutput("bar"), 
          br(), 
          p("The bar graph shows in detail the TOTAL number of 
                                       respondents who have not seeked help and have. For a 
                                       better breakdown the respondents who said 'Not sure' are
                                       shown as well."), 
          br(),
          tableOutput("table"), br(), 
          p("The table shows a breakdown on where all the data came from.")),
       
       tabPanel("United States", 
          br(), 
          plotlyOutput("us_scatter"), br(), br(), 
          plotlyOutput("us_bar")),
       
       tabPanel("Countries", 
          br(), 
          h4("Specific Country Age v. Company Offering Care Options"), 
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
    
    )),  

  tabPanel("Work Interference & Medical Leave",  
           sidebarLayout(  
             sidebarPanel(   
               
               h3(strong("Work Interference & Medical Leave")),
               br(),
               h4("Overview"),
               br(),
               p("give Overview of Analysis")
              
               
               # Widget 1: Radio buttons for choosing country
               # helpText(em("Choose a country to view its results")),  # Help text italicized
               # radioButtons("countryInput", "Country",
               #              choices = c("USA","United Kingdom","Canada","Germany")
               # ),
               # 
               # Widget 2: Drop-down for choosing one of all possible responses
               #helpText(em("View Totals for each Survey Response")),  # Help text italicized
               
                 
             ),
             mainPanel(  
               tabsetPanel(
                 tabPanel(
                   "Scatterplot", 
                   
                   br(),
                   h4(strong("Work Interference by Age & Ability to take Medical Leave")),
                   br(),
                   p("intro paragraph"),
                   p("instructions"),
                   br(), 
                   hr(),
                   br(),
                   h4("Country Data"),
                   br(),
                   p("Instructions - info on top 4 countries"),
                   br(),
                   selectInput(
                     "country_leave", 
                     "Select a Country",
                     choices = c("United States", "United Kingdom", "Canada", "Germany", "Australia", "Austria", 
                                 "Bahamas", "Belgium", "Bosnia and Herzegovina", "Brazil", "Bulgaria", "China", 
                                 "Colombia", "Costa Rica", "Croatia", "Czech Republic", "Denmark", "Finland", 
                                 "France", "Georgia", "Greece", "Hungary", "India", "Ireland", "Israel", "Italy", 
                                 "Japan", "Latvia", "Mexico", "Moldova", "Netherlands", "New Zealand", "Nigeria", 
                                 "Norway", "Philippines", "Poland", "Portugal", "Romania", "Russia", "Singapore", 
                                 "Slovenia", "South Africa", "Spain", "Sweden", "Switzerland", "Thailand", "Uruguay")
                   ),    
                   br(),
                   br(),
                   plotlyOutput("scatter_leave"),
                   br(),
                   hr(),
                   br(),
                   h4("Worldwide Data"),
                   br(),
                   p("Instructions - no options, static"),
                   br(),
                   plotlyOutput("scatter_leave_world"),
                   br(),
                   hr()
                 ),
                 tabPanel(
                   "Bar Graph",
                   
                   br(),
                   h4(strong("Work Interference & Ability to take Mental Health Leave")),
                   br(),
                   p("intro"),
                   br(),
                   hr(),
                   br(),
                   h4("Country Data"),
                   p("intro for country selected"),
                   br(),
                   p("Instructions - info on top 4 countries"),
                   br(),
                   selectInput(
                     "country_leave2", 
                     "Select a Country",
                     choices = c("United States", "United Kingdom", "Canada", "Germany", "Australia", "Austria", 
                                 "Bahamas", "Belgium", "Bosnia and Herzegovina", "Brazil", "Bulgaria", "China", 
                                 "Colombia", "Costa Rica", "Croatia", "Czech Republic", "Denmark", "Finland", 
                                 "France", "Georgia", "Greece", "Hungary", "India", "Ireland", "Israel", "Italy", 
                                 "Japan", "Latvia", "Mexico", "Moldova", "Netherlands", "New Zealand", "Nigeria", 
                                 "Norway", "Philippines", "Poland", "Portugal", "Romania", "Russia", "Singapore", 
                                 "Slovenia", "South Africa", "Spain", "Sweden", "Switzerland", "Thailand", "Uruguay")
                   ),    
                   br(),
                   plotlyOutput("bar_leave1"),
                   br(),
                   hr(),
                   br(),
                   h4("Worldwide Data"),
                   p("intro for country selected"),
                   br(),
                   plotlyOutput("bar_leave2"),
                   hr()
                 )
               )
             )
           )
           
  ),  
  
tabPanel("Conclusions",
         p("conclusions go here")
),
         
         
  navbarMenu("Documentation",  # drop-down menu from main menu
    
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

