rm(list=ls())
library(reshape)
library(lattice)

data <- read.csv('gene_constraint.csv')

frequency <- aggregate(
  data$gene,
  list(
    environment = data$environment,
    energy      = data$energy,
    constraint  = data$type),
  length)
levels(frequency$environment) <- c('glucose','ammonium')

plot <- barchart(
  x ~ environment | energy,
  groups=constraint,
  stack=TRUE,
  auto.key=TRUE,
  xlab="Nutrient limitation",
  ylab="Gene count",
  data=frequency)

postscript("constraints.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
dev.set()

trellis.par.set("superpose.polygon", 
  list(
    col = c("grey95","grey75","grey55","grey35")
  )
)

print(plot)
graphics.off()
