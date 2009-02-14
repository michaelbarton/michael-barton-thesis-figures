rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv')

melted <- melt(data,id.var=c('species','acid','weight'))
usage <- cast(melted,species ~ acid + variable)

species <- usage[,1]
usage <-  as.matrix(usage[,2:21])

rownames(usage) <- species
colnames(usage) <- levels(data$acid)

postscript("results/phylogeny.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

correlation_distance <- dist(cor(t(usage)))
clustering <- hclust(correlation_distance)

plot(
  clustering,
  axes = FALSE,
  xlab = "",
  ylab = "",
  main = "",
  sub  = ""
)

graphics.off()
