setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("test/testing.R")

#prepare devtesting data
#1. clean corpus, using same preprocess as with the training data
devtest.clean.file <- "data/clean/all.devtest.clean.rds"
if (!file.exists(devtest.clean.file)) {
	data <- list()
	data$corpus <- "all.devtest" # corpus (file) now is the devtest corpus
	data$chunkSize <- 10000 # data processed in chunks of 10,000 lines each
	data$stemming <- F # don't apply stemming
	data$suffix <- "clean" # suffix added to the file name when saving output file
	data <- clean(data)
}

#2. build an ngram data table from the corpus
devtest.ngrams.file <- "model/data/all.devtest.tetrag.rds"
if (!file.exists(devtest.ngrams.file)) {
	data <- list(corpus = "all.devtest")
	data$txt <- readRDS(devtest.clean.file)
	data$lines <- length(data$txt)
	data$chunkSize <- 10000
	data$ng = 4
	data$suffix <- "tetrag"
	data$ids <- initIds(data)
	data$dict.name <- "all.pr.975"
	data <- nGramization(data)
}

#3. run test battery
source("test/PR.ext.MLE.all.devtest.kmin.2.top.3.1000x100.12345.1.R")
source("test/PR.ext.MLE.all.devtest.kmin.2.top.3.1000x100.12345.2.R")
source("test/PR.ext.MLE.all.devtest.kmin.2.top.3.9000x100.12345.1.R")
