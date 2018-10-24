setwd("~/Dropbox/ModelMissspecification/experiments/")
piEstimator_grid <- list()

# normal approximation with the default formula --------------------------------
# load("03t-CIestimators_test.Rdta", verbose = TRUE)
pi_usual <- function(x_train, y_train, x_test) {
  lmd <- lm(y_train ~ ., data = as.data.frame(x_train))
  return(as.data.frame(
    predict(lmd, newdata = as.data.frame(x_test), interval = "prediction")))
}
piEstimator_grid[["pi_usual"]] <- pi_usual


# Save all the pi estimators files #############################################
save(piEstimator_grid, file = "04f-piEstimator_grid.Rdta")
