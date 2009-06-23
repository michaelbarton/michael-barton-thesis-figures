rm(list=ls())
library(lattice)

source('helper/find_replace.R')
source('helper/panel_functions.R')

data <- read.csv(file='data/essentiality/flux.csv')
data$flux <- log2(abs(data$flux) + 0000.1)

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
data$solution <- factor(data$solution,levels=order)

data$environment <- find.replace(data$environment,
  c('glc'     , 'amm'      , 'sul'), 
  c('glucose' , 'ammonium' , 'sulfur')
)

data$essential <- find.replace(data$essential,
  c('true'      , 'false'   ), 
  c('essential' , 'dispensible')
)

plot <- bwplot(
  essential ~ flux | environment + solution,
  data = data,
  ylab = "Gene Frequency",
  xlab = "log. Reaction flux",
  panel= function(x,y,...){
    panel.bwplot(x,y,...)
    panel.anova(y,x)
  }
)

postscript("results/essential/flux.eps",width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()