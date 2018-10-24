setwd("~/Dropbox/ModelMissspecification/experiments/")

ciEstimator_grid <- list()

# normal approximation with the default formula --------------------------------
# load("03t-CIestimators_test.Rdta", verbose = TRUE)
ci_usual <- function(x_train, y_train, x_test) {
  lmd <- lm(y_train ~ ., data = as.data.frame(x_train))
  return(as.data.frame(
    predict(lmd, newdata = as.data.frame(x_test), interval = "confidence")))
}

ciEstimator_grid[["ci_usual"]] <- ci_usual


# non-parametric bootsrap ------------------------------------------------------
# load("03t-CIestimators_test.Rdta", verbose = TRUE)
ci_non_param <- function(x_train, y_train, x_test, B = 100, verbose = TRUE) {
  # B = 100; verbose = TRUE;
  pdmat <- matrix(NA, nrow = nrow(x_test), ncol = B)
  x_train <- as.data.frame(x_train)
  x_test <- as.data.frame(x_test)
  for (b in 1:B) {
    if (verbose) print(b)
    idx_b <- sample(1:length(y_train), replace = TRUE)
    y_train_b <- y_train[idx_b]
    x_train_b <- x_train[idx_b, ]
    lmd <- lm(y_train_b ~ ., data = x_train_b)
    pdmat[ ,b] <- predict(lmd, newdata = x_test)
  }
  
  sds <- apply(pdmat, 1, sd)
  mns <- apply(pdmat, 1, mean)
  
  return(data.frame(lwr = mns - 1.96 * sds, upr = mns + 1.96 * sds))
}

ciEstimator_grid[["ci_non_param"]] <- ci_non_param


# parametric bootsrap ------------------------------------------------------
# load("03t-CIestimators_test.Rdta", verbose = TRUE)
ci_param <- function(x_train, y_train, x_test, B = 100, verbose = TRUE) {
  # B = 100; verbose = TRUE;
  pdmat <- matrix(NA, nrow = nrow(x_test), ncol = B)
  x_train <- as.data.frame(x_train)
  x_test <- as.data.frame(x_test)
  lmd_main <- lm(y_train ~ ., data = as.data.frame(x_train))
  lmd_main$fitted.values

  for (b in 1:B) {
    if (verbose) print(b)
    y_train_b <- lmd_main$fitted.values + 
      sample(lmd_main$residuals, replace = TRUE)
    lmd <- lm(y_train_b ~ ., data = x_train)
    pdmat[ ,b] <- predict(lmd, newdata = x_test)
  }
  
  sds <- apply(pdmat, 1, sd)
  mns <- apply(pdmat, 1, mean)
  
  return(data.frame(lwr = mns - 1.96 * sds, upr = mns + 1.96 * sds))
}

ciEstimator_grid[["ci_param"]] <- ci_param



# Save all the ci estimators files #############################################
save(ciEstimator_grid, file = "03f-ciEstimator_grid.Rdta")
