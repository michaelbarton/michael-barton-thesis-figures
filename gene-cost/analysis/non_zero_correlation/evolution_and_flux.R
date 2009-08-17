rm(list=ls())
library(plyr)

data <- read.csv(file='data/mutation/flux.csv')
data <- subset(data,flux != 0)
data$flux <- log2(abs(data$flux) + 0000.1)

results <- data.frame(
  environment = character(),
  solution    = character(),
  variable    = character(),
  r           = numeric(),
  p           = numeric()
)

variables <- c("dN","dS","dN_dS","cai")
d_ply(data, .(environment,solution), function(subset){
  for(i in 1:length(variables)){
    var <- variables[i]
    cor <- cor.test(t(subset["flux"]),t(subset[var]),method="spear")
    results <<- rbind(results,data.frame(
      environment = subset["environment"][1,1],
      solution = subset["solution"][1,1],
      variable = var,
      r = cor$estimate,
      p = cor$p.value
    ))
  }
})

write.csv(
  results,
  file="results/non_zero_correlation.csv"
)
