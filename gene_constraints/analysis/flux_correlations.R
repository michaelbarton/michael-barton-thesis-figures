rm(list=ls())
library(reshape)

data <- read.csv(file='data/gene_constraint.csv',header=TRUE)

scaled <- cast( melt(data,measure.var="flux"), gene + reaction + setup ~ environment + variable)
scaled <- na.omit(scaled)

print(cor(scaled[scaled$setup=="optimal",4:6],method="spear"))
print(cor(scaled[scaled$setup=="suboptimal",4:6],method="spear"))
