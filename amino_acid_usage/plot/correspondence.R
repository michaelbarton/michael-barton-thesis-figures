rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv') 

usage <- data[,c(1,2,7)] 
usage <- cast(melt(usage),species ~ acid + variable)
species <- usage[,1]
usage <-  as.matrix(usage[,2:21])
rownames(usage) <- species
colnames(usage) <- levels(data$acid)

acids <- data[1:20,c(2,3:6)]
acids <- acids[order(acids$acid),]
acid_name <- acids[,1]
acids <- acids[,-1]
rownames(acids) <- acid_name

# Round off to two decimal places
acid <- round(acids,2)

correlation <- cancor(acids,t(usage))

postscript("results/acid_correlation.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

barplot(
 correlation$xcoef[,1] * -1,
 names.arg = row.names(correlation$xcoef),
 ylab="Contribution to first canonical correlation",
 xlab="Variable"

)

graphics.off()

merged_cost <- t(correlation$xcoef[,1] %*% t(as.matrix(acids))) * -1

yeast <- data[data$species == 'cerevisiae',]
order <- order(yeast$acid)
yeast <- yeast[order,]

postscript("results/canonical_cost.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  merged_cost,
  yeast$usage,
  type="n",
  ylab="Percent proteome usage",
  xlab="Cost estimate"
)

smooth <- loess(yeast$usage ~ merged_cost)
seq <- seq(min(merged_cost),max(merged_cost),0.01)
lines(
  x = seq,
  y = predict(smooth,seq),
  lwd = 3,
  lty = 2,
  col = "grey"
)


text(
  x = merged_cost,
  y = yeast$usage,
  labels = yeast$acid
)

graphics.off()
