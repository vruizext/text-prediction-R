library(stringi)
library(R.utils)
library(data.table)

#prediction using interpolation, model extended with partial matches for 4-grams
predict.interp <- function(model, t1, t2, t3) {
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
	q123 <- model$w1w2w3[list(t1, t2, t3), .(w4, s=a123 * s)]
	#back off to 4grams, partial matches
	q12 <- model$w1w2[list(t1, t2), .(w4, s=a12 * s)]
	q13 <- model$w1w3[list(t1, t3), .(w4, s=a13 * s)]
	q1 <- model$w1[list(t1), .(w4, s=a1 * s)]
	q23 <- model$w2w3[list(t2, t3), .(w4, s=a23 * s)]
	q3 <- model$w3[list(t3), .(w4, s=a3 * s)]
	q <- rbindlist(list(q123, q12, q13, q1, q23, q3))[, .(s=sum(s)), by=w4][order(-s)]
	if(!is.na(q[1,w4])) {
		return (q[complete.cases(q)])
	}
	#last option, return the most frequent unigrams
	if (t3 == "<S>") {
		return (data.table(w4="the", s=0))
	}
	return (data.table(w4="and", s=0))
}

filter <- c("<URL>", "<U>", "<S>", "<NN>", "<ON>", "<N>", "<T>" , "<D>", "<PN>", "<EMAIL>", "<HASH>", "<YN>", "<TW>")


#clean a single chunk of text
cleanText <- function(txt, stemming = F) {
	#stem text
	if (stemming) {
		txt <- stemText(txt)
	}
	#short form of common names: st., av., mr, etc.., remove periods
	txt <- gsub("\\s([A-Z])\\.\\s", " \\1", txt)
	txt <- gsub("\\s([A-Z][a-z]{1,3})\\.\\s", " \\1", txt)
	txt <- gsub("^([A-Z])\\.\\s", " \\1", txt)
	txt <- gsub("^([A-Z][a-z]{1,3})\\.\\s", " \\1", txt)
	#lower case text
	txt <- stri_trans_tolower(txt)
	#remove smileys
	txt <- gsub("<3|</3|\\bxd\\b|\\bx-d\\b|:&|:-&|:p\\b|:-p\\b|\\b=p\\b|\\b:d\\b|;d\\b|\\b:o\\)\\b|\\b8\\)|\\b8d\\b|\\b8-d\\b|:3\\b|:-x\\b|:x\\b|:o\\)|:-d\\b|:-o\\b|:o\\b|o_o\\b|o-o\\b|=p\\b|:s\\b|\\bd:", " ", txt)
	# remove lower greater symbols
	txt <- gsub("[<>]+", " ", txt)
	txt <- gsub("&", " and ", txt)
	#dont split compound words, like e-reader, e-mail, etc...
	txt <- gsub("(^|\\s)([a-z]{1,2})-([a-z]+)", " \\2\\3 ", txt)
	#remove RTs
	txt <- gsub("\\brt\\b", " ", txt)
	txt <- gsub("rt2win", " ", txt)
	txt <- gsub("<3RT", " ", txt)
	#replace email addresses with special mark
	txt <- gsub("\\w*@\\w*\\.\\w*", " <EMAIL> ", txt)
	#replae hashtags with special marker
	txt <- gsub("(\\#[a-zA-Záéíóúàèìòùäöüßñ0-9']+)", " <HASH> ", txt)
	#replace twitter-like names with special marker
	txt <- gsub("\\@\\w*[a-zA-Záéíóúàèìòùäöüßñ0-9]+\\w*", " <TW> ", txt)
	# replace URLs with special mark
	txt <- gsub("\\b([a-z]{3,6}://)?([\\0-9a-z\\-]+\\.)+([a-z]{2,6})+(/[\\0-9a-z\\?\\=\\&\\-_]*)*", " <URL> ", txt)
	#remove slashes
	txt <- gsub("[\\\\\\/\\|]+", " ", txt)
	#single words between quotes or parenthesis, remove the quotes or parenthesis
	txt <- gsub("\\s“([a-z]+)”\\s", " \\1 ", txt)
	txt <- gsub("\\s’([a-z]+)’\\s", " \\1 ", txt)
	txt <- gsub("\\s'([a-z]+)'\\s", " \\1 ", txt)
	txt <- gsub('\\s"([a-z]+)"\\s', " \\1 ", txt)
	txt <- gsub("\\((\\s?[a-z]+\\s?)\\)", "\\1", txt)
	#only one type of apostrophes, and only one at a time
	txt <- gsub("[’`']+", "'", txt)
	txt <- gsub("(\\.( )+)+", ". ", txt)
	# acronym or short form with apostrophe, just remove the period
	txt <- gsub("(^|\\.|\\s)([a-záéíóúàèìòùäöüßñ<>]+)\\.'([a-z])(\\s|\\.|$)", " \\2'\\3 ", txt)
	# replace numbers with special marker <N>
	txt <- gsub("([0-9]+([,\\.]?[0-9]+)?)", " <N> ", txt)
	#expressions refering time replaced with <T>
	txt <- gsub("<N>\\s:\\s<N>\\s?(a\\s|a\\.|p\\s|p\\.|am|pm|a\\.m|p\\.m)\\.?,?(\\s|$)", "<T> ", txt)
	txt <- gsub("<N>\\s:\\s<N>(\\s|$)", "<T>\\1", txt)
	txt <- gsub("(<N>)\\s+(am|pm|a\\.m|p\\.m|a\\s|a\\.|p\\s|p\\.)\\.?,?(\\s)?", "<T>\\3", txt)
	txt <- gsub("(<T>)\\s+(am|pm|a\\.m|p\\.m|a\\s|a\\.|p\\s|p\\.)\\.?,?(\\s)?", "<T>\\3", txt)
	txt <- gsub("(<N>)(\\s+)?-\\s+(<T>)", "<T> ", txt)
	txt <- gsub("(<T>)\\s+-\\s+(<N>)", "<T> ", txt)
	txt <- gsub("(<T>)(\\s+)?-(\\s+)?(<T>)", "<T> ", txt)
	txt <- gsub("<N>\\s+to\\s+<T>", "<T> to <T>", txt)
	txt <- gsub("<T>\\s+to\\s+<N>", "<T> to <T>", txt)
	txt <- gsub("(<T>)\\s+(am|pm|a\\.m|p\\.m|a|p)\\.?,?(\\s|$)", "<T>\\3", txt)
	#numbers reffering to % amounts, replaced with <PN>
	txt <- gsub("<N>( )*%", "<PN> ", txt)
	#numbers reffering to some year, like 80s, 90s... replaced with <YN>
	txt <- gsub("<N>\\s+('?s)\\.?(\\s|$)", "<YN> ", txt)
	#ordinal numbers replaced with <ON>
	txt <- gsub("<N>\\s+(st|th|nd|rd|er|ers)\\.?(\\s|$)", "<ON> ", txt)
	#number intervals, can be scores, telephone numbers, ...
	txt <- gsub("(<N>)\\s+-\\s+(<N>)", "<NN> ", txt)
	#numbers in parenthesis, remove parenthesis
	txt <- gsub("\\(\\s?<N>\\s?\\)", "<N>", txt)
	#numbers reffering to dates nov. 3, dec.1, etc...
	txt <- gsub(" (jan|feb|mar|apr|may|jun|jul|aug|sept|oct|nov|dec)\\.?,?\\s\\s?(<N>|<NN>)", "\\1 <D>", txt)
	txt <- gsub("(january|february|march|april|may|june|july|august|september|october|november|december),?\\s\\s?(<N>|<NN>)", "\\1 <D>", txt)
	#days of the week, short form, remove periods
	txt <- gsub(" (mon|tue|wed|thu|fri|sat|sun)\\.", "\\1", txt)
	#dont split compound words, like e-reader, e-mail, etc...
	txt <- gsub("(^|\\s)([a-z]{1,2})-([a-z]+)(\\s|\\.|\\$)", "\\2\\3", txt)
	#replaces commas with whitespace, don't break the sentence
	txt <- gsub("(,)+", " ", txt)
	#replace the rest of punctuation with single dots
	txt <- gsub("( )+-( )+", " . ", txt)
	txt <- gsub('[—!?;:…“”\\"()\\{\\}]+', " . ", txt)
	#remove remaining non characters
	txt <- gsub("[^0-9A-Za-záéíóúàèìòùäöüßñ.'<>]+", " ", txt)
	#remove periods in acronyms, so we can analyze them as a single word
	txt <- gsub("([a-z])\\.([a-z])\\.(([a-z])\\.)?(([a-z])\\.)?(\\s|$)?", " \\1\\2\\4\\6 ",  txt)
	#remove duplicate number marks, mostly due to decimal points, but should be fixed
	txt <- gsub("(<N>[ .']+){2,}", " <N> ", txt)
	#replace punctuation with special mark
	txt <- gsub("[.]+", " <S> ", txt)
	#replace end and start of string also with special mark
	#txt <- gsub("^(.*?)$", "<S> \\1 <S>",txt)
	#remove duplicate sentence marks, and marks at beggining or end of line
	txt <- gsub("(<S>[ ]*)+", " <S> ",txt)
	txt <- gsub("<S>[ ]*$", "",txt)
	txt <- gsub("^[ ]*<S>", "",txt)
	#remove duplicates apostrophes
	txt <- gsub("(^|\\s)('(\\s)*)+(\\s|$)", " ' ", txt)
	txt <- gsub("''", "'", txt)
	#remove apostrophes that are alone, ie, with any word
	txt <- gsub("(^|\\s)'(\\s|$)", " ", txt)

	#remove genitive signs that are alone
	txt <- gsub("(\\s)'s(\\s|$)", " ", txt)

	#remove single apostrophes in front of a word or at the end
	txt <- gsub("^'", "", txt)
	txt <- gsub("(^|\\s)'([a-záéíóúàèìòùäöüßñ<>]+)'?(\\s|$)", "\\1\\2 ", txt)
	txt <- gsub("(\\s)?([a-záéíóúàèìòùäöüßñ<>]+)'(\\s|$)", "\\1\\2 ", txt)
	txt <- gsub("\\s'([a-z])", " \\1", txt)

	#remove genitive signs in names and sustantives
	txt <- removeGenitives(txt)

	#fix <S> marks placed incorrectly
	txt <- gsub(" st <S>", " st ", txt)
	txt <- gsub(" ft <S>", " ft ", txt)
	txt <- gsub(" sq <S>", " sq ", txt)
	txt <- gsub("^st <S>", "st ", txt)
	txt <- gsub("^ft <S>", "ft ", txt)
	txt <- gsub("^sq <S>", "sq ", txt)
	txt <- gsub(" av <S>", " av ", txt)
	txt <- gsub("^av <S>", " av ", txt)
	txt <- gsub(" mr <S>", " mr ", txt)
	txt <- gsub("^mr <S>", "mr ", txt)
	txt <- gsub("^sgt <S>", "sgt ", txt)
	txt <- gsub(" sgt <S>", " sgt ", txt)
	txt <- gsub(" dep <S>", " dep ", txt)
	txt <- gsub("^dep <S>", "dep ", txt)
	txt <- gsub(" dept <S>", " dept ", txt)
	txt <- gsub("^dept <S>", "dept ", txt)
	txt <- gsub(" u <S> s( <S>)? ", "us ", txt)
	txt <- gsub("a <S> k <S> a ", "aka ", txt)
	txt <- gsub("v <S> i <S> p (<S>)?", "vip ", txt) #
	txt <- gsub("d <S> h <S>", "dh ", txt)
	txt <- gsub("p <S> s <S>", "ps ", txt)
	txt <- gsub("m <S> s <S>", "ms ", txt)
	txt <- gsub("r <S> i <S> p( <S>|$)?", "rip ", txt)
	txt <- gsub("<S> t <S> o <S> p ", " top ", txt)

	txt <- gsub("<T><N>(\\s|$)", "<N>", txt)
	txt <- gsub("<T><T>", "<T>", txt)
	txt <- gsub("<T><ON> ", "<N> st", txt)
	txt <- gsub("<S> ([a-z]) <S>", " \\1 ", txt)
	txt <- gsub("<S> ([a-z]+) <S>", " \\1 ", txt)
	txt <- gsub("^([a-z]+) <S>", "\\1 ", txt)
	txt <- gsub(">([a-z])", "> \\1", txt)
	txt <- gsub("([a-z])<", "\\1 ", txt)

	#q: ..  a: ...
	txt <- gsub("q <S>", " ", txt)
	txt <- gsub("<S> a <S>", "<S> ", txt)
	txt <- gsub("^a <S>", "", txt)
	txt <- gsub("^q <S>", "", txt)

	#remove extra whitespaces
	txt <- stripWhitespace(txt)
	txt <- stri_trim_both(txt)

	txt
}


no.stem <- c("it's", "he's", "she's", "let's", "here's", "there's", "that's", "how's", "what's",  "who's", "where's")

#apply stemGen to every word in the text, need to split the text and paste it again later
removeGenitives <- function(txt) {
	paste( sapply( strsplit(txt, " ")[[1]], stemGen), collapse = " ")
}

#remove all genitive signs but the verbal forms, he's, it's, there's, etc...
stemGen <- function(txt) {
	if(!txt %in% no.stem) {
		txt <- gsub("'s", "", txt)
	}
	txt
}
