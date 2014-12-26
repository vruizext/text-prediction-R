locale <- "en_US"
data.raw.dir <- "data/raw"
data.clean.dir <- "data/clean"
model.data.dir <- "model/data"
prediction.data.dir <- "prediction/data"

if (!file.exists(data.clean.dir)) {
	dir.create(data.clean.dir, showWarnings = FALSE)
}

if (!file.exists(model.data.dir)) {
	dir.create(model.data.dir, showWarnings = FALSE)
}

if (!file.exists(prediction.data.dir)) {
	dir.create(prediction.data.dir, showWarnings = FALSE)
}

#creates a matrix distributing ids of the lines in chunks of size chunkSize
initIds <- function(data) {
	chunkNumber <- round(data$lines / data$chunkSize)
	chunks <- 1:chunkNumber
	idx <- matrix(1:(data$chunkSize * chunkNumber), nrow = chunkNumber, ncol = data$chunkSize, byrow = T)
	if((data$lines / data$chunkSize) > chunkNumber) {
		lastIds <- ((data$lines / data$chunkSize) - chunkNumber) * data$chunkSize
		lastRow <- rep(NA, data$chunkSize)
		lastRow[1:lastIds] <- (data$chunkSize * chunkNumber) + (1:lastIds)
		idx <- rbind(idx, lastRow)
	}
	idx
}