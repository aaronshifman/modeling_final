library(ggvis)
library(dplyr)
library(deSolve)
### def vars

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

#second neuron
xi2 <- vector()
yi2 <- vector()

temp <- vector()
temp[1] <- 0

# quick plot

#plot(1:length(times), x, ylim = c(-1, 1.5), "l", col="blue", main = "Neuron 1", xlab = "Time (seconds)"); lines(y, col="green")

## other options for ODE solver 
# stiff solver
# ode45
# ode15s

shinyServer(function(input, output, session) { 

	################################

	x_dot <- function(x,y,a,z, x2, g, alpha) return(x*(a+x)*(1-x) - y + (1 - alpha)*g*(x - x2) + z)
	y_dot <- function(x,y,b,c) return(b*x - c*y)

	x <- reactive({


		alpha <- input$alpha
		g <- input$g #need to put this in the ui
		a <- input$a
		b <- input$b
		c <- input$c
		dt <- input$dt

		
		t <- input$time

		z <- input$z


		xi[1] <- input$x0
		yi[1] <- input$x0
		xi2[1] <- input$x0+input$offset #just for simplicity
		yi2[1] <- input$x0-input$offset #just for simplicity
		ti[1] <- 1


############### !NEW! ############## !NEW! ################### NEW ####
		FN <- function(time, y, parms) {

			with(as.list(c(y, parms)), {

				#rate of change
				dx <- x*(a+x)*(1-x) - y + (1 - alpha)*g*(x - x2) + z
				dy <- b*x - c*y
				dx2 <- x2*(a+x2)*(1-x2) - y2 + (1 - alpha)*g*(x2 - x) + z
				dy2 <- b*x2 - c*y2
				#dr <- 0.01


				# return the rate of change 
				list(c(dx, dy, dx2, dy2))

			})

		}

		################ NEW !!! #################

		time <- seq(0, t, by = 0.01)
		parms <- c(a=a, b=b, c=c, alpha=alpha, g=g, z=z) # NEED TO ADJUST THIS Z
		y <- c(x = xi[1], y = yi[1], x2 = xi2[1], y2 = yi2[1])

		#########################################
		#for(ix in 1:(t-1)){
		#	ti[ix+1] <- ix
		#	xi[ix+1] <- xi[ix]+(dt*x_dot(xi[ix], yi[ix], a, z[ix], xi2[ix], g, alpha))
		#	yi[ix+1] <- yi[ix]+(dt*y_dot(xi[ix], yi[ix], b, c))

			#temp[ix+1] <- x_dot2(xi[ix], yi[ix], a, z[ix], xi2[ix], g, alpha)

			#second neuron

		#	xi2[ix+1] <- xi2[ix]+(dt*x_dot(xi2[ix], yi2[ix], a, 0, xi[ix], g, alpha))
		#	yi2[ix+1] <- yi2[ix]+(dt*y_dot(xi2[ix], yi2[ix], b, c))

		#}

		r <- as.data.frame(ode(y, time, FN, parms))
		colnames(r) <- c("ti", "xi", "yi", "xi2", "yi2")

		r

		})

	vis <- reactive({


			x %>% ggvis(~ti, ~xi) %>% layer_points(size := 10, stroke := "red") %>% layer_points(data = x, x = ~ti, y = ~yi, size := 10, stroke := "blue") %>% add_axis("y", title = "X") %>% scale_numeric("y", domain = c(-2, 2), nice = FALSE, clamp = TRUE) %>% add_axis("x", title = " ") %>% add_axis("x", orient = "top", ticks = 0, title = "Neuron 1", properties = axis_props(axis = list(stroke = "white"),labels = list(fontSize = 0)))

		})

	vis2 <- reactive({


			x %>% ggvis(~ti, ~xi2) %>% layer_points(size := 10, stroke := "red") %>% layer_points(data = x, x = ~ti, y = ~yi2, size := 10, stroke := "blue") %>% add_axis("y", title = "X") %>% scale_numeric("y", domain = c(-2, 2), nice = FALSE, clamp = TRUE) %>% add_axis("x", title = " ") %>% add_axis("x", orient = "top", ticks = 0, title = "Neuron 2", properties = axis_props(axis = list(stroke = "white"),labels = list(fontSize = 0)))

		})




	vis %>% bind_shiny("plot1")
	vis2 %>% bind_shiny("plot2")

})
