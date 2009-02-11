rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv')

melted <- melt(data,id.var=c('species','acid','weight'))
median <- cast(melted,acid + weight ~ variable,median)
max <- cast(melted,acid + weight ~ variable,max)
min <- cast(melted,acid + weight ~ variable,min)
   
postscript("results/amino_acid_usage.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  data$weight,
  data$usage,
  xlab="Molecular weight (Daltons)",
  ylab="Median proteome usage (%) across species",
  type="n"
)

for(i in 1:20){
  lines(
    x=c(median$weight[i],median$weight[i]),
    y=c(min$usage[i],max$usage[i]),
    col="grey60",
    lwd=4
  )
}
points(median$weight,median$usage,pch=1)

graphics.off()
