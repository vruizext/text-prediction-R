##validate results from previous tests on the full devtest dataset
#previous result: entropy minimum, 2.146
#list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
#		a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
#		a23 = 0.33 * 1, a2 = 0.33 * 0, a3 = 0.32, a4 = 0.02)
# test 1 has a minimum entropy also here, 2.143
test.config = list()
test.config$corpus <- "all.devtest"
test.config$name <- "PR.ext.MLE.all.devtest.kmin.2.ntop.3.9000x100.12345.1"
test.config$model <- "MLE.all.ext.kmin.2.ntop.3.rds"
test.config$mode <- "pr.ext"
test.config$ngrams <- "all.devtest.tetrag.rds" #"ngrams.test.1.rds"
test.config$tests <- list()
test.config$seed <- 12345
test.config$chunkNumber <- 9022 # run X samples of ngrams chunks
test.config$chunkSize <- 100  # get Y ngrams for each chunk


test.config$tests[[1]] <- list()
test.config$tests[[1]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 1, a2 = 0.33 * 0, a3 = 0.32, a4 = 0.02)


test.config$tests[[2]] <- list()
test.config$tests[[2]]$coef <- list(a123 = 0.55 * 0.35, a12 = 0.55 * 0.22,
									a13 = 0.55 * 0.33, a1 = 0.55 * 0.1,
									a23 = 0.23 * 1, a2 = 0.23 * 0, a3 = 0.2, a4 = 0.02)

test.config$tests[[3]] <- list()
test.config$tests[[3]]$coef <- list(a123 = 0.75 * 0.35, a12 = 0.75 * 0.22,
									a13 = 0.75 * 0.33, a1 = 0.75 * 0.1,
									a23 = 0.13 * 1, a2 = 0.13 * 0., a3 = 0.1, a4 = 0.02)

test.config$tests[[4]] <- list()
test.config$tests[[4]]$coef <- list(a123 = 0.85 * 0.35, a12 = 0.85 * 0.22,
									a13 = 0.85 * 0.33, a1 = 0.85 * 0.1,
									a23 = 0.1 * 1, a2 = 0.13 * 0, a3 = 0.04, a4 = 0.01)

runTest(model, data, test.config)