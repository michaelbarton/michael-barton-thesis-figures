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
  mutation ~ cost | cost_type,
  data=data,
  scale=list(relation="free"),
  xlab="Amino acid cost",
  ylab="Mean mutation rate",
  ylim=c(0.85,1.2),
  panel = function(x,y,...){
    panel.loess(x,y,lty=2,lwd=3,col="grey60")
    panel.xyplot(x,y)

    cor <- cor.test(x,y,method="spear")
    panel.text(min(x), 1.2,    paste("R = ",round(cor$estimate,3)),pos=4)
    panel.text(min(x), 1.17,  paste("p = ",round(cor$p.value,3)),pos=4)
  }
)


postscript("results/mutation.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
