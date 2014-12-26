#set working directory to the project root folder
setwd(paste0(dirname(parent.frame(2)$ofile), "/.."))

#download corpus and unzip
dir.create("data", showWarnings = FALSE)
dir.create("data/raw", showWarnings = FALSE)
url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
fileName = "data/raw/Coursera-SwiftKey.zip"
download.file(url, method="curl", destfile = fileName)
unzip(fileName, exdir = "data/raw")

locale <- "en_US"
data.raw.dir <- "data/raw"

#save text files as RDS, it's compressed and it takes shorter to load the files in R
for (src in c('blogs', 'news', 'twitter')) {
	txt <- readLines(sprintf("%s/final/%s/%s.%s.txt", data.raw.dir, locale, locale, src), skipNul = T,
					 	encoding="UTF-8")
	saveRDS(txt, sprintf("%s/%s.rds", data.raw.dir, src))
}
