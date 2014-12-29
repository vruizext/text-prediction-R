setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("model/ngrams.R")


#split corpus in tetragrams,
for (corpus in c("blogs", "news", "twitter", "all")) {
	data <- list(corpus = corpus)
	data$txt <- readRDS(sprintf("%s/%s.train.clean.rds", data.clean.dir, corpus))
	data$chunkSize <- 10000
	data$lines <- length(data$txt)
	data$ids <- initIds(data)
	data$ng <- 4
	data$suffix <- "tetrag"
	data$dict.name <- sprintf("%s.pr.975", corpus)
	data <- nGramization(data)

	rm(data)
	gc()
}
