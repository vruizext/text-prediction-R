setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

source("scripts/globals.R")
source("prediction/MLE.R")

data <- list(corpus = "all.train")
data$suffix <- "tetrag"
ngram.file <- sprintf("%s/%s.%s.rds", model.data.dir, data$corpus, data$suffix)
tetr <- readRDS(ngram.file)
setkey(tetr, w1,w2,w3)

filter <- c("<URL>", "<U>", "<S>", "<NN>", "<ON>", "<N>", "<T>" , "<D>", "<PN>", "<EMAIL>", "<HASH>", "<YN>", "<TW>")

#for production app, filter special words in the output
#tetr <- tetr[!w4 %in% filter]

#build the eight models, which will be linearly interpolated
k.min = 2; n.top = 3;
model = list()
model$w1w2w3 <- model.w1w2w3(tetr, k.min, n.top)
model$w2w3 <- model.w2w3(tetr, k.min, n.top)
model$w3 <- model.w3(tetr, k.min, n.top)
model$w4 <- model.w4(tetr)
model$w1w2 <- model.w1w2(tetr, k.min, n.top)
model$w1w3 <- model.w1w3(tetr, k.min, n.top)
model$w1 <- model.w1(tetr, k.min, n.top)
model$w2 <- model.w2(tetr, k.min, n.top)

model.name <- "MLE.all.ext"
model.file <- sprintf("%s/%s.kmin.%s.ntop.%s.rds", prediction.data.dir, model.name, k.min, n.top)
saveRDS(model, model.file)

