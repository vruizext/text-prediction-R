##final tests, full test data set
# on validation, it has a minimum entropy of, 2.143
test.config = list()
test.config$corpus <- "all.test"
test.config$model <- "MLE.all.ext.kmin.2.ntop.3.rds"
test.config$mode <- "pr.ext"
test.config$ngrams <- "all.devtest.tetrag.rds" #
test.config$name <- "PR.ext.MLE.all.devtest.kmin.2.ntop.3.900x1000.12345.1"
test.config$seed <- 12345
test.config$chunkNumber <- 900 # run X samples of ngrams chunks
test.config$chunkSize <- 1000  # get Y ngrams for each chunk
test.config$tests <- list()


test.config$tests[[1]] <- list()
test.config$tests[[1]]$coef <- list(a123 = 0.33 * 0.35, a12 = 0.33 * 0.22,
									a13 = 0.33 * 0.33, a1 = 0.33 * 0.1,
									a23 = 0.33 * 1, a2 = 0.33 * 0, a3 = 0.32, a4 = 0.02)

runTest(model, data, test.config)