rm(list=ls())
library(reshape)
source('helpers/find_replace.R')

data <- read.csv(file='data/gene_sensitivity.csv',header=TRUE)

data$sensitivity <- log10(abs(data$sensitivity))
melted <- melt(data,measure.var="sensitivity")
data <- cast(melted, gene  + environment ~ setup + variable)

write.csv(
  file="results/sensitivity_correlation.csv",
  data.frame(
    environments = c(
      "glucose",
      "ammonium",
      "sulphate"
    ),
    corr = c(
      cor(na.omit(subset(data,environment=="glc")[,3:4]),method="spear")[1,2],
      cor(na.omit(subset(data,environment=="amm")[,3:4]),method="spear")[1,2],
      cor(na.omit(subset(data,environment=="sul")[,3:4]),method="spear")[1,2]
    ),
    count = c(
      dim(na.omit(subset(data,environment=="glc")))[1],
      dim(na.omit(subset(data,environment=="amm")))[1],
      dim(na.omit(subset(data,environment=="sul")))[1]
    )
  )
)
