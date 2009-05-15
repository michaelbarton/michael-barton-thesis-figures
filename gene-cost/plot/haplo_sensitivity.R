rm(list=ls())
library(lattice)

source('helper/find_replace.R')

data <- read.csv(file='data/haplo_sensitivity.csv')
data$sensitivity <- log(abs(data$sensitivity) + 0.0001)

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
data$solution <- factor(data$solution,levels=order)

data$environment <- find.replace(data$environment,
  c('glc'     , 'amm')      , 
  c('glucose' , 'ammonium')
)

plot <- xyplot(
  haploinsufficiency ~ sensitivity | environment + solution,
  data = data,
  xlab = "log. Reaction sensitivity",
  ylab = "Haplosufficient growth rate"
)

postscript("results/haplo_sensitivity.eps",width=6,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
