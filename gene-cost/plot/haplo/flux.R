rm(list=ls())
library(lattice)

source('helper/find_replace.R')
source('helper/panel_functions.R')

data <- read.csv(file='data/haplo_flux.csv')
data$flux <- log2(abs(data$flux) + 0000.1)

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
levels(ordered_environments)[3] <- "sulphur"
data$environment <- factor(data$environment,levels=ordered_environments)

plot <- xyplot(
  haploinsufficiency ~ flux | environment + solution,
  data = data,
  xlab = "log. Reaction flux",
  ylab = "Hemizygous growth rate difference relative to wild type",
  panel= function(x,y,...){
    panel.xyplot(x,y,...)
    panel.abline(h=0,col="grey50",lty=2)
    panel.spearman(x,y)
  }
)

postscript("results/haplo/flux.eps",width=8,height=8,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
