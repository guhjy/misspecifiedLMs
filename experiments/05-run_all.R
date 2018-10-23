
setwd("~/Dropbox/ModelMissspecification/experiments/")

load("01d-data_files.RData", verbose = TRUE)
load("02d-responseData.Rdata", verbose = TRUE)

X_test <-      X_full[test_ids, ]
mu_all_test <- mu_all[test_ids, ]
Y_all_test <-   Y_all[test_ids, ]

X_train <-      X_full[train_ids, ]
mu_all_train <- mu_all[train_ids, ]
Y_all_train <-   Y_all[train_ids, ]


model_grid <- substr(colnames(mu_all_train), 4, 10000)
load("03f-ciEstimator_grid.Rdta", verbose = TRUE)
load("04f-piEstimator_grid.Rdta", verbose = TRUE)
for (model in model_grid) {
  # model = model_grid[1]
  mu_all_test_itr <- mu_all_test[ , grepl(model, colnames(mu_all_test))]
  Y_all_test_itr <- Y_all_test[ , grepl(model, colnames(Y_all_test))]
  mu_all_train_itr <- mu_all_train[ , grepl(model, colnames(mu_all_train))]
  Y_all_train_itr <- Y_all_train[ , grepl(model, colnames(Y_all_train))]
  
  for (ciEstimator in ciEstimator_grid) {
    # ciEstimator = ciEstimator_grid[1]
    ci <- ciEstimator(x_train = X_train, 
                      y_train = Y_all_train_itr,
                      x_test = X_test)
    
    ci_length_out  <- ci$upper - ci$lower
    ci_coverage_out <- mean(ci$upper > mu_all_test_itr &  
                                           ci$lower < mu_all_test_itr)
    ci_coverage_out_Y <- mean(ci$upper > Y_all_test_itr &  
                              ci$lower < Y_all_test_itr)
    
  }
  
  for (ciEstimator in piEstimator_grid) {
    stop("Note implemented yet!")
  }
    
}


