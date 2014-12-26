setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))
source("scripts/globals.R")
library(R.utils)
set.seed(12345)

# sample corpus files, save separate files for training, devtesting and testing

# percent of total lines used in training, dev.testing and testing stages
# the higher the percentage of data used in training, the higher the accuracy, but
# also the higher the sparsity of data and the memory/time required to process the data
training <- 5
devtesting <- 1
testing <- 1

#total can't excede 100 %
if( (training + devtesting + testing) > 100) {
	testing <- 100 - training - devtesting
}

all.train <- c()
all.test <- c()
all.devtest <- c()
for (src in c('blogs', 'news', 'twitter')) {
	txt <- readRDS(sprintf("%s/%s.rds", data.raw.dir, src))
	numLines <- length(txt)
	sampleSize <- ceiling(numLines * training / 100)
	sampledIds <- sample(1:length(txt), sampleSize) #for training
	sampledLines <- txt[sampledIds]
	all.train <- c(all.train, sampledLines)
	#save one file with sampled training data from each corpus
	saveRDS(sampledLines, sprintf("%s/%s.train.rds", data.raw.dir, src))

	txt <- txt[-sampledIds]
	sampleSize <- ceiling(numLines * devtesting / 100)
	sampledIds <- sample(1:length(txt), sampleSize) #for testing
	sampledLines <- txt[sampledIds]
	all.devtest <- c(all.devtest, sampledLines)
	saveRDS(sampledLines, sprintf("%s/%s.devtest.rds", data.raw.dir, src))

	txt <- txt[-sampledIds]
	sampleSize <- round(numLines * testing / 100)
	if (sampleSize >= length(txt)) {
		sampledLines <- txt
	} else {
		sampledIds <- sample(1:length(txt), sampleSize) #  for testing
		sampledLines <- txt[sampledIds]
	}
	all.test <- c(all.test, sampledLines)
	saveRDS(sampledLines, sprintf("%s/%s.test.rds", data.raw.dir, src))
}
#save files containing data samples from all corpus
saveRDS(all.train, sprintf("%s/all.train.rds", data.raw.dir))
saveRDS(all.devtest, sprintf("%s/all.devtest.rds", data.raw.dir))
saveRDS(all.test, sprintf("%s/all.test.rds", data.raw.dir))




