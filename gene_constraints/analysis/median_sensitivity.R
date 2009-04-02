rm(list=ls())
library(reshape)

data <- read.csv(file='data/gene_sensitivity.csv',header=TRUE)
data$sensitivity <- log10(abs(data$sensitivity))

data <- melt(data,measure.var="sensitivity")

write.csv(
  file="results/median_sensitivity.csv",
  cast(data, environment + setup ~ variable, median)
)
