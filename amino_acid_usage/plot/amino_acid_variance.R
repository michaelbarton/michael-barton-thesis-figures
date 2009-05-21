rm(list=ls())
library(MASS)
library(reshape)
library(lattice)
source('helper/find_replace.R')
source('helper/panel.confidence.R')

data <- read.csv('data/amino_acid_usage.csv')
data <- subset(data, cost_type == "glu-abs" | cost_type == "glu-rel" | cost_type == "weight")

melted <- melt(data,measure.var=c('cost','usage'))
plot_data <- cast(melted, acid + cost_type ~ variable,
  function(x){c(mad=mad(x),median=median(x))})

plot_data$cost_type <- find.replace(plot_data$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

plot <- xyplot(
  usage_mad ~ cost_median | cost_type,
  xlab="Amino acid cost",
  ylab="Median adjusted deviation usage across species",
  data = plot_data,
  scales=list(relation="free",tick.number=4),
  layout = c(1,3),
  ylim=c(0,0.0035),
  panel=function(x,y,subscripts,...){

    panel.confidence(x,y)
    panel.xyplot(x,y)

    cor <- cor.test(x,y,method="spear")
    panel.text(min(x), 0.0035, paste("R = ",round(cor$estimate,3)),pos=4)
    panel.text(min(x), 0.0032, paste("p = ",round(cor$p.value,3)),pos=4)
  }
)

  
postscript("results/amino_acid_variance.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
