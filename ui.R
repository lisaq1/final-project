library("shiny")

my.ui <- fluidPage(
  sidebarPanel(
    selectInput("place", "Country of Interest", 
                c("Australia", "Austria", "Bahamas", "Belgium", "Bosnia and Herzegovina",
                  "Brazil", "Bulgaria", "Canada", "China", "Colombia", "Costa Rica", "Croatia",
                  "Czech Republic", "Denmark", "Finland", "France", "Georgia", "Germany",
                  "Greece", "Hungary", "India", "Ireland", "Israel", "Italy", "Japan", "Latvia",
                  "Mexico", "Moldova", "Netherlands", "New Zealand", "Nigeria", "Norway",
                  "Philippines", "Poland", "Portugal", "Romania", "Russia", "Singapore", "Slovenia",
                  "South Africa", "Spain", "Sweden", "Switzerland", "Thailand", "United Kingdom",
                  "United States", "Uruguay"))
  ), 
  mainPanel(
    p("display"),
    tabsetPanel(tabPanel("table", plotOutput("table")))
  )
)
