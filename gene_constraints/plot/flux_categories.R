rm(list=ls())
library(lattice)
source('helpers/flux_data.R')

data <- flux_data_with_clusters()

plot <- bwplot(
  cluster ~ value | setup,
  data = data,
  xlab="log2 Absolute reaction flux",
  ylab="Flux category"
)


postscript("results/use_categories.eps",width=9,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(plot)
graphics.off()
