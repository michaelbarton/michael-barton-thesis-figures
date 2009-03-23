rm(list=ls())
library(lattice)
source('helpers/find_replace.R')

data <- read.csv(file='data/gene_sensitivity.csv',header=TRUE)

data$sensitivity <- log10(abs(data$sensitivity))

# Replace environment name
data$environment <- find.replace(data$environment,
  c("glc",     "amm",     "sul"),
  c("glucose", "ammonium","sulphate")
)


plot <- densityplot(
  ~ sensitivity | setup,
  groups = environment,
  auto.key = TRUE,
  xlab="Absolute reaction sensitivity (log10)",
  data=data
)

postscript("results/sensitivity_density.eps",width=9,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
