setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("model/ngrams.R")


#split corpus in tetragrams,
data <- list(corpus = "all.train")
data$txt <- readRDS("data/clean/all.train.rds")
data$chunkSize <- 10000
data$lines <- length(data$txt)
data$ids <- initIds(data)
data$seed <- 123456
data$ng <- 4
data$suffix <- "tetrag"
data$dict.name <- "all.pr.975"
data <- nGramization(data)

rm(data)
gc()