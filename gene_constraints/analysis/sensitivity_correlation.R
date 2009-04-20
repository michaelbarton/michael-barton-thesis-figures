rm(list=ls())
library(reshape)
source('helpers/find_replace.R')

data <- read.csv(file='data/gene_sensitivity.csv',header=TRUE)

data$sensitivity <- log10(abs(data$sensitivity))
melted <- melt(data,measure.var="sensitivity")
data <- na.omit(cast(melted, gene  + environment ~ setup + variable))

result <- data.frame(
  environment  = character(0),
  correlation  = numeric(0),
  pvalue       = numeric(0),
  observations = numeric(0)
)

envs = unique(data$environment)
for(i in 1:length(envs)){
  sub_data = subset(data,environment == envs[i])
  cor = cor.test(
    sub_data$optimal_sensitivity,
    sub_data$suboptimal_sensitivity,
    method = "spear"
  )
  result <- rbind(result, data.frame(
    environment  = envs[i],
    correlation  = cor$estimate,
    pvalue       = cor$p.value,
    observations = dim(sub_data)[1]
  ))
}

write.csv(result,file="results/sensitivity_correlation.csv")
