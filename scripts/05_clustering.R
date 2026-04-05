library(tidyverse)
library(factoextra)

# Load cleaned (scaled) data
spotify_clean <- read.csv("data/spotify_clean.csv")

# Select only numeric features (exclude target genre)
numeric_data <- spotify_clean %>%
  select(where(is.numeric))

numeric_data <- na.omit(numeric_data)

# Note: data is already scaled from 03_preprocessing.R
# If running standalone, uncomment the line below:
# numeric_data <- scale(numeric_data)

#Step 1: Elbow method to choose k 
t_elbow <- system.time({
  p_elbow <- fviz_nbclust(numeric_data, kmeans, method = "wss",
                          k.max = 10, nstart = 3, iter.max = 50)
})

print(p_elbow)
ggsave("output/elbow_plot.png", plot = p_elbow, width = 6, height = 4)
cat("Elbow plot time:", t_elbow["elapsed"], "seconds\n")

# Step 2: Fit K-means with k = 6
set.seed(123)
t_kmeans <- system.time({
  kmeans_model <- kmeans(numeric_data, centers = 6, nstart = 25, iter.max = 100)
})

cat("K-means (k=6) time:", t_kmeans["elapsed"], "seconds\n")

# Step 3: Visualise clusters
p_kmeans <- fviz_cluster(kmeans_model, data = numeric_data,
                         geom = "point", alpha = 0.4,
                         ggtheme = theme_minimal()) +
  ggtitle("K-means Clusters (k=6)")

print(p_kmeans)
ggsave("output/kmeans_clusters.png", plot = p_kmeans, width = 6, height = 4)

# Step 4: Inspect cluster centres
cat("\nCluster centres (standardised features):\n")
print(round(kmeans_model$centers, 3))

cat("\nCluster sizes:\n")
print(kmeans_model$size)

cat("\nTotal within-cluster SS:", round(kmeans_model$tot.withinss, 1), "\n")
