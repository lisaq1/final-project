# Unzipping and reading the zip file downloaded from Kaggle
# https://www.kaggle.com/osmi/mental-health-in-tech-survey

file <- unzip("mental-health-in-tech-survey.zip")
df <- read.csv(file)
View(df)