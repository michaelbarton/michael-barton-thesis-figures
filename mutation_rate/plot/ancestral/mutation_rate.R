rm(list=ls())
require(lattice)
source('helper/find_replace.R')
source('../helper/panel_functions.R')

mutation <- read.csv('data/ancestral/mean_mutation_rate.csv')
mutation <- subset(mutation, cost_type == "glu-rel" | cost_type == "glu-abs" | cost_type == "weight")

mutation$cost_type <- find.replace(mutation$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

ordered_costs <- as.ordered(1:3)
levels(ordered_costs)[3] <- "Molecular weight"
levels(ordered_costs)[2] <- "Glucose absolute"
levels(ordered_costs)[1] <- "Glucose relative"
mutation$cost_type <- factor(mutation$cost_type,levels=ordered_costs)

plot <- xyplot(
  rate ~ cost | cost_type,
  data=mutation,
  scale=list(relation="free"),
  xlab="Ancestral amino acid cost",
  ylab="Mean relative substitution rate",
  ylim=c(0.75,1.1),
  panel = function(x,y,...){
    panel.confidence(x,y)
    panel.xyplot(x,y)
    panel.spearman(x,y)
  }
)


postscript("results/ancestral/mutation_rate.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
