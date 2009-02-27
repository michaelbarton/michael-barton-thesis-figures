rm(list=ls())
require(MASS)

data <- read.csv('data/acid_mutation_rates.csv')

postscript("results/mutation.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  data$weight,
  data$mutation,
  xlab="Molecular weight (Da)",
  ylab="Mean mutation rate"
)

smooth <- loess(
  mutation ~ weight,
  data=data)
lines(
  x = sort(data$weight),
  y = predict(smooth,sort(data$weight)),
  lwd = 3,
  lty = 2,
  col = "grey"
)

graphics.off()
