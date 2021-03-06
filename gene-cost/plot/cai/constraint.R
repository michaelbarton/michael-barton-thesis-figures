rm(list=ls())
library(lattice)

source('helper/find_replace.R')
source('helper/panel_functions.R')


data <- read.csv(file='data/mutation/constraint.csv')

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

plot <- bwplot(
  cai ~ constraint | environment + solution,
  data = data,
  ylab = "Codon adaptation index",
  xlab = "Reaction constraint",
  panel= function(x,y,...){
    panel.bwplot(x,y,...)
    panel.anova(x,y)
  }
)

postscript("results/cai/constraint.eps",width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
