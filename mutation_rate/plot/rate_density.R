rm(list=ls())

data <- read.csv('/Users/mike/projects/09/thesis-figures/mutation_rate/data/site_vs_rate_cost.csv')

weight <- data[data$condition == 'wei',]

all     <- density(weight$cost)
fixed   <- density(weight$cost[weight$fixed == 'true'])
varying <- density(weight$cost[weight$fixed == 'false'])


postscript("results/weight_density.eps",width=9,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

old <- par(mfrow=c(1,2))

plot(fixed$x,fixed$y,type = 'n',xlab="Molecular Weight (Da)", ylab="Density")
lines(all$x,all$y)
legend('topright',legend="All sites",lty=1)

plot(fixed$x,fixed$y,type = 'n',xlab="Molecular Weight (Da)", ylab="Density")
lines(fixed$x,  fixed$y,   lty=2)
lines(varying$x,varying$y, lty=1)
legend('topright',legend=c("Fixed sites","Varying sites"),lty=c(2,1))

par(old)
graphics.off()
