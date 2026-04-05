library(tidyverse)

spotify_data <- read.csv("data/spotify.csv")

spotify_clean <- spotify_data %>%
  select(-track_id,
         -track_name,
         -track_artist,
         -track_album_name,
         -track_album_id,
         -playlist_name,
         -playlist_id,
         -playlist_subgenre)

str(spotify_clean)
summary(spotify_clean)

spotify_clean$playlist_genre <- as.factor(spotify_clean$playlist_genre)
numeric_cols <- sapply(spotify_clean, is.numeric)

spotify_clean[numeric_cols] <- scale(spotify_clean[numeric_cols])

write.csv(spotify_clean, "data/spotify_clean.csv", row.names = FALSE)