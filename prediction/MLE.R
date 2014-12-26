library(data.table)

#4gram model, predict w4 using w1,w2,w3 as predictors
model.w1w2w3 <- function(dt, k.min = 2, n.top = 1) {
	dt <- dt[, .(w4, k, s=round(k/sum(k), 6)), by=.(w1,w2,w3)]
	dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=.(w1,w2,w3)]
	dt[, k:=NULL]
	setkey(dt, w1,w2,w3)
	dt
}


#3gram model, predict w4 using w2,w3 as predictors
model.w2w3 <- function(dt, k.min = 2, n.top = 1) {
	dt <- dt[, .(k=sum(k)), by=.(w2,w3,w4)]
	dt[, s:=round(k/sum(k), 6), by=.(w2,w3)]
	dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=.(w2,w3)]
	dt[, k:=NULL]
	setkey(dt, w2,w3)
	dt
}


#2gram model, predict w4 using w3 as predictor
model.w3 <- function(dt, k.min = 2, n.top = 1) {
	dt <- dt[, .(k=sum(k)), by=.(w3,w4)]
	dt[, s:=round(k/sum(k), 6), by=.(w3)]
	dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=.(w3)]
	dt[, k:=NULL]
	setkey(dt, w3)
	dt
}


#extended model, 4gram, partial matches, w1,w3 => w4
model.w1w3 <- function(dt, k.min = 2, n.top = 1) {
	dt <- dt[, .(k=sum(k)), by=list(w1,w3,w4)]
	dt[, s:= round(k/sum(k), 6), by=list(w1,w3)]
	dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=list(w1,w3)]
	setkey(dt, w1,w3)
	dt[, k:=NULL]
	dt
}


#extended model, 4gram, partial matches, w1,w2 => w4
model.w1w2 <- function(dt, k.min = 2, n.top = 1) {
	dt <- dt[, .(k=sum(k)), by=list(w1,w2,w4)]
	dt[, s:= round(k/sum(k), 6), by=list(w1,w2)]
	dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=list(w1,w2)]
	setkey(dt, w1,w2)
	dt[, k:=NULL]
	dt
}


#extended model, 4gram, partial matches, w1 => w4
model.w1 <- function(dt, k.min = 2, n.top = 1) {
	dt <- dt[, .(k=sum(k)), by=list(w1,w4)]
	dt[, s:= round(k/sum(k), 6), by=list(w1)]
	dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=list(w1)]
	setkey(dt, w1)
	dt[, k:=NULL]
	dt
}


#extended model, 3gram, partial matches, w2 => w4
model.w2 <- function(dt, k.min = 2, n.top = 1) {
	dt <- dt[, .(k=sum(k)), by=list(w2,w4)]
	dt[, s:= round(k/sum(k), 6), by=list(w2)]
	dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=list(w2)]
	setkey(dt, w2)
	dt[, k:=NULL]
	dt
}


#unigram model, necessary for backoff in PR calculations
model.w4 <- function(dt) {
	dt <- tetr[, .(k=sum(k)), by=.(w4)]
	dt[, s:=round(k/sum(k), 6)]
	dt[, k:=NULL]
	setkey(dt, w4)
	dt
}
