rm(list=ls())
library(reshape)

data <- read.csv(file='data/all_reaction_type.csv',header=TRUE)

melted <- melt(data,id.var=c('solution','environment','type'))
counts <- cast(melted,  type + environment ~ solution + variable,length)

write.csv(counts,file="results/all_constraint_counts.csv")
