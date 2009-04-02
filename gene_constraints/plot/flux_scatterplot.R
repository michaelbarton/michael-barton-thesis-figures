rm(list=ls())
library(lattice)
source('helpers/find_replace.R')
source('helpers/flux_data.R')

data <- flux_data()
data <- cast(data)

plot <- splom(
  ~ data[4:6],
  groups  = data$setup,
  xlab= "Absolute reaction flux (log.2)",
  ylab= "Absolute reaction flux (log.2)",
  col = c("grey10","grey50"),
  pch = c(1,2),
  key = list(
    columns = 2, 
    points  = list(pch = c(1,2), col = c("grey10","grey50")),
    text    = list(c("Optimal", "Suboptimal"))
  )
)


postscript("results/flux_scatterplot.eps",width=7,height=7,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

print(plot)

graphics.off()
