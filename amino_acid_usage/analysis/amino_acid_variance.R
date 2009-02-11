rm(list=ls())
library(reshape)

data <- read.csv('data/amino_acid_usage.csv')

melted <- melt(data,id.var=c('species','acid','weight'))
mad <- cast(melted,acid + weight ~ variable,mad)
 
print(
  cor.test(mad$weight,mad$usage,method="spear")
)
