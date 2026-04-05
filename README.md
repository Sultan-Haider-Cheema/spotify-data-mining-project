# Spotify Songs — Data Mining Project

**Course:** Data Mining and Knowledge Discovery  
**Program:** Master 1 — Machine Learning and Data Mining (MLDM)  
**University:** Jean Monnet University, Saint-Etienne, France  
**Author:** Muhammad Sultan Haidar Cheema  
**Academic Year:** 2025-2026  

---

## Project Overview

This project applies data mining techniques to the Spotify Songs Dataset to answer
three research questions:

1. Can we predict the genre of a song using its audio features?
2. Which audio features most influence track popularity?
3. Are there natural acoustic groupings of songs that go beyond genre labels?

---

## Dataset

- **Source:** Spotify Songs Dataset by Charlie Thompson, published via the
  TidyTuesday project  
  [https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-01-21](https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-01-21)
- **Training split used:** 26,266 tracks, 24 variables (~5.2 MB)
- **Full dataset size:** 32,833 tracks
- **Key features:** danceability, energy, loudness, speechiness, acousticness,
  instrumentalness, liveness, valence, tempo, duration_ms
- **Target variables:** `playlist_genre` (6 classes), `track_popularity` (0-100)

---

## Methods

| Task | Method | R Package |
|------|--------|-----------|
| Genre classification | Decision Tree (CART) | `rpart` |
| Genre classification | Random Forest (100 trees) | `randomForest` |
| Popularity prediction | Multiple Linear Regression | base R `lm()` |
| Song grouping | K-means Clustering (k=6) | `factoextra` |

---

## Results Summary

| Model | Metric | Value |
|-------|--------|-------|
| Decision Tree | Accuracy | 40.1% |
| Random Forest | Accuracy | 53.4% |
| Random Forest | Kappa | 0.441 |
| Linear Regression | R-squared | 0.075 |
| Linear Regression | RMSE | 24.0 popularity points |
| K-means | Total within-cluster SS | 263,677 |

The Random Forest substantially outperforms the Decision Tree and both significantly
beat the no-information rate baseline of 18.3%. Popularity prediction is inherently
limited by non-acoustic factors. Clustering reveals six acoustically coherent song
archetypes that do not map cleanly onto genre labels.

---

## Project Structure

    spotify-data-mining-project/
    │
    ├── data/
    │   ├── spotify.csv              # raw training data (26,266 tracks)
    │   └── spotify_clean.csv        # preprocessed and scaled data
    │
    ├── scripts/
    │   ├── 01_data_loading.R        # load and inspect the dataset
    │   ├── 02_eda.R                 # exploratory data analysis and plots
    │   ├── 03_preprocessing.R       # cleaning, scaling, train-test split
    │   ├── 04_modeling.R            # Decision Tree, Random Forest, Linear Regression
    │   └── 05_clustering.R          # K-means clustering with elbow method
    │
    ├── output/
    │   ├── genre_distribution.png
    │   ├── popularity_distribution.png
    │   ├── correlation_matrix.png
    │   ├── danceability_vs_popularity.png
    │   ├── DecissionTree.png
    │   ├── rf_error_plot.png
    │   ├── feature_importance.png
    │   ├── lr_coefficients.png
    │   ├── lm_pred_vs_actual.png
    │   ├── lm_residuals.png
    │   ├── elbow_plot.png
    │   ├── kmeans_clusters.png
    │   ├── decision_tree_results.txt
    │   ├── random_forest_results.txt
    │   └── linear_regression_results.txt
    │
    ├── .gitignore
    └── README.md

---

## How to Reproduce

1. Clone this repository:
   git clone https://github.com/Sultan-Haider-Cheema/spotify-data-mining-project.git
2.  Open the project in RStudio.

3. Install required packages if not already installed:
```r
   install.packages(c("tidyverse", "caret", "rpart", "rpart.plot",
                      "randomForest", "corrplot", "factoextra"))
```

4. Run the scripts in order from the `scripts/` folder:
01_data_loading.R
02_eda.R
03_preprocessing.R
04_modeling.R
05_clustering.R
All scripts use `set.seed(123)` to ensure fully reproducible results.

---

## Requirements

- R version 4.0 or higher
- RStudio (recommended)
- Packages: `tidyverse`, `caret`, `rpart`, `rpart.plot`, `randomForest`,
  `corrplot`, `factoextra`

---

## Notes

- The `data/` folder contains both the raw and cleaned versions of the dataset.
- All output plots and result text files are saved automatically to the `output/` folder
  when scripts are run.
- Timing for each step was measured using `system.time()` in R. The full pipeline
  runs in approximately 3-4 minutes, with K-means being the most computationally
  intensive step (~2-3 minutes for the elbow search).
