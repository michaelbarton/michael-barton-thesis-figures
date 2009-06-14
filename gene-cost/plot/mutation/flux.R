rm(list=ls())
library(lattice)

source('helper/find_replace.R')
source('helper/panel_functions.R')

data <- read.csv(file='data/mutation/flux.csv')
data$flux <- log2(abs(data$flux) + 0000.1)

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
data$solution <- factor(data$solution,levels=order)

data$environment <- find.replace(data$environment,
  c('glc'     , 'amm'      , 'sul'), 
  c('glucose' , 'ammonium' , 'sulfur')
)

plot <- xyplot(
  dN_dS ~ flux | environment + solution,
  data = data,
  xlab = "log. Reaction flux",
  ylab = "dN/dS",
  panel= function(x,y,...){
    panel.xyplot(x,y,...)
    panel.spearman(x,y)
  }
)

postscript("results/mutation/flux.eps",width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
