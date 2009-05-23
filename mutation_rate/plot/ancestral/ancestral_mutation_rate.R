rm(list=ls())
require(lattice)
require(reshape)
source('helper/find_replace.R')
source('helper/panel.confidence.R')

mutation <- read.csv('data/ancestral/mean_mutation_rate.csv')
mutation <- subset(mutation, cost_type == "glu-rel" | cost_type == "glu-abs" | cost_type == "weight")

mutation$cost_type <- find.replace(mutation$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

plot <- xyplot(
  mutation ~ cost | cost_type,
  data=mutation,
  scale=list(relation="free"),
  xlab="Ancestral amino acid cost",
  ylab="Mean relative substitution rate",
  #ylim=c(0.85,1.2),
  panel = function(x,y,...){
    panel.confidence(x,y)
    panel.xyplot(x,y)

    cor <- cor.test(x,y,method="spear")
    panel.text(min(x), 1.2,    paste("R = ",round(cor$estimate,3)),pos=4)
    panel.text(min(x), 1.17,  paste("p = ",round(cor$p.value,3)),pos=4)
  }
)


postscript("results/ancestral/mutation_rate.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
