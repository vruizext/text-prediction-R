setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("preprocess/preprocess.R")


## preprocess the text:
# * normalization
# * remove non ascii characters: apostrophes, quotes, punctuation, etc.
# * introduce end of sentence marks
# * replace numbers, dates, times, emails, urls, hashtags with special marks
# * remove genitive marks, but let 's for verbs

txt.clean = c()

for (corpus in c("blogs.train", "news.train", "twitter.train")) {
	data <- list()
	data$corpus <- corpus # corpus (file) which is being processed
	data$chunkSize <- 10000 # data processed in chunks of 10,000 lines each
	data$stemming <- F # don't apply stemming
	data$suffix <- "clean" # suffix added to the file name when saving output file
	data <- clean(data)

	txt.clean = c(txt.clean, data$clean)
}

saveRDS(txt.clean, sprintf("%s/%s.%s.rds", data.clean.dir, "all.train", "clean"))