rm(list=ls())
library(lattice)
source('helpers/find_replace.R')
source('helpers/constraint_data.R')

data <- constraint_data()

plot <- densityplot(
  ~ value | setup,
  groups = variable,
  xlab="Absolute reaction flux (log.2)",
  auto.key=TRUE,
  data=data
)

postscript("results/use_density.eps",width=9,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
