model <- readRDS("prediction/data/MLE.all.ext.kmin.2.ntop.3.rds")
model$w1w2w3
hist(round(model$w1w2w3$s, 2), breaks = 100, ylim=c(0, 20000))
hist(round(model$w2w3$s, 2), breaks = 100, ylim=c(0, 10000))
hist(round(model$w1w2$s, 2), breaks = 100, ylim=c(0, 10000))
hist(round(model$w1w3$s, 2), breaks = 100, ylim=c(0, 10000))
hist(round(model$w1$s, 2), breaks = 100, ylim=c(0, 10000))
hist(round(model$w2$s, 2), breaks = 100, ylim=c(0, 5000))
hist(round(model$w3$s, 2), breaks = 100, ylim=c(0, 5000))
