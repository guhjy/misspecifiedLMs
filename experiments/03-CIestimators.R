# normal approximation with the default formula --------------------------------
load("03t-CIestimators_test.Rdta", verbose = TRUE)
ci_usual <- function(x_train, y_train, x_test) {
  lmd <- lm(y_train ~ ., data = as.data.frame(x_train))
  return(predict(lmd, newdata = as.data.frame(x_test), interval = "confidence"))
}




# Save all the ci estimators files #############################################

ciEstimator_grid <- list(
  ci_usual
)

save(ciEstimator_grid, file = "03f-ciEstimator_grid.Rdta")
