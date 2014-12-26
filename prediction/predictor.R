library(data.table)

#build the function that it's going to be used to predict in the test
predictor.build <- function(model, mode) {
	switch(mode,
		backoff = function(w1, w2, w3) predict.backoff(model, w1, w2, w3),
		interp = function(w1, w2, w3) predict.interp(model, w1, w2, w3),
		interp.ext = function(w1, w2, w3) predict.interp.ext(model, w1, w2, w3),
		pr = function(w1, w2, w3, w4) get.PR(model, w1, w2, w3, w4),
		pr.ext = function(w1, w2, w3, w4) get.PR.ext(model, w1, w2, w3, w4)
	)
}


#prediction using backoff, 4grams, 3grams, 2grams and unigrams models
predict.backoff <- function(model, t1, t2, t3) {
	if(is.null(model$coef)) {
		#coefficients for interpolation, default value
		a123 = 0.95 ;
		a23 = 0.04; a3 = 0.01;
	} else {
		a123 <- model$coef$a123
		a23 <- model$coef$a23
		a3 <- model$coef$a3
	}
	#search 4gram, full match
	q <- model$w1w2w3[list(t1, t2, t3), .(w4, s)]
	if(nrow(q) > 0 & q[1,s] > 0) {
		return(q)
	}
	#backoff to 3 gramm model
	q <- model$w2w3[list(t2, t3), .(w4, s=a23 * s)]
	if(nrow(q) > 0 & q[1,s] > 0) {
		return(q)
	}
	#backoff to bigrams
	q <- model$w3[t3, .(w4, s=a3 * s)]
	if(nrow(q) > 0 & q[1,s] > 0) { #& q[1,s] >= 0.01
		return (q)
	}
	return (data.table(w4="the", s=0))
}


#prediction using linear interpolation of 4grams, 3grams and 2grams models
predict.interp <- function(model, t1, t2, t3) {
	if(is.null(model$coef)) {
		#coefficients for interpolation, default value
		a123 = 0.95 ; #a12 = 0.75 * 0.2; a13 = 0.75 * 0.2; a1 = 0.75 * 0.1;
		a23 = 0.04; a3 = 0.01; #a2 = 0.25 * 0.25;
	} else {
		a123 <- model$coef$a123
		a23 <- model$coef$a23
		a3 <- model$coef$a3
	}
	#search 4gram, full match
	q123 <- model$w1w2w3[list(t1, t2, t3), .(w4, s)]
	#if the score is already higher than the maximum we can get from the other models,
	# it's not necessary to make more queries
	if(nrow(q123) > 0 & q123[1,s] > (a23 + a3) * 0.9) {
		return(q123)
	}
	#go for the trigrams
	q23 <- model$w2w3[list(t2, t3), .(w4, s=a23 * s)]
	q <- rbindlist(list(q123, q23))[, .(s=sum(s)), by=w4][order(-s)]
	#same here, check if the score is already enough to beat the lower order model
	if(nrow(q) > 0 & q[1,s] > a3 * 0.9) { #& q[1,s] >= 0.01
		return (q)
	}
	#if still dont have a winner, go for bigrams
	q3 <- model$w3[w3, .(w4, s=a3 * s)]
	q <- rbindlist(list(q, q3))[, .(s=sum(s)), by=w4][order(-s)]
	if(nrow(q) > 0 & q[1,s] > 0) {
		return (q)
	}
	#last option, return the most frequent unigrams
	if (t3 == "<S>") {
		return (data.table(w4="the", s=0))
	}
	return (data.table(w4="and", s=0))
}


#prediction using linear interpolation, model extended with partial matches
predict.interp.ext <- function(model, t1, t2, t3) {
	if(is.null(model$coef)) {
		#coefficients for interpolation, default values, optimized for max likelihood
		a123 = 0.33 * 0.35; a12 = 0.33 * 0.22;
		a13 = 0.33 * 0.33; a1 = 0.33 * 0.1;
		a23 = 0.33 * 1; a2 = 0.33 * 0; a3 = 0.32; a4 = 0.02
	} else {
		a123 <- model$coef$a123
		a12 <- model$coef$a12
		a13 <- model$coef$a13
		a1 <- model$coef$a1
		a2 <- model$coef$a2
		a23 <- model$coef$a23
		a3 <- model$coef$a3
	}
	#search 4gram, full match
	q <- model$w1w2w3[list(t1, t2, t3), .(w4, s=a123 * s)]
	if(!is.na(q[1,w4]) & q[1,s] >= (a23 + a2) * 0.9) {
		return (q)
	}
	#back off to 4grams, partial matches
	q12 <- model$w1w2[list(t1, t2), .(w4, s=a12 * s)]
	q13 <- model$w1w3[list(t1, t3), .(w4, s=a13 * s)]
	q1 <- model$w1[list(t1), .(w4, s=a1 * s)]
	q <- rbindlist(list(q, q12, q13))[, .(s=sum(s)), by=w4][order(-s)]
	if(!is.na(q[1,w4]) & q[1,s] >= (a23 + a2) * 0.9) {
		return(q)
	}
	#back off, 3grams
	q23 <- model$w2w3[list(t2, t3), .(w4, s=a23 * s)]
	q2 <- model$w2[list(t2), .(w4, s=a2 * s)]
	q <- rbindlist(list(q, q23, q2))[, .(s=sum(s)), by=w4][order(-s)]
	if(!is.na(q[1,w4]) & q[1,s] > a3 * 0.9) {
		return(q)
	}
	#back off, bigrams
	q3 <- model$w3[list(t3), .(w4, s=a3 * s)]
	q <- rbindlist(list(q, q3))[, .(s=sum(s)), by=w4][order(-s)]
	if(!is.na(q[1,w4])) {
		return (q)
	}
	#last option, return the most frequent unigrams
	if (t3 == "<S>") {
		return (data.table(w4="the", s=0))
	}
	return (data.table(w4="and", s=0))
}


#get next word prediction, ie, the first word (highest probability) returned
get.w4 <- function(predictor, t1, t2, t3) {
	predictor(t1, t2, t3)[1, .(w4, s)]
}


#get probability assigned by the model to a given ngram
get.PR <- function(model, t1 = F, t2 = F, t3 = F, t4 = F) {
	if(is.null(model$coef)) {
		#coefficients for interpolation, default value
		a123 = 0.75; a23 = 0.14; a3 = 0.1; a4 = 0.01
	} else {
		a123 <- model$coef$a123
		a23 <- model$coef$a23
		a3 <- model$coef$a3
		a4 <- model$coef$a4
	}
	#search 4gram, full match
	q123 <- model$w1w2w3[list(t1, t2, t3, t4), .(s=a123 * s)][1,s]
	q23 <- model$w2w3[list(t2, t3, t4), .(s=a23 * s)][1,s]
	q3 <- model$w3[list(t3, t4), .(s=a3 * s)][1,s]
	q4 <- model$w4[list(t4), .(s=a4 * s)][1,s]
	sum(c(q123, q23, q3, q4), na.rm=T)
}


#get probability assigned by the model to a given ngram
#model extended with partial matches for 4-grams and trigrams
get.PR.ext <- function(model, t1 = F, t2 = F, t3 = F, t4 = F) {
	if(is.null(model$coef)) {
		#coefficients for interpolation, default value
		a123 = 0.75 * 0.85; a12 = 0.75 * 0.05; a13 = 0.75 * 0.05; a1 = 0.75 * 0.05;
		a23 = 0.24 * 0.85; a2 = 0.15 * 0.24; a3 = 0.05; a4 = 0.01
	} else {
		a123 <- model$coef$a123
		a12 <- model$coef$a12
		a13 <- model$coef$a13
		a1 <- model$coef$a1
		a2 <- model$coef$a2
		a23 <- model$coef$a23
		a3 <- model$coef$a3
		a4 <- model$coef$a4
	}
	#search 4gram, full match
	q123 <- model$w1w2w3[list(t1, t2, t3, t4), .(s=a123 * s)][1,s]
	#4grams partial matches
	q12 <- model$w1w2[list(t1, t2, t4), .(s=a12 * s)][1,s]
	q13 <- model$w1w3[list(t1, t3, t4), .(s=a13 * s)][1,s]
	q1 <- model$w1[list(t1, t4), .(s=a1 * s)][1,s]
	q23 <- model$w2w3[list(t2, t3, t4), .(s=a23 * s)][1,s]
	q2 <- model$w2[list(t2, t4), .(s=a2 * s)][1,s]
	q3 <- model$w3[list(t3, t4), .(s=a3 * s)][1,s]
	q4 <- model$w4[list(t4), .(s=a4 * s)][1,s]
	sum(c(q123,  q12, q13, q23, q1, q2, q3, q4), na.rm=T)
}
