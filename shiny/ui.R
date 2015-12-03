library(ggvis)

shinyUI(fluidPage(
  titlePanel("FN Model Example"),
  fluidRow(

  	column(4, 
  		wellPanel(
  			h4("Input"),
  			sliderInput("z", "Z value for the current simulation", -0.5, 0, -0.25, step = 0.01),
  			numericInput("time", "Max number of time steps to display", value = 10, min = 1, max = 10000, step = 1),
  			numericInput("x0", "Initial X value", value = 0, min = 0, max = 1, step = 0.01),
  			numericInput("y0", "Initial Y value", value = 0, min = 0, max = 1, step = 0.01)

  		)
  	),

  	column(9, ggvisOutput("plot1"))
  	)
  )
)