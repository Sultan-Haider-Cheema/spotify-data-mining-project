# Clear environment
rm(list = ls())

# Set working directory (automatic in RStudio project)
getwd()

# Load library
library(tidyverse)

# Load dataset
spotify_data <- read.csv("data/spotify.csv")

# View first rows
head(spotify_data)

# Check structure
str(spotify_data)

# Summary
summary(spotify_data)
