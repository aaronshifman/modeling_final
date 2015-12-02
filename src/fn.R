#!/usr/bin/Rscript

### def var

a <- 0.01
b <- 0.5
c <- 0.01
z <- 0.5
dt <- 0.004
tmax <- 100
times <- seq(0, tmax, by = dt)
x <- unlist(list(rep(0, 100)))
y <- unlist(list(rep(0, 100)))
x_0 <- 0
y_0 <- 0

x_dot <- function(x,y,a,z) return(x*(a+x)*(1-x) - y + z)
y_dot <- function(x,y,b,c) return(b*x - c*y)

for(ix in 1:(length(times)-1)){
	t <- ix
	x[ix+1] <- x[ix]+(dt*x_dot(x[ix], y[ix], a, z))
	y[ix+1] <- y[ix]+(dt*y_dot(x[ix], y[ix], b, c))
}

# quick plot

plot(1:length(times), x, ylim = c(-1, 1.5), "l", col="blue", main = "Neuron 1", xlab = "Time (seconds)"); lines(y, col="green")

## other options for ODE solver 
# stiff solver
# ode45
# ode15s