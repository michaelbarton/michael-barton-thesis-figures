rm(list=ls())
library(reshape)

data <- read.csv(file='data/gene_constraint.csv',header=TRUE)

melted <- melt(data,id.var=c('gene','setup','environment','type','reaction'))
counts <- cast(melted,  type + environment ~ setup + variable,length)

write.csv(counts,file="results/constraint_counts.csv")
