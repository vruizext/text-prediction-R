## big test for MLE extended model
##try different weights configurations, to find which one minimizes H(x)
# minimum Hx, 2.163 obtained for test 4
test.config = list()
test.config$corpus <- "all.devtest"
test.config$name <- "PR.ext.MLE.all.devtest.kmin.2.ntop.3.1000x100.12345.1"
test.config$model <- "MLE.all.ext.kmin.2.ntop.3.rds"
test.config$mode <- "pr.ext"
test.config$ngrams <- "all.devtest.tetrag.rds" #"ngrams.test.1.rds"
test.config$tests <- list()
test.config$seed <- 12345
test.config$chunkNumber <- 1000 # run X samples of ngrams chunks
test.config$chunkSize <- 100  # get Y ngrams for each chunk

#keep partial matches weights constants, vary weights for 4grams,3grams,2grams 1grams models
test.config$tests[[1]] <- list()
test.config$tests[[1]]$coef <- list(a123 = 0.95 * 0.85, a12 = 0.95 * 0.03,
									a13 = 0.95 * 0.1, a1 = 0.95 * 0.02,
									a23 = 0.03 * 0.95, a2 = 0.03 * 0.05, a3 = 0.015, a4 = 0.005)

test.config$tests[[2]] <- list()
test.config$tests[[2]]$coef <- list(a123 = 0.75 * 0.85, a12 = 0.75 * 0.03,
									a13 = 0.75 * 0.1, a1 = 0.75 * 0.02,
									a23 = 0.13 * 0.95, a2 = 0.13 * 0.05, a3 = 0.105, a4 = 0.015)


test.config$tests[[3]] <- list()
test.config$tests[[3]]$coef <- list(a123 = 0.55 * 0.85, a12 = 0.55 * 0.03,
									a13 = 0.55 * 0.1, a1 = 0.55 * 0.02,
									a23 = 0.23 * 0.95, a2 = 0.23 * 0.05, a3 = 0.2, a4 = 0.02)

test.config$tests[[4]] <- list()
test.config$tests[[4]]$coef <- list(a123 = 0.33 * 0.85, a12 = 0.33 * 0.03,
									a13 = 0.33 * 0.1, a1 = 0.33 * 0.02,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)

#try now to change weights for partial matches
test.config$tests[[5]] <- list()
test.config$tests[[5]]$coef <- list(a123 = 0.75 * 0.75, a12 = 0.75 * 0.07,
									a13 = 0.75 * 0.15, a1 = 0.75 * 0.03,
									a23 = 0.13 * 0.85, a2 = 0.13 * 0.15, a3 = 0.105, a4 = 0.015)

test.config$tests[[6]] <- list()
test.config$tests[[6]]$coef <- list(a123 = 0.75 * 0.55, a12 = 0.75 * 0.125,
									a13 = 0.75 * 0.25, a1 = 0.75 * 0.075,
									a23 = 0.13 * 0.75, a2 = 0.13 * 0.25, a3 = 0.105, a4 = 0.015)


test.config$tests[[7]] <- list()
test.config$tests[[7]]$coef <- list(a123 = 0.75 * 0.4, a12 = 0.75 * 0.2,
									a13 = 0.75 * 0.3, a1 = 0.75 * 0.1,
									a23 = 0.13 * 0.55, a2 = 0.13 * 0.45, a3 = 0.105, a4 = 0.015)

#now try different weight configuration, assign weights depending on how many words match
#and how close to w4 are the matches
test.config$tests[[8]] <- list()
test.config$tests[[8]]$coef <- list(a123 = 0.85,
									a23 = 0.10 * 0.55, a13 = 0.10 * 0.25, a12 = 0.10 * 0.2,
									a3 = 0.04 * 0.55, a2 = 0.04 * 0.25, a1 = 0.04 * 0.2,  a4 = 0.01)


test.config$tests[[9]] <- list()
test.config$tests[[9]]$coef <- list(a123 = 0.75,
									a23 = 0.15 * 0.55, a13 = 0.15 * 0.25, a12 = 0.15 * 0.2,
									a3 = 0.09 * 0.55, a2 = 0.09 * 0.25, a1 = 0.09 * 0.2,  a4 = 0.01)

test.config$tests[[10]] <- list()
test.config$tests[[10]]$coef <- list(a123 = 0.65,
									 a23 = 0.2 * 0.55, a13 = 0.2 * 0.25, a12 = 0.2 * 0.2,
									 a3 = 0.14 * 0.55, a2 = 0.14 * 0.25, a1 = 0.14 * 0.2,  a4 = 0.01)



test.config$tests[[11]] <- list()
test.config$tests[[11]]$coef <- list(a123 = 0.55,
									 a23 = 0.25 * 0.55, a13 = 0.25 * 0.25, a12 = 0.25 * 0.2,
									 a3 = 0.19 * 0.55, a2 = 0.19 * 0.25, a1 = 0.19 * 0.2,  a4 = 0.01)

test.config$tests[[12]] <- list()
test.config$tests[[12]]$coef <- list(a123 = 0.45,
									 a23 = 0.3 * 0.55, a13 = 0.3 * 0.25, a12 = 0.3 * 0.2,
									 a3 = 0.24 * 0.55, a2 = 0.24 * 0.25, a1 = 0.24 * 0.2,  a4 = 0.01)

test.config$tests[[13]] <- list()
test.config$tests[[13]]$coef <- list(a123 = 0.35,
									 a23 = 0.35 * 0.55, a13 = 0.35 * 0.25, a12 = 0.35 * 0.2,
									 a3 = 0.29 * 0.55, a2 = 0.29 * 0.25, a1 = 0.29 * 0.2,  a4 = 0.01)

test.config$tests[[14]] <- list()
test.config$tests[[14]]$coef <- list(a123 = 0.33,
									 a23 = 0.33 * 0.55, a13 = 0.33 * 0.25, a12 = 0.33 * 0.2,
									 a3 = 0.33 * 0.55, a2 = 0.33 * 0.25, a1 = 0.33 * 0.2,  a4 = 0.01)

test.config$tests[[15]] <- list()
test.config$tests[[15]]$coef <- list(a123 = 0.15,
									 a23 = 0.14, a13 = 0.14, a12 = 0.14,
									 a3 = 0.14, a2 = 0.14, a1 = 0.14,  a4 = 0.01)

runTest(model, data, test.config)