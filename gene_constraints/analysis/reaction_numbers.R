rm(list=ls())
library(reshape)
source('helpers/find_replace.R')


data <- read.csv(file='data/gene_constraint.csv',header=TRUE)
data <- cast( melt(data,measure.var="flux"), gene + reaction + setup ~ environment + variable)


zero <- subset(data, (abs(glc_flux) < 0.001 & abs(amm_flux) < 0.001 & abs(sul_flux) < 0.001))
non_zero <- subset(data, !(abs(glc_flux) < 0.001 & abs(amm_flux) < 0.001 & abs(sul_flux) < 0.001))

identical <- subset(non_zero, (glc_flux == amm_flux & amm_flux == sul_flux))
non_identical <- subset(non_zero, !(glc_flux == amm_flux & amm_flux == sul_flux))

write.csv(file="results/reaction_counts.csv",
  data.frame(
    counts=c(
      "zero",
      "identical",
      "significant"
    ),
    optimal=c(
      dim(subset(zero,         setup=="optimal"))[1],
      dim(subset(identical,    setup=="optimal"))[1],
      dim(subset(non_identical,setup=="optimal"))[1]
    ),
    suboptimal=c(
      dim(subset(zero,         setup=="suboptimal"))[1],
      dim(subset(identical,    setup=="suboptimal"))[1],
      dim(subset(non_identical,setup=="suboptimal"))[1]
    )
  )
)
