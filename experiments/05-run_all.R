
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
ci_summary <- data.frame()
pi_summary <- data.frame()

ci_non_param

model_grid <- model_grid[c(1, 2, 8)]

for (model in model_grid) {
  print(paste("Running Model", model))
  # model = model_grid[1]
  mu_all_test_itr <- mu_all_test[ , grepl(model, colnames(mu_all_test))]
  Y_all_test_itr <- Y_all_test[ , grepl(model, colnames(Y_all_test))]
  mu_all_train_itr <- mu_all_train[ , grepl(model, colnames(mu_all_train))]
  Y_all_train_itr <- Y_all_train[ , grepl(model, colnames(Y_all_train))]
  
  for (ciEstimator_i in 1:length(ciEstimator_grid)) {
    # ciEstimator_i = 1
    ciEstimator_name <- names(ciEstimator_grid)[ciEstimator_i]
    ciEstimator <- ciEstimator_grid[[ciEstimator_i]]
    ci <- ciEstimator(x_train = X_train, 
                      y_train = Y_all_train_itr,
                      x_test = X_test)
    
    ci_summary <- 
      rbind(ci_summary,
            data.frame(
              model = model,
              estimator_name = ciEstimator_name,
              ci_length_out = mean(ci$upr - ci$lwr),
              ci_coverage_out = mean(ci$upr > mu_all_test_itr &
                                     ci$lwr < mu_all_test_itr)))#,
              # ci_coverage_out_Y = mean(ci$upr > Y_all_test_itr &
              #                          ci$lwr < Y_all_test_itr)))
    
  }
  
  for (piEstimator_i in 1:length(piEstimator_grid)) {
      
    # ciEstimator_i = 1
    piEstimator_name <- names(piEstimator_grid)[piEstimator_i]
    piEstimator <- piEstimator_grid[[piEstimator_i]]
    pi <- piEstimator(x_train = X_train, 
                      y_train = Y_all_train_itr,
                      x_test = X_test)
    
    pi_summary <- 
      rbind(pi_summary,
            data.frame(
              model = model,
              estimator_name = piEstimator_name,
              pi_length_out = mean(pi$upr - pi$lwr),
              pi_coverage_out = mean(pi$upr > mu_all_test_itr &
                                       pi$lwr < mu_all_test_itr)))#,
              # pi_coverage_out_Y = mean(pi$upr > Y_all_test_itr &
              #                            pi$lwr < Y_all_test_itr)))
    
  }
}

ci_summary
pi_summary



