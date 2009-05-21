rm(list=ls())
require(lattice)
require(reshape)
source('helper/find_replace.R')

data <- read.csv('data/mutation_rates.csv')

melted <- melt(data)
mutation <- cast(melted,acid + cost_type ~ variable,median)

mutation$cost_type <- find.replace(mutation$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

plot <- xyplot(
  mutation ~ cost | cost_type,
  data=mutation,
  scale=list(relation="free"),
  xlab="Ancestral amino acid cost",
  ylab="Median relative substitution rate",
  panel = function(x,y,...){
    panel.loess(x,y,lty=2,lwd=3,col="grey60")
    panel.xyplot(x,y)
  }
)


postscript("results/ancestral_mutation.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
