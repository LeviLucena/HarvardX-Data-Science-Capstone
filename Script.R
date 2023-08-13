## Levi Lucena - https://github.com/LeviLucena
## MovieLens Project
## HarvardX: PH125.9x - Capstone Project
## https://github.com/LeviLucena/HarvardX-Data-Science-Capstone

################################################
# MovieLens Project
################################################

# Load necessary packages
library(dplyr)
library(randomForest)
library(readr)  # Package for reading data files
library(ggplot2)
library(DT)      # Package for creating interactive data tables

# Define the path to the ratings and movies files
ratings_file_path <- "C:/Users/PRODESP/Downloads/ml-latest-small/ratings.csv"
movies_file_path <- "C:/Users/PRODESP/Downloads/ml-latest-small/movies.csv"

# Read the ratings data using read_delim from readr
ratings <- read_csv(ratings_file_path)

# Read the movies data using read_delim from readr
movies <- read_csv(movies_file_path)

# Convert columns to appropriate types
ratings$userId <- as.integer(ratings$userId)
ratings$movieId <- as.integer(ratings$movieId)
ratings$rating <- as.numeric(ratings$rating)

# Preprocess the data (additional preprocessing can be done here)

# Reduce the size of the training data using a smaller sample
set.seed(123)
sample_index <- sample(nrow(ratings), size = 0.01 * nrow(ratings), replace = FALSE)
ratings <- ratings[sample_index, ]

# Merge the ratings data with movie information
data_with_movies <- left_join(ratings, movies, by = "movieId")

# Split the data into train and test sets
train_size <- 0.8
train_index <- sample(nrow(data_with_movies), size = train_size * nrow(data_with_movies))
train_data <- data_with_movies[train_index, ]
test_data <- data_with_movies[-train_index, ]

# Train the model (example with randomForest)
model <- randomForest(rating ~ ., data = train_data)

# Make predictions on the test set
predictions <- predict(model, test_data)

# Calculate RMSE
rmse <- sqrt(mean((predictions - test_data$rating)^2))

# Print results
print(paste("RMSE:", rmse))

# Create a histogram of movie ratings
hist_plot <- ggplot(data_with_movies, aes(x = rating)) +
  geom_histogram(binwidth = 0.5, fill = "blue", color = "black") +
  labs(title = "Histogram of Movie Ratings", x = "Rating", y = "Frequency")

# Create a scatter plot of predicted vs. actual ratings
scatter_plot <- ggplot(test_data, aes(x = rating, y = predictions)) +
  geom_point(color = "blue") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(title = "Predicted vs. Actual Ratings", x = "Actual Rating", y = "Predicted Rating")

# Print the plots
print(hist_plot)
print(scatter_plot)

# Create an interactive datatable for the test data
datatable(test_data)
