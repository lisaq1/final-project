library("dplyr")
library("ggplot2")
library("shiny")
library("tidyr")
library("plotly")


# Define UI for application that draws a histogram
ui <- fluidPage( 
  navbarPage("Mental Health in Tech",
             tabPanel("Introduction",
                      mainPanel(
                        h3(strong("Mental Health in the Tech Workplace")),
                        br(),
                        p("The tech industry is rapidly growing and, as of 2017, there were about 7 million workers in this sector in the U.S. 
                          and it contributes to 8 percent of the total U.S. economy (US Tech Sector, 2017). This growth is often perceived as positive news, 
                          however, as one contributor to an online technology magazine writes, the culture in tech workplaces can be 'ruthless' and it is 
                          very difficult to safely discuss mental health issues in this industry (Nguyen, 2016).
                          The World Health Organization's Report 'Mental Health and Work: Impact, Issues and Good Practices' reports that the negative effect of 
                          mental health on work productivity is critically important to understand and estimates that 20% of working adults have some form of a 
                          mental health problem.  This report also highlights that worlwide 5 of the 10 most frequent causes of disability result from mental health issues
                          and that mental health problems are expected to increase in the future (World Health Organization, 2000)."),       
                        
                        p("This is an important conversation, not only in the U.S., but also globally as the use of technology increases and the technology workforces 
                          continues to expand everywhere. In this presentation, we seek to present and analyze the results from a 2014 survey that gathers information 
                          on mental health in the tech workplace."),
                        br(),
                        plotOutput("worldMap"),
                        p(em("The map above illustrates which countries the survey respondents are from. As seen above, much of the data comes from workers in 
                             United States, however, respondents are from all around the world (the black areas represent the parts of the world in which
                             the survey was NOT conducted."))
                        
                        
                             )
                        ),
             tabPanel("Dataset",
                      sidebarLayout(  
                        
                        sidebarPanel(   
                          
                          h4(strong("Source")),
                          br(),
                          p("This project is based on a 2014 survey of tech workers on mental health topics conducted by Open Sourcing Mental Illness, found at:"),
                          # img(src="OSMI.png", width = "75%"),
                          p(a(href="https://osmihelp.org/research",
                              "Open Source Mental Illness")),
                          a("Kaggle Data", href = "kaggle.com/osmi/mental-health-in-tech-survey")
                          
                        ),
                        mainPanel(  
                          tabsetPanel(
                            tabPanel(
                              "Dataset", 
                              br(),
                              h4(strong("OMSI Dataset")),
                              br(),
                              p("This analysis is based upon 2014 survey results from Open Sourcing Mental Illness (OSMI). 
                                OSMI is a non-profit organization that was established in 2103 and works to raise awareness and provide education
                                and resources to support mental wellness in the tech and open source communities."),
                              br(),  
                              p("The data collected includes details about mental health history, and attitudes and experiences 
                                towards mental health and work."),
                              br(),
                              p("This dataset includes responses from 1260 tech workers from 48 different countries. 
                                The source states that this was the largest survey completed on the topic of tech workers and their mental health."),
                              br(),
                              p("Respondents from the U.S. make up the largest group of respondents by country (59.6%), of which the largest state
                                participation is from California (18.5% ).  The highest number of respondents come from the U.S., United Kingdom, 
                                Canada, and Germany.")
                              ), 
                            tabPanel(
                              "Survey Questions", 
                              br(),
                              h4(strong("Survey Overview")),
                              br(),
                              p("This 2014 survey was believed to be the largest survey at that time regarding attitudes towards mental health in the tech workplace.
                                Responses were received for 27 different questions:"),
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
                              h5(em("Audience:")),
                              br(),
                              p("Our analysis is important for anyone trying to better understand tech workers and their mental health.  
                                This includes tech workers themselves, along with those working with and supporting tech workers such as
                                managers and human resource employees.  As this industry continues to grow, so does the need to better understand 
                                and support the mental health of these tech employees."),
                              br(),
                              p("We focused our analysis of this dataset on the following questions:"),
                              br(),
                              p(strong("Tab: Seeking Help & Care Options")),
                              br(),
                              h5(em("Question: Is there a correlation between those who seek mental health and their age? And how do company 
                                    care options play a role?")),
                              p("The analysis focuses on all the data collected in all the countries in which the survey was conducted. However, as a majority of
                                the data came from the United States, another focus of the question is on the trend it has within the states."),
                              p("For this section of our analysis, we considered responses to the following survey questions:"),
                              p(em("1. Age")),
                              p(em("3. Country")),
                              p(em("13. Care Options: Do you know the options for mental health care your employer provides?")),
                              p(em("15. Seek Help: Does your employer provide resources to learn more about mental health issues and how to seek help?
                                   (And have you seeked help in the past?)")),
                              br(),
                              hr(),
                              br(),
                              p(strong("Tab: Work Interference & Medical Leave")),
                              br(),
                              h5(em("Question: Does a mental health condition interfere with your work and how easy is it for you to take leave for a mental health condition?")),
                              p("The analysis provides data for all countries and the U.S."),
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
             tabPanel("Seeking Help & Care Options", sidebarLayout(  
               sidebarPanel(   
                 h3(strong("Trends in Seeking Help with Age and Company Offered Care Options")), 
                 br(),
                 p("The interactive graphs to the right depict the the relationship between the age of the respondents and their past
                   history of seeking help as well as what influence clearly iterated company offered care options have has. A majority of the 
                   data is from the United States as it was most widely distributed there. So a bulk of the analysis made is skewed 
                   towards the results founded in the US. The first tab creates a general overview of what data was collected. 
                   The second tab will illustrate the results specifically in the US by the state in which the respondent is from. 
                   The third tab focuses on each individual country (upon selection)."), 
                 br(),
                 h3("Question: "),
                 p(em("Is there a correlation between those who seek mental health and their age? And how do company 
                      care options play a role?")),
                 br(),
                 h4("General Conclusion:"),
                 p("As stated earlier, the survey was not distributed evenly across locations, so the results may not be representative in
                   the end; however from the data gathered, these are the results found."),
                 br(),
                 p("From the data, generally, age has little influence on seeking help. However, in some countries, the U.S. specifically, 
                   there seems to be a direct relationship as the younger the employee is the less likely they will seek help. Looking at 
                   all the countries, a majority of respondents replied with they had never seeked help for mental health in the past (for 
                   the purpose of analysis, the individuals that answered not sure were placed under the category of no help seeked). Diving 
                   deeper, the relationship between companies offering health care options were compared to individuals seeking health. From 
                   this there is a more obvious correlation - though a majority of respondents have no seeked mental health help, there is an
                   increase in those who do when their employer offers health care."),
                 br(),
                 p(em("How this data can be used: ")),
                 p("This information could be potentianlly useful for employers and those seeking jobs in the near future. Employers may use
                   this data to recognize that primarily older prospective employees may have company care options as a top priority when 
                   looking for jobs whereas younger employees may not think as much regarding company care options (mainly in the US, this trend
                   is prevalent).")
                 ), 
               mainPanel(
                 tabsetPanel(tabPanel("World Wide Info", 
                                      br(), 
                                      h3("World Wide Trend Plots"), 
                                      plotlyOutput("scatter"), 
                                      br(),
                                      fluidRow(checkboxInput("checkbox1", label = "Display Scatter Plot Data", value = FALSE)),
                                      p("The above scatterplot shows the average age of respondents in each country as well as whether the 
                                        respondents have seeked help in the past. In the survey, individuals sometimes put 'Not sure' and that was 
                                        interpretted as no help seeked. The size of the dot depends on the number of respondents
                                        that responded in that certain way of that country. As seen in the data, the United States
                                        had the most number of respondents and of this, 561 people said no and 187 people said yes
                                        to have had seeked help/employers have informed them of how to. The other countries did not 
                                        have as many data points; however, it can still be seen that many respondents replied with
                                        no to the question of seeking help. From this scatter plot, It is not entirely clear if age
                                        has a correlation with seeking help, but that could potentially be due little collected data
                                        in each specific country (unlike in the US data where there is a clear relationship)."), 
                                      tableOutput("scatterWorld"),
                                      br(),
                                      plotlyOutput("bar"), 
                                      br(), 
                                      fluidRow(checkboxInput("checkbox2", label = "Display Bar Graph Data", value = FALSE)), 
                                      p("The bar graph shows in detail the TOTAL number of respondents who have not seeked help and have. 
                                        For a better breakdown the respondents, those who replied 'Not sure' are shown as well. From 
                                        the bar graph, it can be seen that when health care options are clearly iterated to the employees,
                                        the number of those who have seeked health increased significantly (167 respondents replied with yes)
                                        to those who were not or unsure. As seen in the scatterplot the US had the most number of 
                                        respondents to the survey, so this bar graph is in fact skewed towards the US respondents answers."), 
                                      br(),
                                      tableOutput("barWorld")),
                             tabPanel("United States", 
                                      br(), 
                                      plotlyOutput("us_scatter"), 
                                      fluidRow(checkboxInput("checkbox3", label = "Display Scatter Plot Data", value = FALSE)),
                                      p("This scatter plot shows the correlation of age with seeking help. More older individuals responded
                                        to the survey with yes to seeking help. While more younger individuals responded to the survey with
                                        no/unsure of seeking help (like the first tab scatter plot those unsure of seeking help or have not
                                        were grouped in the same category for the purpose of analysis). The most respondents came from California,
                                        (95 replied no/unsure - ave age: 31.8 y.o. , and 43 replied yes - ave age: 36.1 y.o.). Many of the
                                        other states also show this trend."),
                                      tableOutput("scatterUS"),
                                      br(),
                                      plotlyOutput("us_bar"),
                                      br(), br(), br(), br(),
                                      fluidRow(checkboxInput("checkbox4", label = "Display Bar Graph Data", value = FALSE)),
                                      p(em("Side Note: same as the bar graph in the first tab, the data was separated (no's and unsure's) to
                                           better recognize the relationships between the two seeking help and offered care")),
                                      p("As expected, those without clear information on if their respective companies had health care options,
                                        have not seeked help. However, when the respondents were clearly informed, those who have seeked help
                                        made a significant jump (from 33 (not informed) and 26 (unsure) to 128 (informed)."), 
                                      tableOutput("barUS")),
                             tabPanel("Countries", 
                                      br(), 
                                      h4("Specific Country Age v. Company Offering Care Options"), 
                                      fluidRow(helpText("Select a country of interest (the first four countries have more documented 
                                                        data than others - the United States (second tab), United Kingdom, Canada, and Germany consist 
                                                        a majority of the data)"), 
                                               selectInput("place", "Country of Interest",
                                                           c("United Kingdom", "Canada", "Germany", "Australia", "Austria", 
                                                             "Bahamas", "Belgium", "Bosnia and Herzegovina", "Brazil", "Bulgaria", "China", 
                                                             "Colombia", "Costa Rica", "Croatia", "Czech Republic", "Denmark", "Finland", 
                                                             "France", "Georgia", "Greece", "Hungary", "India", "Ireland", "Israel", "Italy", 
                                                             "Japan", "Latvia", "Mexico", "Moldova", "Netherlands", "New Zealand", "Nigeria", 
                                                             "Norway", "Philippines", "Poland", "Portugal", "Romania", "Russia", "Singapore", 
                                                             "Slovenia", "South Africa", "Spain", "Sweden", "Switzerland", "Thailand", "Uruguay")), 
                                               plotlyOutput("scatter_spec")),
                                      br(),
                                      p("The above plot shows the data on the selected country. In general, age only shows to have a relationship
                                        with seeking help in certain countries particularly those with more data points (i.e. the US, United Kingdom). 
                                        The United Kingdom also showed a similar trend to the US (tab 2) in younger individuals were less likely to seek help;
                                        however, the trend is not as obvious (may be due to less data). Germany actually showed a different result as 
                                        older individuals were less likely to to seek help even after being notified of care options. Many of the 
                                        other countries only had few surveys collected, so some trends are unrecognizable and most likely inaccurate
                                        of that country -- just something to keep in mind.")
                                      )
                                      )
                                      )
                                      )
                                      ),
             tabPanel("Work Interference & Medical Leave",  
                      sidebarLayout(  
                        sidebarPanel(   
                          
                          h3(strong("Trends in Work Interference by Age & Medical Leave")),
                          br(),
                          h4("Overview"),
                          br(),
                          p("The interactive graphs to the right depict the the relationship between the age of the respondents and, if they
                            have a mental health condition, to what degree it interferes with their work, along with the respondents' perceived ability 
                            to take medical leave for a mental health condition."),
                          
                          p("The first tab titled 'Country & World' contains 3 plots.
                            The first plot allows the user to choose a country to view its data.
                            The second plot provides worldwide data for comparison.
                            The third plot provides a bar graph illustrating a country view in-depth for 
                            viewing work interference and ability to take medical leave."),
                          
                          
                          p("The second tab titled 'United States' provides this same analysis for the U.S. 
                            The majority of responses in this dataset come from tech workers in the United States.
                            Because of this, we offer an additional analysis of this data for the U.S. with 2 plots.
                            The first is a scatterplot, showing work interference by age.  
                            The second plot is a bar chart that shows work interference by leave difficulty."),
                          br(),
                          h4("Analysis"),
                          br(), 
                          p("From the data, we can see that a large number of respondents felt that a mental health
                            condition interfered with their work sometimes, but many of them didn't know how hard it would 
                            be to take medical leave for mental health.
                            Worldwide, those who never felt a mental health disorder interfered with their work more often
                            believed it was very easy or somewhat easy to take mental health leave.
                            In the U.S., the younger 25-35 year olds more often thought it was somewhat easy to take mental health leave,
                            whereas those who thought it was very difficult tend to be older."),
                          br(),
                          p(em("How this data can be used:")),
                          p("This information can be useful to tech workers themselves, along with supervisors and human
                            resource managers.  With the high number of employees responding that a mental health disorder 
                            interferes with their work sometimes, and a very high number of employees responding that they don't know
                            if it is easy to take medical leave for a mental health condition, this data illustrates the high need for 
                            help and education about leave.")
                          
                          ),                            
                        mainPanel(  
                          tabsetPanel(
                            tabPanel(
                              "Country & World", 
                              
                              br(),
                              h4(strong("Work Interference by Age & Ability to take Medical Leave")),
                              br(),
                              p("The following provides a visual analysis of chosen country and worldwide data for level of work interference for a mental health condition by age,
                                along with the ability of the worker to take medical leave for a mental health issue."),
                              br(), 
                              hr(),
                              br(),
                              h4("Country Data"),
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
                              plotlyOutput("scatter_leave_world"),
                              br(),
                              hr(),
                              br(),
                              # plotlyOutput("world_bar_leave"),
                              plotlyOutput("bar_leave2"),
                              hr(),
                              br()
                              ),
                            tabPanel(
                              "United States",
                              
                              br(),
                              h4(strong("Work Interference & Ability to take Mental Health Leave")),
                              br(),
                              p("The following provides a visual analysis of U.S. data for level of work interference for a mental health condition by age,
                                along with the ability of the worker to take medical leave for a mental health issue."),
                              br(),
                              hr(),
                              br(),
                              plotlyOutput("us_leave1"),
                              br(),
                              hr(),
                              br(),
                              plotlyOutput("bar_leave1"),
                              br(),
                              hr()
                              )
                          )
                        )
                        
                          )
                      
                          ),  
             
             tabPanel("Conclusion",
                      wellPanel(
                        br(),
                        h4(strong("Conclusion")),
                        br(),
                        p("We know that the tech industry is growing and will rely on increasing numbers of tech employees throughout the world.  
                          We can see from the survey dataset and this analysis that there are a number of important questions to ask about how 
                          mental health issues are handled in the tech industry."),
                        p("We see from our analysis on seeking help and care options that it appears that younger workers are less likely to seek help 
                          for mental health conditions.  We also see that there is an increase in employees seeking help when their
                          employees offers health care."),
                        p("Shown through our analysis on work interference is the high number of employees have felt that a mental
                          health condition has interfered with their work at least sometimes.  Unfortunately, however, many of the respondents do not 
                          know if they can easily take medical leave for a mental health issue."),
                        p("This analysis illustrates that there is a need for more information and support for tech employees to understand and seek out help
                          in their workplace for mental health conditions.  It is a concern not only for the individual who needs guidance and support, but also for our 
                          country and other countries as the number of tech workers and the prevalence of mental health issues both continue to grow worldwide."),
                        br()
                        )
                        ),
             
             navbarMenu("Documentation",  # drop-down menu from main menu
                        
                        tabPanel("References",
                                 wellPanel(
                                   h4(strong("References")),  
                                   br(),
                                   p("The following sources were used this presentation:"),
                                   br(),
                                   p("The Data:"),
                                   p(a("Kaggle Link", href = "https://www.kaggle.com/osmi/mental-health-in-tech-survey")),
                                   p("Open Source Mental Illness (OSMI) [Group that conducted the survey]:"),
                                   p(a("Open Source Mental Illness Link", href = "https://osmihelp.org/research/")),
                                   br(),
                                   p("'Are You More Than Okay: The State of Mental Health in Tech in 2016'. Nguyen, Julia. Dec 2016. Model View Culture, 
                                     Retrieved from: https://modelviewculture.com/pieces/are-you-more-than-okay-the-state-of-mental-health-in-tech-in-2016"),
                                   br(),
                                   p("'Mental Health and Work': Impact, Issues and Good Practices'. World Health Organization. 2000, Retrieved from:
                                     http://www.who.int/mental_health/media/en/712.pdf"),
                                   br(),
                                   p("'U.S. Tech Sector Employment Approaches Seven Million.' Comptia.org. April 2017.  Retrieved from:  
                                     https://www.comptia.org/about-us/newsroom/press-releases/2017/04/03/us-tech-sector-employment-approaches-seven-million"),
                                   br(),
                                   p(em("The following reports were used to better understand how the data was collected")),
                                   p("Basic Report of 2016 Survey from OSMI:"),
                                   p(a("2016 Report", href = "https://osmi.typeform.com/report/Ao6BTw/U76z")),
                                   p("Basic Report of 2014 Survey from OSMI:"),
                                   p(a("2014 Report", href = "https://docs.google.com/forms/d/1FqpxZXORRNDQ4niSeqLx0Qy2VfUod_qlAvpnOyTEB9k/viewanalytics")),
                                   br()
                                   
                                   ),
                                 mainPanel(
                                   h4(strong("Techinical Description")),
                                   h5("Libraries Used"),
                                   p("To create the visual representations we used shiny , plotly , ggplot2, and maps.
                                     For the in depth data manipulation we used dplyr."),
                                   p(em("List of library links:")),
                                   p(a("shiny", href = "http://shiny.rstudio.com/", target = "shiny")),
                                   p(a("plotly", href = "https://plot.ly/r/", target = "plotly")),
                                   p(a("ggplot2", href = "https://www.statmethods.net/advgraphs/ggplot2.html", target = "ggplot2")),
                                   p(a("maps", href = "https://cran.r-project.org/web/packages/maps/maps.pdf", target = "maps")),
                                   p(a("dplyr", href = "https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html", taget = "dplyr"))
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
             )