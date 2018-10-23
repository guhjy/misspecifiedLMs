setwd("~/Dropbox/ModelMissspecification/experiments/")
load("00d-GerberGreenLarimer_r1b.RData",verbose = TRUE)

X_full <- cbind(
      sex = as.numeric(social$sex) - 1,
      g2000 = as.numeric(social$g2000) - 1,
      g2002 = as.numeric(social$g2002) - 1,
      p2000 = as.numeric(social$p2000) - 1,
      p2002 = as.numeric(social$p2002) - 1,
      p2004 = as.numeric(social$p2004) - 1,
      age = social$age, 
      treatment = social$treatment, 
      voted = social$voted - 1)
dim(X_full)
head(X_full)
summary(X_full)

train_ids <- sample.int(n = nrow(X_full), size = round(nrow(X_full)) / 2)
test_ids <- (1:nrow(X_full))[-train_ids]

stopifnot(table(table(c(test_ids, train_ids))) == nrow(X_full))

save(X_full, train_ids, test_ids, 
     file = "01d-data_files.RData")




