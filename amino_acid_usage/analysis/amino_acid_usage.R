rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv')

melted <- melt(data,id.var=c('species','acid','weight'))
median <- cast(melted,acid + weight ~ variable,median)

print(
  cor.test(median$weight,median$usage,method="spear")
)
