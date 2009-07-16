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
    ylim=list(c(0,0.59),c(0,260),c(0,0.077)),
    groups=fixed,
    auto.key=TRUE,
    key=list(
      columns = 2,
      text    = list(c("Fixed", "Varying")),
      lines   = list(lty=c(2,1))
    ),
    panel=function(x,subscripts){
      fixed   <- subset(data[subscripts,],fixed == "fixed")
      varying <- subset(data[subscripts,],fixed == "varying")

      fixed   <- density(fixed$cost)
      varying <- density(varying$cost)

      panel.lines(fixed$x,fixed$y,lty=2,lwd=1,col="grey30")
      panel.lines(varying$x,varying$y,col="grey30")
    }
)

postscript("results/cost_density.eps",width=4,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
