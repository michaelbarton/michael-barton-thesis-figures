rm(list=ls())
library(lattice)
source('helper/find_replace.R')

data <- read.csv('data/site_vs_rate_cost.csv')
data <- subset(data, (cost_type == 'none' | cost_type == 'car'))

data$fixed <- find.replace(data$fixed,
  c("true", "false"),
  c("fixed","varying")
)

data$condition <- find.replace(data$condition,
  c("wei","rel","abs"),
  c("Molecular weight", "Glucose relative", "Glucose absolute")
)

plot <- densityplot(
  ~ cost | condition,
    data=data,
    scale="free",
    xlab="Phylogeny weighted amino acid cost",
    ylab="Density",
    groups=fixed,
    auto.key=TRUE
)

postscript("results/cost_density.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
