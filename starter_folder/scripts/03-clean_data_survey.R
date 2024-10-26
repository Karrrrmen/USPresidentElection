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

# We defined high-quality data based on its poll frequency and numbers of null values
# The higher poll frequency means higher data quality; the less numbers of null
# values means higher data quality because it contains highly-completed data
high_pollers <- raw_data %>%
  count(pollster, sort = TRUE) %>%
  top_n(5, n) %>%
  pull(pollster)

cleaned_data <- raw_data %>%
  # Filter the raw data to top 5 most frequent pollster names
  filter(pollster %in% high_pollers) %>%
  # Remove the completely empty rows
  select(where(~ any(!is.na(.)))) 

missing_values_summary <- cleaned_data %>%
  group_by(pollster) %>%
  summarize(
    # Missing number of variables across all columns for each pollster
    missing_count = sum(is.na(across(everything()))),
    # Total number of variables for each pollster
    total_count = n() * ncol(cleaned_data),
    .groups = 'drop'
  ) %>%
  # (Missing # of variables / total # of variables) ratio for each pollster
  mutate(missing_ratio = missing_count / total_count) %>%
  arrange(missing_ratio)

least_ratio <- missing_values_summary %>%
  slice(1) %>%
  pull(pollster)


cleaned_data <- cleaned_data %>%
  filter(pollster == least_ratio)


#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/survey_data.csv")
