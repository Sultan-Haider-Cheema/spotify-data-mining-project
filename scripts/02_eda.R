# Load libraries
library(tidyverse)

# Load dataset
spotify_data <- read.csv("data/spotify.csv")
# Genre Distribution
# -------------------------

# Table
table(spotify_data$playlist_genre)

# Plot
ggplot(spotify_data, aes(x = playlist_genre)) +
  geom_bar() +
  theme_minimal() +
  ggtitle("Distribution of Playlist Genres")
ggsave("output/genre_distribution.png", width = 6, height = 4)

# Popularity distribution
ggplot(spotify_data, aes(x = track_popularity)) +
  geom_histogram(bins = 30) +
  theme_minimal() +
  ggtitle("Distribution of Track Popularity")
ggsave("output/popularity_distribution.png", width = 6, height = 4)

# danceability vs popularity
ggplot(spotify_data, aes(x = danceability, y = track_popularity)) +
  geom_point(alpha = 0.3) +
  theme_minimal() +
  ggtitle("Danceability vs Popularity")
ggsave("output/danceability_vs_popularity.png", width = 6, height = 4)

# Select numeric columns only
numeric_data <- spotify_data %>%
  select(where(is.numeric))

cor_matrix <- cor(numeric_data)

library(corrplot)

corrplot(cor_matrix, method = "color", tl.cex = 0.7)

png("output/correlation_matrix.png", width = 800, height = 600)
corrplot(cor_matrix, method = "color", tl.cex = 0.7)
dev.off()

