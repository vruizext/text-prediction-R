## from the previous tests the better interpolation weights for
## 4grams - 3grams - 2grams are 0.33 - 0.33 - 033
##now fix this and try  different interpolation coeficients
##for the partial matches of4 gram model
test.config = list()
test.config$corpus <- "all.devtest"
test.config$name <- "PR.ext.MLE.all.devtest.kmin.2.ntop.3.1000x100.12345.2"
test.config$model <- "MLE.all.ext.kmin.2.ntop.3.rds"
test.config$mode <- "pr.ext"
test.config$ngrams <- "all.devtest.tetrag.rds" #"ngrams.test.1.rds"
test.config$tests <- list()
test.config$seed <- 12345
test.config$chunkNumber <- 1000 # run X samples of ngrams chunks
test.config$chunkSize <- 100  # get Y ngrams for each chunk


test.config$tests[[1]] <- list()
test.config$tests[[1]]$coef <- list(a123 = 0.33 * 0.95, a12 = 0.33 * 0.02,
									a13 = 0.33 * 0.02, a1 = 0.33 * 0.01,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)

test.config$tests[[2]] <- list()
test.config$tests[[2]]$coef <- list(a123 = 0.33 * 0.75, a12 = 0.33 * 0.07,
									a13 = 0.33 * 0.15, a1 = 0.33 * 0.03,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)

test.config$tests[[3]] <- list()
test.config$tests[[3]]$coef <- list(a123 = 0.33 * 0.65, a12 = 0.33 * 0.1,
									a13 = 0.33 * 0.2, a1 = 0.33 * 0.05,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)

test.config$tests[[4]] <- list()
test.config$tests[[4]]$coef <- list(a123 = 0.33 * 0.55, a12 = 0.33 * 0.15,
									a13 = 0.33 * 0.25, a1 = 0.33 * 0.05,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)

test.config$tests[[5]] <- list()
test.config$tests[[5]]$coef <- list(a123 = 0.33 * 0.45, a12 = 0.33 * 0.18,
									a13 = 0.33 * 0.3, a1 = 0.33 * 0.07,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)

test.config$tests[[6]] <- list()
test.config$tests[[6]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)

test.config$tests[[7]] <- list()
test.config$tests[[7]]$coef <- list(a123 = 0.33 * 0.33, a12 = 0.33 * 0.27,
									a13 = 0.33 * 0.3, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.95, a2 = 0.33 * 0.05, a3 = 0.32, a4 = 0.02)


test.config$tests[[8]] <- list()
test.config$tests[[8]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.99, a2 = 0.33 * 0.01, a3 = 0.32, a4 = 0.02)

test.config$tests[[9]] <- list()
test.config$tests[[9]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 1, a2 = 0.33 * 0, a3 = 0.32, a4 = 0.02)

test.config$tests[[10]] <- list()
test.config$tests[[10]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.85, a2 = 0.33 * 0.15, a3 = 0.32, a4 = 0.02)

test.config$tests[[11]] <- list()
test.config$tests[[11]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.75, a2 = 0.33 * 0.25, a3 = 0.32, a4 = 0.02)

test.config$tests[[12]] <- list()
test.config$tests[[12]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.65, a2 = 0.33 * 0.35, a3 = 0.32, a4 = 0.02)

test.config$tests[[13]] <- list()
test.config$tests[[13]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.55, a2 = 0.33 * 0.45, a3 = 0.32, a4 = 0.02)

test.config$tests[[14]] <- list()
test.config$tests[[14]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 0.5, a2 = 0.33 * 0.5, a3 = 0.32, a4 = 0.02)




runTest(model, data, test.config)