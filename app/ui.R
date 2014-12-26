shinyUI(
	navbarPage("Text Prediction ...",
		tabPanel("App",
			fluidRow(
				column(4,
					#"Write something....", background: none repeat scroll 0 0 #96a2b6;
					br(), br(),br(),
					uiOutput("word"),
					#br(),
					tags$textarea(id="text", rows=5, cols=60, ""), #width: 250px;
					tags$head(tags$style(type="text/css", "#text { width: 280px;margin-top:10px}"))
				),
				column(7, plotOutput("cloud"))
			)
		),
		navbarMenu("About",
				   tabPanel("What is this?", includeMarkdown("app.md")),
					tabPanel("How does it work?", includeMarkdown("text-predict.md"))
		)
	)
)