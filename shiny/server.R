library(ggvis)
library(dplyr)
### def var

#a <- 0.01
#b <- 0.5
#c <- 0.01
#z <- 0.5
#dt <- 0.004
#tmax <- 100
#times <- seq(0, tmax, by = dt)
#x <- unlist(list(rep(0, 100)))
#y <- unlist(list(rep(0, 100)))
#x_0 <- 0
#y_0 <- 0



#for(ix in 1:(length(times)-1)){
#	t <- ix
#	x[ix+1] <- x[ix]+(dt*x_dot(x[ix], y[ix], a, z))
#	y[ix+1] <- y[ix]+(dt*y_dot(x[ix], y[ix], b, c))
#}

xi <- vector()
yi <- vector()
ti <- vector()


# quick plot

#plot(1:length(times), x, ylim = c(-1, 1.5), "l", col="blue", main = "Neuron 1", xlab = "Time (seconds)"); lines(y, col="green")

## other options for ODE solver 
# stiff solver
# ode45
# ode15s

shinyServer(function(input, output, session) { 


	x_dot <- function(x,y,a,z) return(x*(a+x)*(1-x) - y + z)
	y_dot <- function(x,y,b,c) return(b*x - c*y)

	x <- reactive({

		a <- 0.01
		b <- 0.5
		c <- 0.01
		dt <- 0.04

		z <- input$z
		t <- input$time

		xi[1] <- input$x0
		yi[1] <- input$y0
		ti[1] <- 1


		for(ix in 1:(t-1)){
			ti[ix+1] <- ix
			xi[ix+1] <- xi[ix]+(dt*x_dot(xi[ix], yi[ix], a, z))
			yi[ix+1] <- yi[ix]+(dt*y_dot(xi[ix], yi[ix], b, c))
		}

		r <- as.data.frame(cbind(xi, yi, ti))

		r

		})

	vis <- reactive({


			x %>% ggvis(~ti, ~xi) %>% layer_points() %>% layer_points(data = x, x = ~ti, y = ~yi)

		})


	vis %>% bind_shiny("plot1")

})
