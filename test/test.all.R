setwd("~/courseraDataSci/capstone/")
source("model/model.R")
source("prediction/predictor.R")
source("tests/testing.R")

testKN.interp <- function(model) {
	model <- "model.all.KN.ext.kmin.1.top.1.rds"
	test.name <- "all.KN.kmin1.top1.test1"

	test.config = list()
	test.config$corpus <- "nw"
	test.config$name <- test.name
	test.config$model <- model
	test.config$mode <- "interp.kn"
	test.config$ngrams <- "ngrams.test.1" # "nw/tetr.test.nostem.1"
	test.config$tests <- list()
	test.config$seed <- 71179
	test.config$sampleSize <- 20 # run X samples of ngrams chunks
	test.config$chunkSize <- 50  # get Y ngrams for each chunk

	test.config$tests[[1]] <- list()
	test.config$tests[[1]]$coef <- list(a123 = 0.95, a23 = 0.04, a3 = 0.01)

	test.config$tests[[2]] <- list()
	test.config$tests[[1]]$coef <- list(a123 = 0.85, a23 = 0.1, a3 = 0.05)

	test.config$tests[[1]] <- list()
	test.config$tests[[1]]$coef <- list(a123 = 0.75, a23 = 0.25, a3 = 0.01)

	test.config$tests[[4]] <- list()
	test.config$tests[[4]]$coef <- list(a123 = 0.65, a23 = 0.25, a3 = 0.1)

	test.config$tests[[5]] <- list()
	test.config$tests[[5]]$coef <- list(a123 = 0.55, a23 = 0.35, a3 = 0.1)

	runTest(model, data, test.config)
}

#t1 <- testKN.interp.ext("modelKN.ext.nw.kmin1.top3.rds", "KN.ext.kmin1.top3.test1")

#model <- "modelKN.ext.nw.kmin.1.top3.rds"
#test.name <- "KN.ext.kmin1.top3.test1"

testMLE.interp.ext <- function() {
	model <- "modelMLE.all.ext.kmin.1.top.1.rds"
	test.name <- "MLE.allkmin1.top1.20x100.1.nw.3"

	test.config = list()
	test.config$corpus <- "all"
	test.config$name <- test.name
	test.config$model <- model
	test.config$mode <- "interp.ext"
	test.config$ngrams <- "nw/nw.tetr.nostem.test.1.rds" #"ngrams.test.1.rds"
	test.config$tests <- list()
	test.config$seed <- 71179
	test.config$sampleSize <- 20 # run X samples of ngrams chunks
	test.config$chunkSize <- 100  # get Y ngrams for each chunk

	test.config$tests[[1]] <- list()
	test.config$tests[[1]]$coef <- list(a123 = 0.75 * 0.85, a12 = 0.75 * 0.05,
										a13 = 0.75 * 0.05, a1 = 0.75 * 0.05,
										a23 = 0.2 * 0.85, a2 = 0.2 * 0.15, a3 = 0.05)

	test.config$tests[[2]] <- list()
	test.config$tests[[2]]$coef <- list(a123 = 0.75 * 0.95, a12 = 0.75 * 0.02,
										a13 = 0.75 * 0.02, a1 = 0.75 * 0.01,
										a23 = 0.24 * 0.95, a2 = 0.24 * 0.05, a3 = 0.01)

	test.config$tests[[3]] <- list()
	test.config$tests[[3]]$coef <- list(a123 = 0.75,
										a12 = 0.15 * 0.2, a13 = 0.15 * 0.3, a23 = 0.15 * 0.5,
										a1 = 0.10 * 0.2, a2 = 0.10 * 0.3, a3 = 0.10 * 0.5)

	test.config$tests[[4]] <- list()
	test.config$tests[[4]]$coef <- list(a123 = 0.75,
										a12 = 0.15 * 0.12, a13 = 0.15 * 0.22, a23 = 0.15 * 0.66,
										a1 = 0.10 * 0.12, a2 = 0.10 * 0.22, a3 = 0.10 * 0.66)

	# 	test.config$tests[[2]] <- list()
	# 	test.config$tests[[2]]$coef <- list(a123 = 0.75 * 0.5, a12 = 0.75 * 0.2,
	# 										a13 = 0.75 * 0.2, a1 = 0.75 * 0.1,
	# 										a23 = 0.25 * 0.75, a2 = 0.25 * 0.25, a3 = 0.05)
	#
	# 	test.config$tests[[3]] <- list()
	# 	test.config$tests[[3]]$coef <- list(a123 = 0.75 * 0.25, a12 = 0.75 * 0.25,
	# 										a13 = 0.75 * 0.25, a1 = 0.75 * 0.25,
	# 										a23 = 0.25 * 0.5, a2 = 0.25 * 0.5, a3 = 0.05)
	#
	# 	test.config$tests[[4]] <- list()
	# 	test.config$tests[[4]]$coef <- list( a123 =   1 / 6, a12 =  1 / 6,
	# 										 a13 =  1 / 6, a1 =  1 / 6,
	# 										 a23 =  1 / 6, a2 = 1/6 , a3 = 0.05)
	t <- runTest(model, data, test.config)
}



testKN.interp.ext <- function() {
	model <- "model.all.KN.ext.kmin.1.top3.rds"
	test.name <- "KN.kmin1.top3.20x1000"

	test.config = list()
	test.config$corpus <- "nw"
	test.config$name <- test.name
	test.config$model <- model
	test.config$mode <- "interp.ext"
	test.config$ngrams <- "nw/nw.tetr.test.nostem.1.rds" # "nw/tetr.test.nostem.1"
	test.config$tests <- list()
	test.config$seed <- 71179
	test.config$sampleSize <- 20 # run X samples of ngrams chunks
	test.config$chunkSize <- 1000  # get Y ngrams for each chunk

	test.config$tests[[1]] <- list()
	test.config$tests[[1]]$coef <- list(a123 = 0.75 * 0.85, a12 = 0.75 * 0.05,
										a13 = 0.75 * 0.05, a1 = 0.75 * 0.05,
										a23 = 0.2 * 0.85, a2 = 0.2 * 0.15, a3 = 0.05)

	test.config$tests[[2]] <- list()
	test.config$tests[[2]]$coef <- list(a123 = 0.75 * 0.95, a12 = 0.75 * 0.02,
										a13 = 0.75 * 0.02, a1 = 0.75 * 0.01,
										a23 = 0.24 * 0.95, a2 = 0.24 * 0.05, a3 = 0.01)

	test.config$tests[[3]] <- list()
	test.config$tests[[3]]$coef <- list(a123 = 0.75,
										a12 = 0.15 * 0.2, a13 = 0.15 * 0.3, a23 = 0.15 * 0.5,
										a1 = 0.10 * 0.2, a2 = 0.10 * 0.3, a3 = 0.10 * 0.5)

	test.config$tests[[4]] <- list()
	test.config$tests[[4]]$coef <- list(a123 = 0.75,
										a12 = 0.15 * 0.12, a13 = 0.15 * 0.22, a23 = 0.15 * 0.66,
										a1 = 0.10 * 0.12, a2 = 0.10 * 0.22, a3 = 0.10 * 0.66)

	# 	test.config$tests[[2]] <- list()
	# 	test.config$tests[[2]]$coef <- list(a123 = 0.75 * 0.5, a12 = 0.75 * 0.2,
	# 										a13 = 0.75 * 0.2, a1 = 0.75 * 0.1,
	# 										a23 = 0.25 * 0.75, a2 = 0.25 * 0.25, a3 = 0.05)
	#
	# 	test.config$tests[[3]] <- list()
	# 	test.config$tests[[3]]$coef <- list(a123 = 0.75 * 0.25, a12 = 0.75 * 0.25,
	# 										a13 = 0.75 * 0.25, a1 = 0.75 * 0.25,
	# 										a23 = 0.25 * 0.5, a2 = 0.25 * 0.5, a3 = 0.05)
	#
	# 	test.config$tests[[4]] <- list()
	# 	test.config$tests[[4]]$coef <- list( a123 =   1 / 6, a12 =  1 / 6,
	# 										 a13 =  1 / 6, a1 =  1 / 6,
	# 										 a23 =  1 / 6, a2 = 1/6 , a3 = 0.05)

	runTest(model, data, test.config)
}

testKN.interp.ext.2 <- function() {
	model <- "model.all.KN.ext.kmin.1.top3.rds"
	test.name <- "KN.kmin1.top3.200x100.test2"

	test.config = list()
	test.config$corpus <- "nw"
	test.config$name <- test.name
	test.config$model <- model
	test.config$mode <- "interp.ext.kn"
	test.config$ngrams <- "nw/nw.tetr.test.nostem.1.rds" # "nw/tetr.test.nostem.1"
	test.config$tests <- list()
	test.config$seed <- 71179
	test.config$sampleSize <- 200 # run X samples of ngrams chunks
	test.config$chunkSize <- 1000  # get Y ngrams for each chunk

	test.config$tests[[1]] <- list()
	test.config$tests[[1]]$coef <- list(a123 = 0.75 * 0.85, a12 = 0.75 * 0.05,
										a13 = 0.75 * 0.05, a1 = 0.75 * 0.05,
										a23 = 0.2 * 0.85, a2 = 0.2 * 0.15, a3 = 0.05)

	test.config$tests[[2]] <- list()
	test.config$tests[[2]]$coef <- list(a123 = 0.75 * 0.95, a12 = 0.75 * 0.02,
										a13 = 0.75 * 0.02, a1 = 0.75 * 0.01,
										a23 = 0.24 * 0.95, a2 = 0.24 * 0.05, a3 = 0.01)

	test.config$tests[[3]] <- list()
	test.config$tests[[3]]$coef <- list(a123 = 0.75,
										a12 = 0.15 * 0.2, a13 = 0.15 * 0.3, a23 = 0.15 * 0.5,
										a1 = 0.10 * 0.2, a2 = 0.10 * 0.3, a3 = 0.10 * 0.5)

	test.config$tests[[4]] <- list()
	test.config$tests[[4]]$coef <- list(a123 = 0.75,
										a12 = 0.15 * 0.12, a13 = 0.15 * 0.22, a23 = 0.15 * 0.66,
										a1 = 0.10 * 0.12, a2 = 0.10 * 0.22, a3 = 0.10 * 0.66)

	runTest(model, data, test.config)
}

testKN.backoff <- function(model) {

}

testMLE.PR.base <- function() {
	model <- "modelMLE.all.ext.kmin.1.top.3.rds"
	test.name <- "PR.MLE.all.base.kmin1.top3.100x1000.71179"
	test.config = list()

	test.config$corpus <- "all"
	test.config$name <- test.name
	test.config$model <- model
	test.config$mode <- "pr"
	test.config$ngrams <- "ngrams.all.test.1.rds" #"ngrams.test.1.rds"
	test.config$tests <- list()
	test.config$seed <- 71179
	test.config$sampleSize <- 1000 # run X samples of ngrams chunks
	test.config$chunkSize <- 100  # get Y ngrams for each chunk

	test.config$tests[[1]] <- list()
	test.config$tests[[1]]$coef <- list(a123 = 0.95, a23 = 0.03, a3 = 0.015, a4 = 0.005)

	test.config$tests[[2]] <- list()
	test.config$tests[[2]]$coef <- list(a123 = 0.85, a23 = 0.08, a3 = 0.06, a4 = 0.01)

	test.config$tests[[3]] <- list()
	test.config$tests[[3]]$coef <- list(a123 = 0.75, a23 = 0.13, a3 = 0.105, a4 = 0.015)

	test.config$tests[[4]] <- list()
	test.config$tests[[4]]$coef <- list(a123 = 0.65, a23 = 0.18, a3 = 0.15, a4 = 0.02)

	test.config$tests[[5]] <- list()
	test.config$tests[[5]]$coef <- list(a123 = 0.55, a23 = 0.23, a3 = 0.20, a4 = 0.02)

	test.config$tests[[6]] <- list()
	test.config$tests[[6]]$coef <- list(a123 = 0.45, a23 = 0.28, a3 = 0.25, a4 = 0.02)

	test.config$tests[[7]] <- list()
	test.config$tests[[7]]$coef <- list(a123 = 0.35, a23 = 0.33, a3 = 0.3, a4 = 0.02)

	test.config$tests[[8]] <- list()
	test.config$tests[[8]]$coef <- list(a123 = 0.33, a23 = 0.33, a3 = 0.32, a4 = 0.02)

	test.config$tests[[9]] <- list()
	test.config$tests[[9]]$coef <- list(a123 = 0.3, a23 = 0.3, a3 = 0.3, a4 = 0.1)

	test.config$tests[[10]] <- list()
	test.config$tests[[10]]$coef <- list(a123 = 0.29, a23 = 0.28, a3 = 0.28, a4 = 0.15)

	runTest(model, data, test.config)
}



testMLE.PR.ext <- function() {
	model <- "modelMLE.all.ext.kmin.1.top.3.rds"
	test.name <- "PR.MLE.all.ext.kmin1.top3.100x1000.23814"
	test.config = list()

	test.config$corpus <- "all"
	test.config$name <- test.name
	test.config$model <- model
	test.config$mode <- "pr.ext"
	test.config$ngrams <- "ngrams.all.test.1.rds" #"ngrams.test.1.rds"
	test.config$tests <- list()
	test.config$seed <- 23814
	test.config$sampleSize <- 1000 # run X samples of ngrams chunks
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
}


