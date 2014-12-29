setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

library(stringi)
library(ggplot2)

filter <- c("<URL>", "<U>", "<S>", "<NN>", "<ON>", "<N>", "<T>" , "<D>", "<PN>", "<EMAIL>", "<HASH>", "<YN>", "<TW>")

bi.all <- readRDS("model/data/all.bi.rds")
bi.bl <-  readRDS("model/data/blogs.bi.rds")
bi.nw <-  readRDS("model/data/news.bi.rds")
bi.tw <-  readRDS("model/data/twitter.bi.rds")

bi.all$w <- do.call(paste,  subset(bi.all, select = !colnames(bi.all) %in% c("k")))
bi.all <- bi.all[!w1 %in% filter][!w2 %in% filter][order(-k)]

ggplot(head(bi.all, 20), aes(x=w,y=k), ) + geom_bar(stat="Identity", fill="red") + ggtitle("Top 20 bigrams") + theme(axis.text=element_text(size=5), legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) + scale_x_discrete(limits = bi.all$w[1:20])

ggplot(bi.all, aes(x=k)) + geom_histogram( binwidth=0.22, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) +  scale_x_log10() + ggtitle("Frequency of bigrams occurences")


bi.bl$w <- do.call(paste,  subset(bi.bl, select = !colnames(bi.bl) %in% c("k")))
bi.bl <- bi.bl[!w1 %in% filter][!w2 %in% filter][order(-k)]

ggplot(head(bi.bl, 20), aes(x=w,y=k), ) + geom_bar(stat="Identity", fill="red") + ggtitle("Top 20 bigrams") + theme(axis.text=element_text(size=5), legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) + scale_x_discrete(limits = bi.bl$w[1:20])
