rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv')

melted <- melt(data,id.var=c('species','acid','weight','glucose','ammonium','sulphur'))
usage <- cast(
  melted,
  species ~ acid + variable,
)

species <- usage[,1]
usage <-  as.matrix(usage[,2:21])
rownames(usage) <- species
colnames(usage) <- levels(data$acid)

decomp <- svd(usage)

postscript("results/acid_difference.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  decomp$v[,2],
  decomp$v[,3],
  type = "n",
  xlab = "Second component",
  ylab = "Third component"
)
symbols(0,0,circles=0.3,add=TRUE,lty=2,fg="grey")
abline(h=0,lty=2,col="grey")
abline(v=0,lty=2,col="grey")

weights <- data$weight[order(data$acid[1:20])]
points(
  decomp$v[,2],
  decomp$v[,3],
  pch=22,
  cex=(weights^(0.5) - 8)
)

graphics.off()
