rm(list=ls())
library(MASS)
library(reshape)
library(lattice)
source('helper/find_replace.R')
source('../helper/panel_functions.R')

data <- read.csv('data/amino_acid_usage.csv')
data <- subset(data, cost_type == "glu-abs" | cost_type == "glu-rel" | cost_type == "weight")

melted <- melt(data,measure.var=c('cost','usage'))
plot_data <- cast(melted, acid + cost_type ~ variable,
  function(x){c(mad=mad(x),median=median(x))})

plot_data$cost_type <- find.replace(plot_data$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

ordered_costs <- as.ordered(1:3)
levels(ordered_costs)[3] <- "Molecular weight"
levels(ordered_costs)[2] <- "Glucose absolute"
levels(ordered_costs)[1] <- "Glucose relative"
plot_data$cost_type <- factor(plot_data$cost_type,levels=ordered_costs)

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
    panel.spearman(x,y)
  }
)

  
postscript("results/amino_acid_variance.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
