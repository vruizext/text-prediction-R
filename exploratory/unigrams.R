setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

library(stringi)
library(ggplot2)

uni.all <- readRDS("model/data/all.unig.rds")
uni.bl <-  readRDS("model/data/blogs.unig.rds")
uni.nw <-  readRDS("model/data/news.unig.rds")
uni.tw <-  readRDS("model/data/twitter.unig.rds")

uni.sum <- readRDS("model/data/unig.summary.rds")

#ratio of singleton words
round(nrow(uni.all[k == 1]) / nrow(uni.all), 2)
round(nrow(uni.bl[k == 1]) / nrow(uni.bl), 2)
round(nrow(uni.nw[k == 1]) / nrow(uni.nw), 2)
round(nrow(uni.tw[k == 1]) / nrow(uni.tw), 2)

#top 20 words
uni.all[1:21, sum(pr, na.rm=T)] * 100
uni.bl[1:21, sum(pr, na.rm=T)] * 100
uni.nw[1:21, sum(pr, na.rm=T)] * 100
uni.tw[1:21, sum(pr, na.rm=T)] * 100
#top 50 words
uni.all[1:51, sum(pr, na.rm=T)] * 100
uni.bl[1:51, sum(pr, na.rm=T)] * 100
uni.nw[1:51, sum(pr, na.rm=T)] * 100
uni.tw[1:51, sum(pr, na.rm=T)] * 100
#top 100 words
uni.all[1:101, sum(pr, na.rm=T)] * 100
uni.bl[1:101, sum(pr, na.rm=T)] * 100
uni.nw[1:101, sum(pr, na.rm=T)] * 100
uni.tw[1:101, sum(pr, na.rm=T)] * 100
#50% quantile
round(100 * nrow(uni.all[sum.pr <= 50]) / nrow(uni.all), 6)
round(100 * nrow(uni.bl[sum.pr <= 50]) / nrow(uni.bl), 6)
round(100 * nrow(uni.nw[sum.pr <= 50]) / nrow(uni.nw), 6)
round(100 * nrow(uni.tw[sum.pr <= 50]) / nrow(uni.tw), 6)
#75% quantile
round(100 * nrow(uni.all[sum.pr <= 75]) / nrow(uni.all), 6)
round(100 * nrow(uni.bl[sum.pr <= 75]) / nrow(uni.bl), 6)
round(100 * nrow(uni.nw[sum.pr <= 75]) / nrow(uni.nw), 6)
round(100 * nrow(uni.tw[sum.pr <= 75]) / nrow(uni.tw), 6)
#90% quantile
round(100 * nrow(uni.all[sum.pr <= 90]) / nrow(uni.all), 6)
round(100 * nrow(uni.bl[sum.pr <= 90]) / nrow(uni.bl), 6)
round(100 * nrow(uni.nw[sum.pr <= 90]) / nrow(uni.nw), 6)
round(100 * nrow(uni.tw[sum.pr <= 90]) / nrow(uni.tw), 6)
#95% quantile
round(100 * nrow(uni.all[sum.pr <= 95]) / nrow(uni.all), 6)
round(100 * nrow(uni.bl[sum.pr <= 95]) / nrow(uni.bl), 6)
round(100 * nrow(uni.nw[sum.pr <= 95]) / nrow(uni.nw), 6)
round(100 * nrow(uni.tw[sum.pr <= 95]) / nrow(uni.tw), 6)
#97.5% quantile
round(100 * nrow(uni.all[sum.pr <= 97.5]) / nrow(uni.all), 6)
round(100 * nrow(uni.bl[sum.pr <= 97.5]) / nrow(uni.bl), 6)
round(100 * nrow(uni.nw[sum.pr <= 97.5]) / nrow(uni.nw), 6)
round(100 * nrow(uni.tw[sum.pr <= 97.5]) / nrow(uni.tw), 6)
#99% quantile
round(100 * nrow(uni.all[sum.pr <= 99]) / nrow(uni.all), 6)
round(100 * nrow(uni.bl[sum.pr <= 99]) / nrow(uni.bl), 6)
round(100 * nrow(uni.nw[sum.pr <= 99]) / nrow(uni.nw), 6)
round(100 * nrow(uni.tw[sum.pr <= 99]) / nrow(uni.tw), 6)

dict.coverage <- function(uni, quantile) {
	round(100 * nrow(uni[sum.pr <= quantile]) / nrow(uni), 5)
}

#most frequent words
ggplot(head(uni.all, 25), aes(x=w,y=k), ) + geom_bar(stat="Identity", fill="red") + ggtitle("Top 25 unigrams") + theme(axis.text=element_text(size=8), legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) + scale_x_discrete(limits = uni.all$w[1:25])

ggplot(head(uni.bl, 25), aes(x=w,y=k), ) + geom_bar(stat="Identity", fill="red") + ggtitle("Top 25 unigrams") + theme(axis.text=element_text(size=8), legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) + scale_x_discrete(limits = uni.bl$w[1:25])

ggplot(head(uni.nw, 25), aes(x=w,y=k), ) + geom_bar(stat="Identity", fill="red") + ggtitle("Top 25 unigrams") + theme(axis.text=element_text(size=8), legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) + scale_x_discrete(limits = uni.nw$w[1:25])

ggplot(head(uni.tw, 25), aes(x=w,y=k), ) + geom_bar(stat="Identity", fill="red") + ggtitle("Top 25 unigrams") + theme(axis.text=element_text(size=8), legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) + scale_x_discrete(limits = uni.tw$w[1:25])

# length of words
uni.all[, l:=nchar(w)]
ggplot(uni.all, aes(x=l)) + geom_histogram( binwidth=0.5, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10))  + ggtitle("Unigrams length distribution")

uni.bl[, l:=nchar(w)]
ggplot(uni.bl, aes(x=l)) + geom_histogram( binwidth=0.5, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10))  + ggtitle("Unigrams length distribution")

uni.nw[, l:=nchar(w)]
ggplot(uni.nw, aes(x=l)) + geom_histogram( binwidth=0.5, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10))  + ggtitle("Unigrams length distribution")

uni.tw[, l:=nchar(w)]
ggplot(uni.tw, aes(x=l)) + geom_histogram( binwidth=0.5, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10))  + ggtitle("Unigrams length distribution")

# frequency distribution
ggplot(uni.all, aes(x=k)) + geom_histogram( binwidth=0.22, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) +  scale_x_log10() + ggtitle("Frequency of unigrams occurences")

ggplot(uni.bl, aes(x=k)) + geom_histogram( binwidth=0.22, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) +  scale_x_log10() + ggtitle("Frequency of unigrams occurences")

ggplot(uni.nw, aes(x=k)) + geom_histogram( binwidth=0.22, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) +  scale_x_log10() + ggtitle("Frequency of unigrams occurences")

ggplot(uni.tw, aes(x=k)) + geom_histogram( binwidth=0.22, aes(fill = "red"))  + theme(legend.position="none", legend.title=element_blank(), legend.position="none", axis.title=element_text(size=10), plot.title=element_text(size=10)) +  scale_x_log10() + ggtitle("Frequency of unigrams occurences")
