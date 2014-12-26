shinyServer(
	function(input, output, clientData, session) {
		#read the input text
		input.text <- reactive({
			as.character(input$text)
		})

		#clean text, split it and return max 5 tokens
		input.words <- reactive({
			if(nchar(input.text() > 0)) {
				w <- cleanAndTokenize(input.text())
			} else {
				w <- c(FALSE)
			}
			w
		})

		#predict possible next words
		out.words <- reactive(prediction(input.words()))

		#return only the word with highest prob
		next.word <- reactive(out.words()[1,w4])

		#print button containing the predicted word
		output$word <- renderUI({
			word <- next.word()
			if(nchar(word) == 0) {
				word = "..."
			}
			actionButton("word", word)
		})

		#plot wordcloud with all possible choices
		output$cloud <- renderPlot({
			words <- out.words()
			if (nrow(words) > 1)  {
				set.seed(1979)
				wordcloud(words$w4, round(100 * words$s), min.freq = 1, colors=brewer.pal(6, "Dark2"))
			}
		}, width = 300, height = 300)

		w <- observe({
				t <- input$word
				if (length(t) == 0) return()
				if (t != 1) return()
				#print(paste("observe", t))
				 isolate ({
				 	#print(paste("isolate", t))
				 	updateTextInput(session, "text",
				 						value = paste(stri_trim_both(input$text), next.word()))
				 })

 		})

		output$help <- renderUI(helpPage())


		#try to predict next word from the given sentence, i.e. vector of words
		prediction <- function(words) {
			if(words[1] == FALSE) {
				return (data.table(w4=""))
			}
			#print(words)
			q <- predict.interp(model, words[3], words[2], words[1])
			#print(q)
			#q <- q[!w4 %in% filter]
			return (q)
		}

		cleanAndTokenize <- function(str) {
			str <- cleanText(str)
			str <- strsplit(str, " ")[[1]]
			n <- length(str)
			if(n == 0) {
				return (c(FALSE))
			}
			str <- rev(str[max(1, n - 6):n])
			if(n < 3) {
				str <- c(str, rep(FALSE, 3 - n))
			}
			#replace words not in dictionary with <U> mark
			unlist(lapply(str, function(s) if(!s %in% dict) "<U>" else s))
		}

	}
)