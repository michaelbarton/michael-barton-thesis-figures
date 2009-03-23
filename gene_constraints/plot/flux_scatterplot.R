rm(list=ls())
library(lattice)
source('helpers/find_replace.R')
source('helpers/flux_data.R')

data <- flux_data()
data <- cast(data)

plot <- splom(
  ~ data[3:5],
  groups  = data$setup,
  xlab="Absolute reaction flux (log.2)",
  ylab="Absolute reaction flux (log.2)",
  auto.key = TRUE
)


postscript("results/flux_scatterplot.eps",width=7,height=7,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

print(plot)

graphics.off()
