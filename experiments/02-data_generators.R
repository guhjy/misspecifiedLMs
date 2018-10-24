setwd("~/Dropbox/ModelMissspecification/experiments/")

load("01d-data_files.RData", verbose = TRUE)

mu_all_l <- list()
Y_all_l <- list()


# Perfect model ----------------------------------------------------------------
set.seed(65697224)
b <- c(sex = 3, g2000 = 1, g2002 = -4, p2000 = 1, p2002 = 5, p2004 = -9, 
       age = 3, treatment = 2, voted = 2)

mu_perfect <- as.matrix(X_full) %*% as.matrix(b)
Y_perfect <- mu_perfect + rnorm(length(mu_perfect))

mu_all_l[["mu_perfect"]] <- mu_perfect
Y_all_l[["Y_perfect"]] <- Y_perfect


# heavy tail -------------------------------------------------------------------
mu_student1 <- mu_student2 <- mu_student3 <- mu_student4 <- 
  mu_student5 <- mu_perfect
Y_student1 <- mu_perfect + rt(n = length(mu_perfect), df = 1)
Y_student2 <- mu_perfect + rt(n = length(mu_perfect), df = 2)
Y_student3 <- mu_perfect + rt(n = length(mu_perfect), df = 3)
Y_student4 <- mu_perfect + rt(n = length(mu_perfect), df = 4)
Y_student5 <- mu_perfect + rt(n = length(mu_perfect), df = 5)

mu_all_l[["mu_student1"]] <- mu_student1
mu_all_l[["mu_student2"]] <- mu_student2
mu_all_l[["mu_student3"]] <- mu_student3
mu_all_l[["mu_student4"]] <- mu_student4
mu_all_l[["mu_student5"]] <- mu_student5

Y_all_l[["Y_student1"]] <- Y_student1
Y_all_l[["Y_student2"]] <- Y_student2
Y_all_l[["Y_student3"]] <- Y_student3
Y_all_l[["Y_student4"]] <- Y_student4
Y_all_l[["Y_student5"]] <- Y_student5


# dependent --------------------------------------------------------------------
# 10000 cluster:
mu_10000cluster <- mu_perfect
cluster_error <- rnorm(length(unique(X_unobserved$cluster)))

Y_10000cluster <- mu_10000cluster + rnorm(length(mu_10000cluster)) + 
  cluster_error[X_unobserved$cluster]

mu_all_l[["mu_10000unobservedCluster"]] <- mu_10000cluster
Y_all_l[["Y_10000unobservedCluster"]] <- Y_10000cluster

# 1000 cluster:
cluster1000 <- ceiling(X_unobserved$cluster / 10)
mu_1000cluster <- mu_perfect
cluster_error <- rnorm(length(unique(cluster1000)))

Y_1000cluster <- mu_1000cluster + rnorm(length(mu_1000cluster)) + 
  cluster_error[cluster1000]

mu_all_l[["mu_1000unobservedCluster"]] <- cluster1000
Y_all_l[["Y_1000unobservedCluster"]] <- Y_1000cluster

# 100 cluster:
cluster100 <- ceiling(X_unobserved$cluster / 100)
mu_100cluster <- mu_perfect
cluster_error <- rnorm(length(unique(cluster100)))

Y_100cluster <- mu_100cluster + rnorm(length(mu_100cluster)) + 
  cluster_error[cluster100]

mu_all_l[["mu_100unobservedCluster"]] <- cluster100
Y_all_l[["Y_100unobservedCluster"]] <- Y_100cluster


# missing term -----------------------------------------------------------------
set.seed(65697224)
b <- c(sex = 3, g2000 = 1, g2002 = -4, p2000 = 1, p2002 = 5, p2004 = -9, 
       age = 3, treatment = 2, voted = 2)

mu_perfect <- as.matrix(X_full) %*% as.matrix(b)
Y_perfect <- mu_perfect + rnorm(length(mu_perfect))

mu_all_l[["mu_perfect"]] <- mu_perfect
Y_all_l[["Y_perfect"]] <- Y_perfect

# Save all the output files ####################################################

mu_all <- do.call("cbind", mu_all_l)
colnames(mu_all) <- names(mu_all_l)
Y_all <- do.call("cbind", Y_all_l)
colnames(Y_all) <- names(Y_all_l)


save(mu_all, Y_all, file = "02d-responseData.Rdata")



