rm(list=ls())
library(reshape)
require(RColorBrewer)


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

postscript("results/heatmap.eps",width=5,height=7,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

heatmap(
  t(as.matrix(usage)),
  scale = "row",
  col = brewer.pal(5,"Greys"),
  distfun = function(x){dist(cor(t(x),method="spear"))}
)

graphics.off()
