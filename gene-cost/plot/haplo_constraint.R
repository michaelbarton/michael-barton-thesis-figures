rm(list=ls())
library(lattice)

source('helper/find_replace.R')

data <- read.csv(file='data/haplo_constraint.csv')

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
data$solution <- factor(data$solution,levels=order)

data$environment <- find.replace(data$environment,
  c('glc'     , 'amm')      , 
  c('glucose' , 'ammonium')
)

plot <- bwplot(
  haploinsufficiency ~ constraint | environment + solution,
  data = data,
  xlab = "log. Reaction constraint",
  ylab = "Haplosufficient growth rate"
)

postscript("results/haplo_constraint.eps",width=6,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
