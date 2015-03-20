library(RWeka)
library(R.utils)
library(data.table)

#' create an Ngram tokenizer, that uses \code{RWeka::NGramTokenizer} to split a
#' text in ngrams
#' @param ng, an integer, indicates length of the ngrams, i.e., for ng = 2, the
#' text will be splitted in bigrams, for ng = 3, in trigrams, etc.
#' @return a function that accepts text as input and returns a vector of ngrams
tokenizer <- function(ng) {
	#' splits a string in ngrams
	#' @param x the string to be tokenized
	#' @return a vector containing the ngrams
	t <- function(x)
			RWeka::NGramTokenizer(x, RWeka::Weka_control(min = ng, max = ng, delimiters = " \\r\\n\\t"))
}


#' build a ngrams data table
#' @param data a list that holds all the config settings
#' @param data$txt vector, text corpus that is being processed, one document per line
#' @param data$lines integer, number of documents in the corpus
#'
nGramization <- function(data) {
	if (is.null(data$txt)) {
		data$txt <- readRDS(sprintf("%s/%s.rds", data.clean.dir, data$corpus))
	}

	if(is.null(data$lines)) {
		data$lines <- length(data$txt)
	}

	if(is.null(data$ids)) {
		#in case we are not working with all the data, sample the ids
		if (!is.null(data$chunkNumber) & (data$chunkSize * data$chunkNumber) < data$lines) {
			data$ids <- sampleIds(data)
		} else {
			data$ids <- initIds(data)
		}
	}

	data$tokenizer <- tokenizer(data$ng)
	data$maxLength <- 25 + 15 * (data$ng -1)
	if (data$ng > 1) {
		if(is.null(data$dict.name)) {
			data$dict.name <- "pr.975"
		}
		data$dict <- readRDS(sprintf("%s/dict.%s.rds", model.data.dir, data$dict.name))
	}
	t <- system.time(buildNGramChunks(data))
	printf("%d chunks built in %.3f sec.\n", nrow(data$ids), t[3])
	t <- system.time(data <- mergeFileChunks(data))
	printf("%d chunks merged in %.3f \n\n\n", nrow(data$ids), t[3])
	data
}


#' split data in Ngram chunks, save 1 file per chunk
buildNGramChunks <- function(data) {
	ids <- data$ids
	txt <- data$txt
	tokenizer <- data$tokenizer
	maxLength <- data$maxLength
	dict <- data$dict
	ng <- data$ng
	chunk.file <- sprintf("%s/%s.%s.%%d.rds", model.data.dir, data$corpus, data$suffix)
	for(n in 1:nrow(ids)) {
		t0 = Sys.time()
		ngrams.tmp <- nGramizeChunk(txt[ids[n,]], tokenizer, maxLength, ng, dict)
		saveRDS(ngrams.tmp, sprintf(chunk.file, n))
		rm(ngrams.tmp)
		printf("chunk %d built in %.3f \n", n, Sys.time() - t0)
	}
}


#' merge file chunks to obtain one single data table
mergeFileChunks <- function(data) {
	chunk.file <- sprintf("%s/%s.%s.%%d.rds", model.data.dir, data$corpus, data$suffix)
	tmp.file <- sprintf(chunk.file, 1)
	ngrams <- readRDS(tmp.file)
	file.remove(tmp.file)
	for(n in 2:nrow(data$ids)) {
		t0 = Sys.time()
		tmp.file <- sprintf(chunk.file, n)
		ngrams.tmp <- readRDS(tmp.file)
		ngrams <- mergeChunks(ngrams, ngrams.tmp)
		rm(ngrams.tmp)
		file.remove(tmp.file)
		printf("chunk %d merged in %.3f \n", n, Sys.time() - t0)
	}
	if (data$ng > 1) {
		ngrams[,w:=NULL]
	}
	ngram.file <- sprintf("%s/%s.%s.rds", model.data.dir, data$corpus, data$suffix)
	saveRDS(ngrams, ngram.file)
	data$ngrams <- ngrams
	data
}


#convert chunk of text lines into a data table containing ngrams counts
nGramizeChunk <- function(lines, tokenizer, maxLength, ng, dict = NULL) {
	ngrams <- tokenizer(lines)
	ngrams <- ngrams[nchar(ngrams) <= maxLength]
	dt <- data.table(w=ngrams, k=1)
	setkey(dt, w)
	dt <- dt[, list(k=sum(k)), by=w]
	rm(ngrams)
	if (ng > 1) {
		dt <- splitNGrams(dt, ng, dict)
		if(ng == 2) {
			dt <- dt[, list(k=sum(k)), by=list(w1, w2)]
		} else if (ng == 3) {
			dt <- dt[, list(k=sum(k)), by=list(w1, w2, w3)]
		} else if (ng == 4) {
			dt <- dt[, list(k=sum(k)), by=list(w1, w2, w3, w4)]
		}
		# need to rebuild the w column, since it might have changed due to the <U>'s
		dt$w <- do.call(paste,  subset(dt, select = !colnames(dt) %in% c("k", "w")))
	}
	dt
}


#split ngram, create one colum for each term
splitNGrams <- function(dt, ng, dict) {
	tmp <- strsplit(as.character(dt$w), " ")
	dt[, w1:=sapply(tmp, "[", 1)]
	if (ng == 2) {
		dt[, w2:=sapply(tmp, "[", 2)]
		dt[!w2 %in% dict, w2:="<U>"]
	} else if (ng == 3) {
		dt[, w2:=sapply(tmp, "[", 2)]
		dt[, w3:=sapply(tmp, "[", 3)]
		#replace words not in dictionary with special mark
		dt[!w2 %in% dict, w2:="<U>"]
		dt[!w3 %in% dict, w3:="<U>"]
	} else if (ng == 4) {
		dt[, w2:=sapply(tmp, "[", 2)]
		dt[, w3:=sapply(tmp, "[", 3)]
		dt[, w4:=sapply(tmp, "[", 4)]
		#replace words not in dictionary with special mark
		dt[!w2 %in% dict, w2:="<U>"]
		dt[!w3 %in% dict, w3:="<U>"]
		dt[!w4 %in% dict, w4:="<U>"]
	}
	#replace words not in dictionary with special mark
	dt[!w1 %in% dict, w1:="<U>"]
	dt
}


#merge 2 ngrams tables in one
mergeChunks <- function(a, b) {
	setkey(a, w);setkey(b, w)
	a$k[a$w %in% b$w] <-  a$k[a$w %in% b$w] + b$k[b$w %in% a$w]
	a <- rbindlist(list(a, b[!w %in% a$w]))
	rm(b)
	setkey(a,w)
	a
}


#sample ids without replacement, chunks of size chunkSize are returned
sampleIds <- function(data) {
	if (is.null(data$seed)) {
		data$seed = 123456
	}
	set.seed(data$seed)
	sampled <- sample(1:data$lines, data$chunkNumber * data$chunkSize, replace = F)
	matrix(sampled, nrow = data$sampleSize, ncol = data$chunkSize, byrow = T)
}


#return ids of lines to be used in testing, ie, lines excluded from the training set
testIds <- function(data) {
	if (is.null(data$ids)) {
		data$ids <- sampleIds(data)
	}
	matrix(setdiff(1:data$lines, c(data$ids)), nrow = data$sampleSize, ncol = data$chunkSize, byrow = T)
}


#order ngram table by occurrences count in decreasing order
orderNGrams <- function(dt) {
	dt[order(dt$k, decreasing = T),]
}