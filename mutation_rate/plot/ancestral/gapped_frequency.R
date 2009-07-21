rm(list=ls())
require(lattice)
require(reshape)
source('helper/find_replace.R')
source('../helper/panel_functions.R')

gaps <- read.csv('data/ancestral/gapped_frequency.csv')
gaps <- subset(gaps, cost_type == "glu-rel" | cost_type == "glu-abs" | cost_type == "weight")

gaps$cost_type <- find.replace(gaps$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

ordered_costs <- as.ordered(1:3)
levels(ordered_costs)[3] <- "Molecular weight"
levels(ordered_costs)[2] <- "Glucose absolute"
levels(ordered_costs)[1] <- "Glucose relative"
gaps$cost_type <- factor(gaps$cost_type,levels=ordered_costs)

plot <- xyplot(
  (gapped / total) * 100 ~ cost | cost_type,
  data=gaps,
  scale=list(relation="free"),
  xlab="Ancestral amino acid cost",
  ylab="Percent occurance of one or more deletions in descendent site",
  ylim=list(c(8.5,11.5)),
  panel = function(x,y,...){
    panel.confidence(x,y)
    panel.xyplot(x,y)
    panel.spearman(x,y)
  }
)


postscript("results/ancestral/gaps_frequency.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
