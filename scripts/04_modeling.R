library(tidyverse)
library(caret)
library(rpart)
library(rpart.plot)

# Load cleaned data
spotify_clean <- read.csv("data/spotify_clean.csv")

# Convert target to factor
spotify_clean$playlist_genre <- as.factor(spotify_clean$playlist_genre)

set.seed(123)

train_index <- createDataPartition(spotify_clean$playlist_genre, p = 0.8, list = FALSE)

train_data <- spotify_clean[train_index, ]
test_data  <- spotify_clean[-train_index, ]
# train Decission tree
model_dt <- rpart(
  playlist_genre ~ danceability + energy + loudness + speechiness +
    acousticness + instrumentalness + liveness + valence + tempo + duration_ms,
  data = train_data,
  method = "class",
  control = rpart.control(cp = 0.01, maxdepth = 10)
)
rpart.plot(model_dt)

predictions <- predict(model_dt, test_data, type = "class")

confusionMatrix(predictions, test_data$playlist_genre)

# Save confusion matrix output
capture.output(confusionMatrix(predictions, test_data$playlist_genre),
               file = "output/decision_tree_results.txt")

# Random Forest
library(randomForest)

# Train model
model_rf <- randomForest(
  playlist_genre ~ danceability + energy + loudness + speechiness +
    acousticness + instrumentalness + liveness + valence + tempo + duration_ms,
  data = train_data,
  ntree = 100
)

pred_rf <- predict(model_rf, test_data)
confusionMatrix(pred_rf, test_data$playlist_genre)
plot(model_rf)
png("output/rf_error_plot.png", width = 800, height = 600)
plot(model_rf)
dev.off()

capture.output(confusionMatrix(pred_rf, test_data$playlist_genre),
               file = "output/random_forest_results.txt")

# Linear Regression
model_lm <- lm(track_popularity ~ danceability + energy + loudness +
                 speechiness + acousticness + instrumentalness +
                 liveness + valence + tempo + duration_ms,
               data = train_data)

pred_lm <- predict(model_lm, test_data)
# Evaluation
# RMSE
rmse <- sqrt(mean((pred_lm - test_data$track_popularity)^2))
rmse

# R-squared
summary(model_lm)$r.squared

capture.output(summary(model_lm),
               file = "output/linear_regression_results.txt")

# Prediction vs Actual
results_lm <- data.frame(
  Actual = test_data$track_popularity,
  Predicted = pred_lm
)

library(ggplot2)

p_lm1 <- ggplot(results_lm, aes(x = Actual, y = Predicted)) +
  geom_point(alpha = 0.3) +
  geom_abline(color = "red") +
  theme_minimal() +
  ggtitle("Predicted vs Actual Popularity")

p_lm1
ggsave("output/lm_pred_vs_actual.png", plot = p_lm1, width = 6, height = 4)

#Resudial Plot
results_lm$Residuals <- results_lm$Actual - results_lm$Predicted

p_lm2 <- ggplot(results_lm, aes(x = Predicted, y = Residuals)) +
  geom_point(alpha = 0.3) +
  geom_hline(yintercept = 0, color = "red") +
  theme_minimal() +
  ggtitle("Residual Plot")

p_lm2
ggsave("output/lm_residuals.png", plot = p_lm2, width = 6, height = 4)

# ── Feature Importance Plot (Random Forest)
importance_df <- data.frame(
  Feature    = rownames(importance(model_rf)),
  Importance = importance(model_rf)[, "MeanDecreaseGini"]
)
importance_df <- importance_df[order(importance_df$Importance), ]
importance_df$Feature <- factor(importance_df$Feature, levels = importance_df$Feature)

p_importance <- ggplot(importance_df, aes(x = Feature, y = Importance)) +
  geom_bar(stat = "identity", fill = "#2e7d52") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Random Forest — Feature Importances",
       x = NULL,
       y = "Mean Decrease in Gini Impurity")

ggsave("output/feature_importance.png", plot = p_importance, width = 7, height = 4)

# ── Regression Coefficients Plot
coef_df <- data.frame(
  Feature = names(coef(model_lm))[-1],   # drop intercept
  Coef    = coef(model_lm)[-1]
)
coef_df <- coef_df[order(coef_df$Coef), ]
coef_df$Feature   <- factor(coef_df$Feature, levels = coef_df$Feature)
coef_df$Direction <- ifelse(coef_df$Coef > 0, "Positive", "Negative")

p_coef <- ggplot(coef_df, aes(x = Feature, y = Coef, fill = Direction)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Positive" = "#2e7d52", "Negative" = "#c0392b")) +
  coord_flip() +
  theme_minimal() +
  labs(title = "Linear Regression Coefficients — Popularity Prediction",
       x = NULL,
       y = "Coefficient (standardised features)",
       fill = NULL)

ggsave("output/lr_coefficients.png", plot = p_coef, width = 7, height = 4)