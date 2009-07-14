rm(list=ls())
library(lattice)

source('helper/find_replace.R')
source('helper/panel_functions.R')

data <- read.csv(file='data/haplo_sensitivity.csv')
data$sensitivity <- log(abs(data$sensitivity) + 0.0001)

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
data$solution <- factor(data$solution,levels=order)

data$environment <- find.replace(data$environment,
  c('glc'     , 'amm')      , 
  c('glucose' , 'ammonium')
)

ordered_environments <- as.ordered(1:3)
levels(ordered_environments)[1] <- "glucose"
levels(ordered_environments)[2] <- "ammonium"
levels(ordered_environments)[3] <- "sulfur"
data$environment <- factor(data$environment,levels=ordered_environments)

plot <- xyplot(
  haploinsufficiency ~ sensitivity | environment + solution,
  data = data,
  xlab = "log. Reaction sensitivity",
  ylab = "Hemizygous growth rate difference",
  panel= function(x,y,...){
    panel.xyplot(x,y,...)
    panel.abline(h=0,col="grey50",lty=2)
    panel.spearman(x,y)
  }
)

postscript("results/haplo/sensitivity.eps",width=8,height=8,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
