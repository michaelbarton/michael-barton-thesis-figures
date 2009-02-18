rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv')

melted <- melt(data,id.var=c('species','acid','weight'))
mad <- cast(melted,acid + weight ~ variable,mad)
   
postscript("results/amino_acid_variance.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  mad$weight,
  mad$usage,
  type="n",
  xlab="Molecular Weight (Daltons)",
  ylab="Median adjusted deviation usage across species"
)

smooth <- loess(
  usage ~ weight,
  span = 1,
  data=mad)
lines(
  x = sort(mad$weight),
  y = predict(smooth,sort(mad$weight)),
  lwd = 3,
  lty = 2,
  col = "grey"
)

text(x=mad$weight,y=mad$usage,labels=mad$acid)

graphics.off()
