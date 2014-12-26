library(shiny)
library(wordcloud)
library(markdown)
source("predictor.R")
#print(getwd())
model <- readRDS("modelMLE.prod.all.ext.kmin.2.1.top.3.2.rds")
model$coef <- list(a123 = 0.55 * 0.35, a12 = 0.55 * 0.22,
				   a13 = 0.55 * 0.33, a1 = 0.55 * 0.1,
				   a23 = 0.23 * 1, a2 = 0, a3 = 0.2, a4 = 0.02)

dict <- readRDS("dict.all.pr975.rds")


