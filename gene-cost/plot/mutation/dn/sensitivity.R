rm(list=ls())
library(lattice)

source('helper/find_replace.R')
source('helper/panel_functions.R')

data <- read.csv(file='data/mutation/sensitivity.csv')
data$sensitivity <- log(abs(data$sensitivity) + 0.0001)

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
data$solution <- factor(data$solution,levels=order)

data$environment <- find.replace(data$environment,
  c('glc'     , 'amm'      , 'sul'), 
  c('glucose' , 'ammonium' , 'sulphur')
)

ordered_environments <- as.ordered(1:3)
levels(ordered_environments)[1] <- "glucose"
levels(ordered_environments)[2] <- "ammonium"
levels(ordered_environments)[3] <- "sulphur"
data$environment <- factor(data$environment,levels=ordered_environments)

plot <- xyplot(
  dN ~ sensitivity | environment + solution,
  data = data,
  xlab = "log. Reaction sensitivity",
  ylab = "dN",
  panel= function(x,y,...){
    panel.xyplot(x,y,...)
    panel.spearman(x,y)
  }
)

postscript("results/mutation/dn/sensitivity.eps",width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
