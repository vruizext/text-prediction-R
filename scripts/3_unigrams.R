setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("model/ngrams.R")

#split corpus in unigrams,
data <- list(corpus = "all.train")
data$txt <- readRDS("data/clean/all.train.rds")
data$chunkSize <- 10000
data$lines <- length(data$txt)
data$ids <- initIds(data)
data$ng <- 1
data$suffix <- "unig"

data <- nGramization(data)

#get probability distribution of unigrams
unig <- data$ngrams[order(-k)]
unig[-1, pr:= k / sum(k)] #discard <S>
unig[-1, sum.pr:= round(100 * cumsum(pr), 4)]
#unig[k >=100]

#total words and avg words per line
words.total <- sum(unig$k[-1])
words.line <- words.total / (data$chunkSize * nrow(data$ids))

#get quantiles 95, 97.5 and 99
unig.pr.95 <- unig[sum.pr <= 95]
unig.pr.975 <- unig[sum.pr <= 97.5]
unig.pr.99 <- unig[sum.pr <= 99]

hist(log10(unig.pr.95$k), breaks = 50)
hist(log10(unig.pr.975$k), breaks = 50)

#save dictionaries, 95, 97.5 and 99 quantile
dict <- c(unig.pr.95$w, "<S>")
dict <- dict[order(dict)]
saveRDS(dict, "model/data/dict.all.pr.95.rds")

dict <- c(unig.pr.975$w, "<S>")
dict <- dict[order(dict)]
saveRDS(dict, "model/data/dict.all.pr.975.rds")

dict <- c(unig.pr.99$w, "<S>")
dict <- dict[order(dict)]
saveRDS(dict, "model/data/dict.all.pr.99.rds")
