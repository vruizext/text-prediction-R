setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("model/ngrams.R")


#split corpus in bigrams,
for (corpus in c("blogs", "news", "twitter", "all")) {
	data <- list(corpus = corpus)
	data$txt <- readRDS(sprintf("%s/%s.train.clean.rds", data.clean.dir, corpus))
	data$chunkSize <- 10000
	data$lines <- length(data$txt)
	data$ids <- initIds(data)
	data$ng <- 2
	data$suffix <- "bi"
	data$dict.name <- sprintf("%s.pr.975", corpus)
	data <- nGramization(data)

	rm(data)
	gc()
}

#split corpus in trigrams,
for (corpus in c("blogs", "news", "twitter", "all")) {
	data <- list(corpus = corpus)
	data$txt <- readRDS(sprintf("%s/%s.train.clean.rds", data.clean.dir, corpus))
	data$chunkSize <- 10000
	data$lines <- length(data$txt)
	data$ids <- initIds(data)
	data$ng <- 3
	data$suffix <- "tri"
	data$dict.name <- sprintf("%s.pr.975", corpus)
	data <- nGramization(data)

	rm(data)
	gc()
}

