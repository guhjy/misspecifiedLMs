setwd("~/Dropbox/ModelMissspecification/experiments/")

load("01d-data_files.RData", verbose = TRUE)


# Perfect model ----------------------------------------------------------------
set.seed(65697224)
head(X_train)
b <- c(sex = 3, g2000 = 1, g2002 = -4, p2000 = 1, p2002 = 5, p2004 = -9, 
       age = 3, treatment = 2, voted = 2)

mu_perfect <- X_full %*% b
Y_perfect <- mu_perfect + rnorm(length(mu_perfect))

# heavy tail -------------------------------------------------------------------
mu_heavyTail1 <- mu_heavyTail3 <- mu_heavyTail5 <- mu_perfect
Y_heavyTail1 <- mu_perfect + rt(n = length(mu_perfect), df = 1)
Y_heavyTail3 <- mu_perfect + rt(n = length(mu_perfect), df = 3)
Y_heavyTail5 <- mu_perfect + rt(n = length(mu_perfect), df = 5)


# dependent --------------------------------------------------------------------

# truncated --------------------------------------------------------------------

# missing term -----------------------------------------------------------------


# Save all the output files ####################################################

mu_all <- data.frame(
  mu_perfect,
  mu_heavyTail1,
  mu_heavyTail3,
  mu_heavyTail5)
Y_all <- data.frame(
  Y_perfect,
  Y_heavyTail1,
  Y_heavyTail3,
  Y_heavyTail5)

save(mu_all, Y_all, file = "02d-responseData.Rdata")



