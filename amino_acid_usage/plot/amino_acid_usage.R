rm(list=ls())
library(reshape)
library(lattice)
source('helper/find_replace.R')

data <- read.csv('data/amino_acid_usage.csv')
data <- subset(data, cost_type == "glu-abs" | cost_type == "glu-rel" | cost_type == "weight")

melted <- melt(data,measure.var=c('cost','usage'))
plot_data <- cast(
  melted,
  acid + cost_type ~ variable,
  function(x){c(max=max(x),median=median(x),min=min(x))})

plot_data$cost_type <- find.replace(plot_data$cost_type,
  c("weight","glu-rel","glu-abs"),
  c("Molecular weight","Glucose relative","Glucose absolute")
)

plot <- xyplot(
  usage_median ~ cost_median | cost_type,
  xlab="Amino acid cost",
  ylab="Proteome usage (%) across species",
  data = plot_data,
  scale="free",
  layout = c(1,3),
  ylim=c(0,0.12),
  panel=function(x,y,subscripts,...){
    for(i in 1:20){
      panel_data = plot_data[subscripts,][i,]
      panel.lines(
        x=c(panel_data$cost_median,panel_data$cost_median),
        y=c(panel_data$usage_min,panel_data$usage_max),
        col="grey40",
        lwd=3
      )
    }
    panel.loess(x,y,lty=2,col="grey60")
    panel.xyplot(x,y)
    cor <- cor.test(x,y,method="spear")
    panel.text(min(x), 0.12, paste("R = ",round(cor$estimate,3)),pos=4)
    panel.text(min(x), 0.11, paste("p = ",round(cor$p.value,3)),pos=4)
  }
  
)

postscript("results/amino_acid_usage.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
