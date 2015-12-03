library(ggvis)

shinyUI(pageWithSidebar(
  headerPanel("FitzHugh–Nagumo Coupled Oscillators"),
  sidebarPanel(

  		wellPanel(
  			h4("Paremeters"),
  			sliderInput("g", "Dampening factor", -1, 1, 0, step = 0.01),
  			sliderInput("z", "Z value for the current simulation", -0.5, 0, -0.25, step = 0.01),
  			numericInput("time", "Max number of time steps to display", value = 1000, min = 1, max = 10000, step = 1),
  			numericInput("x0", "Initial X Y value for both neurons", value = 0, min = 0, max = 1, step = 0.01),
  			numericInput("offset", "Offset in periods", value = 0, min = 0, max = 1, step = 0.01),
  			numericInput("a", "a value", value = 0.01, min = 0, max = 1, step = 0.01),
  			numericInput("b", "b value", value = 0.5, min = 0, max = 1, step = 0.01),
  			numericInput("c", "c value", value = 0.01, min = 0, max = 1, step = 0.01),
  			numericInput("dt", "dt", value = 0.04, min = 0, max = 1, step = 0.01)

  		)),
  mainPanel(
  	ggvisOutput("plot1"), ggvisOutput("plot2")
  	)
  )
)