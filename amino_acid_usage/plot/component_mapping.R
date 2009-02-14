rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv')

melted <- melt(data,id.var=c('species','acid','weight'))
usage <- cast(
  melted,
  species ~ acid + variable,
)

species <- usage[,1]
usage <-  as.matrix(usage[,2:21])
rownames(usage) <- species
colnames(usage) <- levels(data$acid)

decomp <- svd(usage)

postscript("results/species_difference.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  decomp$u[,2],
  decomp$u[,3],
  type = "n",
  xlab = "Second component",
  ylab = "Third component",
  xlim = c(min(decomp$u[,2]) - 0.2,max(decomp$u[,2]) + 0.2)
)
text(
  x      = decomp$u[,2],
  y      = decomp$u[,3],
  labels = species
)

graphics.off()


postscript("results/acid_difference.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  decomp$v[,2],
  decomp$v[,3],
  type = "n",
  xlab = "Second component",
  ylab = "Third component"
)
text(
  x      = decomp$v[,2],
  y      = decomp$v[,3],
  labels =  levels(data$acid)
)


graphics.off()
