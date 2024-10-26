#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

# Filter and refine polling data to ensure high-quality and reliable insights
# This involves focusing on polls where the 'partisan' value is missing (indicating no background support) 
# and prioritizing those with positive 'pollscore' values, which reflect better polling accuracy and reliability

# Filter the data where 'partisan' is NA and 'pollscore' > 0
target_data <- raw_data %>%
  filter(is.na(partisan) & pollscore > 0)

# Display the dimensions and a preview of the filtered data
dim(target_data)
head(target_data)

# Count the number of Positive Pollscore (> 0) with partisan = NA
positive_pollscore_count <- nrow(target_data)
positive_pollscore_count # Displays the count

#### Save the filtered data ####
write_csv(target_data, "data/02-analysis_data/analysis_data.csv")

