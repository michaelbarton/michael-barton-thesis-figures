rm(list=ls())
library(lattice)
library(reshape)
source('helpers/find_replace.R')

data <- read.csv(file='data/gene_sensitivity.csv',header=TRUE)

data$sensitivity <- log10(abs(data$sensitivity))
melted <- melt(data,measure.var="sensitivity")
data <- cast(melted, gene + environment ~ setup + variable)


# Replace environment name
data$environment <- find.replace(data$environment,
  c("glc",     "amm",     "sul"),
  c("glucose", "ammonium","sulphate")
)


plot <- xyplot(
  optimal_sensitivity ~ suboptimal_sensitivity | environment,
  xlab="Suboptimal sensitivity (log10)",
  ylab="Optimal sensitivity (log10)",
  data=data,
  panel=function(x,y,...){
    panel.xyplot(x,y,...)
    panel.loess(x,y,lty=2,col="grey20")
  }
)

postscript("results/sensitivity_scatterplot.eps",width=5,height=12,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
