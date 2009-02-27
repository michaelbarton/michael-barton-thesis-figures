rm(list=ls())
require(MASS)

data <- read.csv('data/acid_mutation_rates.csv')

postscript("results/mutation_vs_fixed.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  data$fixed,
  data$mutation,
  xlab="Percent sites fixed",
  ylab="Mean mutation rate"
)

model <- rlm(
  mutation ~ fixed,
  data=data)
lines(
  x = sort(data$fixed),
  y = model$fitted.values[order(data$fixed)],
  lwd = 3,
  lty = 2,
  col = "grey"
)

graphics.off()


postscript("results/ratio_mutation_vs_fixed.eps",width=10,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

barplot(
  sort(resid(model)),
  names.arg = data$acid[order(resid(model))],
  ylab = "Residual"
)

graphics.off()
