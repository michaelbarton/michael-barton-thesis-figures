#!/usr/bin/env R

rm(list=ls())
require(lattice)
source('helper/find_replace.R')

data <- read.csv('data/acid_mutation_rates.csv')
data <- subset(data, (cost_type == "weight" | cost_type == "glu-abs" | cost_type == "glu-rel"))

data$cost_type <- find.replace(data$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

plot <- xyplot(
  fixed ~ cost | cost_type,
  data=data,
  scale=list(relation="free"),
  xlab="Amino acid cost",
  ylab="Percent sites fixed",
  ylim=c(0.65,1),
  panel = function(x,y,...){
    panel.loess(x,y,lty=2,lwd=3,col="grey60")
    panel.xyplot(x,y)

    cor <- cor.test(x,y,method="spear")
    panel.text(min(x), 1,    paste("R = ",round(cor$estimate,3)),pos=4)
    panel.text(min(x), 0.965, paste("p = ",round(cor$p.value,3)),pos=4)
  }
)

postscript("results/fixation.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

print(plot)

graphics.off()
