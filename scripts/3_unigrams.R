setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("model/ngrams.R")

filter <- c("<URL>", "<U>", "<S>", "<NN>", "<ON>", "<N>", "<T>" , "<D>", "<PN>", "<EMAIL>", "<HASH>", "<YN>", "<TW>")

summary = list()
for (corpus in c("blogs", "news", "twitter", "all")) {
	#split corpus in unigrams,
	data <- list(corpus = corpus)
	data$txt <- readRDS(sprintf("%s/%s.train.clean.rds", data.clean.dir, corpus))
	data$chunkSize <- 10000
	data$lines <- length(data$txt)
	data$ids <- initIds(data)
	data$ng <- 1
	data$suffix <- "unig"
	data <- nGramization(data)

	#get probability distribution of unigrams
	unig <- data$ngrams[order(-k)]
	idx <- which(unig$w == "<S>")
	unig[-idx, pr:= k / sum(k)] #discard <S>
	unig[-idx, sum.pr:= round(100 * cumsum(pr), 4)]
	ngram.file <- sprintf("%s/%s.%s.rds", model.data.dir, data$corpus, data$suffix)
	saveRDS(unig, ngram.file)

	#save dictionaries, 95, 97.5 and 99 quantile
	dict <- c(unig[sum.pr <= 95, w], "<S>")
	dict <- dict[order(dict)]
	saveRDS(dict, sprintf("%s/dict.%s.pr.%s.rds", model.data.dir, corpus, "95"))

	dict <- c(unig[sum.pr <= 97.5, w], "<S>")
	dict <- dict[order(dict)]
	saveRDS(dict, sprintf("%s/dict.%s.pr.%s.rds", model.data.dir, corpus, "975"))

	dict <- c(unig[sum.pr <= 99, w], "<S>")
	dict <- dict[order(dict)]
	saveRDS(dict, sprintf("%s/dict.%s.pr.%s.rds", model.data.dir, corpus, "99"))

	#save stats to summary
	stats = list()
	stats$words.total <- sum(unig$k[-idx])
	stats$words.line <- round(sum(unig$k[-idx]) / (data$chunkSize * nrow(data$ids)), 2)
	stats$words.length <- round(unig[-idx, sum(nchar(w) * k)] / sum(unig$k[-idx]), 2)
	stats$stop.words <- unig[w %in% stopwords(), round(100 * sum(pr), 2)]
	summary[[corpus]] = stats

}

saveRDS(summary, "model/data/unig.summary.rds")
#hist(log10(unig.pr.95$k), breaks = 50)
#hist(log10(unig.pr.975$k), breaks = 50)


