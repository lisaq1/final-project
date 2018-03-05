# Unzipping and reading the zip file downloaded from Kaggle
# https://www.kaggle.com/osmi/mental-health-in-tech-survey

getFile <- function(){
  file <- unzip("mental-health-in-tech-survey.zip")
  df <- read.csv(file, stringsAsFactors = FALSE)
  return(df)
}