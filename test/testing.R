source("prediction/predictor.R")


testModel <- function(predictor, data) {
	t0 = proc.time()[3]
	ngrams <- data$ngrams
	chunkSize <- data$chunkSize
	data$ids <- 1:nrow(ngrams)
	#num.tests <- ceiling(nrow(ngrams) / chunkSize)
	k.tot <- 0
	score.tot <- 0
	result <- data.table(w1=character(0), w2=character(0), w3=character(0), w4=character(0), t=character(0),s=numeric(0),  k=numeric(0))

	chunkIds <- sample(data$ids, chunkSize * data$chunkNumber)
	for (i in 1:data$chunkNumber) {
		t1 = proc.time()[3]
		chunk <- ngrams[chunkIds[((i - 1) * chunkSize + 1):(i * chunkSize)],]
		chunk[, c("t", "s"):=get.w4(predictor, w1,w2,w3), by=1:nrow(chunk)]
		setcolorder(chunk, c(1,2,3,4,6,7,5 ))
		k <- chunk[,sum(k)]
		score <-  chunk[w4==t, sum(k)]
		result <- rbindlist(list(result, chunk))
		#test <- chunk[, .(k,w4,predict=predictNextWord(model, w1, w2,w3)[1,w4]), by=id]
		k.tot <- k.tot + k
		score.tot <- score.tot + score
		printf("chunk %i tested in %.3f s, accuracy: %.3f , total accuracy %.3f \n", i, proc.time()[3] - t1, score / k, score.tot / k.tot)
	}
	printf("%d ngrams tested in %.3f, total accuracy: %3.3f  \n\n", data$chunkSize * data$chunkNumber, proc.time()[3] - t0, score.tot / k.tot)
	result[order(-s)]
}


#run a test, get PR as quality measure
testModel.PR <- function(predictor, data) {
	t0 = proc.time()[3]
	ngrams <- data$ngrams
	chunkSize <- data$chunkSize
	data$ids <- 1:nrow(ngrams)
	result <- data.table(w1=character(0), w2=character(0), w3=character(0), w4=character(0), k=numeric(0), s=numeric(0))
	chunkIds <- sample(data$ids, chunkSize * data$chunkNumber)
	for (i in 1:data$chunkNumber) {
		t1 = proc.time()[3]
		chunk <- ngrams[chunkIds[((i - 1) * chunkSize + 1):(i * chunkSize)],]
		chunk[, s:=predictor(w1,w2,w3,w4), by=1:nrow(chunk)]
		hx <- - chunk[, sum(k * log2(s))] / chunk[, sum(k)]
		result <- rbindlist(list(result, chunk))
		hx.tot <- - result[, sum(k * log2(s))] / result[, sum(k)]
		printf("chunk %i tested in %.3f s, Hx: %.3f , total Hx %.3f \n", i, proc.time()[3] - t1, hx, hx.tot)
	}
	printf("%d ngrams tested in %.3f, total Hx: %3.3f  \n\n", nrow(result), proc.time()[3] - t0, hx.tot)
	result[order(-s)]
}

#run a group of tests,  config of each test given inside test.config
runTest <- function(model, data, test.config) {
	printf("Test %s, model: %s \n\n", test.config$name, test.config$model)
	data <- list(file = test.config$corpus)
	data$chunkSize <- test.config$chunkSize
	data$chunkNumber <- test.config$chunkNumber
	data$seed <- test.config$seed
	data$ngrams <- readRDS(paste0("model/data/", test.config$ngrams))
	#data$ngrams <- data$ngrams#[k > 1]
	model <- readRDS(paste0("prediction/data/", test.config$model))
	for(n in 1:length(test.config$tests)) {
		set.seed(data$seed)
		model$coef <- test.config$tests[[n]]$coef
		printf("Test %d, coefficients: \n", n)
		print(unlist(model$coef))
		printf("\n")
		predictor <- predictor.build(model, test.config$mode)
		if(test.config$mode %in% c("pr", "pr.ext")) {
			results <- testModel.PR(predictor, data)
			test.config$tests[[n]]$entropy <- - results[, sum(k * log(s))] / results[, sum(k)]
		} else {
			results <- testModel(predictor, data)
			test.config$tests[[n]]$accuracy <- results[t == w4, sum(k)] / results[,sum(k)]
		}
		test.config$tests[[n]]$results <- results
	}

	saveRDS(test.config, paste0("tests/data/", test.config$name, ".rds"))
	test.config
}


#build ngrams data for testing the models
#first set is for validation/optimization, 2nd for final test
build.ngrams.test <- function() {
	#prepare devtesting data
	data.test <- list(corpus = "all")
	data.test$txt <- readRDS("data/clean/devtest.rds")
	data.test$lines <- length(data.test$txt)
	data.test$chunkSize <- 20000
	data.test$ng = 4
	data.test$suffix <- "tetr.devtest"
	data.test$ids <- initIds(data.test)
	data.test$dict.name <- "all.pr.975"
	data.test <- nGramization(data.test)

	#prepare testing data
	data.test <- list(corpus = "all")
	data.test$txt <- readRDS("data/clean/test.rds")
	data.test$lines <- length(data.test$txt)
	data.test$chunkSize <- 20000
	data.test$ng = 4
	data.test$suffix <- "tetr.test"
	data.test$ids <- initIds(data.test)
	data.test$dict.name <- "all.pr.975"
	data.test <- nGramization(data.test)
}
