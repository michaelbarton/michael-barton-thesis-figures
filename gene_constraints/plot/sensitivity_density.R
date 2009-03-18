rm(list=ls())

data <- read.csv(file='data/gene_sensitivity.csv',header=TRUE)

data$sensitivity <- log10(abs(data$sensitivity))

postscript("results/sensitivity_density.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  density(data$sensitivity),
  type="n",
  xlab="Absolute reaction sensitivity (log10)",
  main="",
  ylim=c(0,0.15)
)

environments <- unique(data$environment)
line_types <- c(2,1,3)
colors <- c("grey20","grey40",'black')

legend(
  'topright',
  legend = environments,
  lty    = line_types,
  col    = colors
)

for(i in 1:length(environments)){
  subset = data$sensitivity[data$environment == environments[i]]
  lines(
    density(subset),
    lty = line_types[i],
    col = colors[i]
  )
}

graphics.off()
