rm(list=ls())
require(lattice)
require(reshape)
source('helper/find_replace.R')
source('helper/panel.confidence.R')

gaps <- read.csv('data/ancestral/gapped_frequency.csv')
gaps <- subset(gaps, cost_type == "glu-rel" | cost_type == "glu-abs" | cost_type == "weight")

gaps$cost_type <- find.replace(gaps$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

plot <- xyplot(
  (gapped / total) * 100 ~ cost | cost_type,
  data=gaps,
  scale=list(relation="free"),
  xlab="Ancestral amino acid cost",
  ylab="Percent occurance of one or more deletions in descendent site",
  panel = function(x,y,...){
    panel.confidence(x,y)
    panel.xyplot(x,y)

    cor <- cor.test(x,y,method="spear")
    panel.text(max(x), 11.1, paste("R = ",round(cor$estimate,3)),pos=2)
    panel.text(max(x), 10.9, paste("p = ",round(cor$p.value,3)),pos=2)
  }
)


postscript("results/ancestral/gaps_frequency.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
