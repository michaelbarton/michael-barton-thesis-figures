rm(list=ls())
require(MASS)

data <- read.csv('data/acid_mutation_rates.csv')

postscript("results/fixation.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  data$weight,
  data$fixed,
  xlab="Molecular weight (Da)",
  ylab="Percent sites fixed"
)

smooth <- loess(
  fixed ~ weight,
  data=data)
lines(
  x = sort(data$weight),
  y = predict(smooth,sort(data$weight)),
  lwd = 3,
  lty = 2,
  col = "grey"
)

graphics.off()
