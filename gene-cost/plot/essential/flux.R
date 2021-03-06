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
  c('glucose' , 'ammonium' , 'sulphur')
)

data$viable <- 0
data$viable[data$essential == 'viable'] <- 1

ordered_environments <- as.ordered(1:3)
levels(ordered_environments)[1] <- "glucose"
levels(ordered_environments)[2] <- "ammonium"
levels(ordered_environments)[3] <- "sulphur"
data$environment <- factor(data$environment,levels=ordered_environments)

plot <- xyplot(
  viable ~ flux | environment + solution,
  data = data,
  xlab = "log. Reaction flux",
  ylab = "Gene dispensibility",
  ylim = c(-0.3,1.3),
  scales = list(y = list(
    alternating = 1,
    at = c(0,1),
    labels = c("essential","dispensible")
  )),
  panel= function(x,y,...){
    panel.xyplot(x,jitter(y,factor=0.2))
    panel.binomial(x,y)
  }
)

postscript("results/essential/flux.eps",width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
