rm(list=ls())
library(lattice)
source('helpers/flux_data.R')

data <- flux_data()

# Break into three clusters based on flux
data$cluster <- factor(kmeans(data$value,c(-15,0,10))$cluster)
data$cluster <- find.replace(data$cluster,c(1,2,3),c("zero","low","high"))

plot <- bwplot(
  cluster ~ value | setup,
  data = data,
  xlab="log2 Absolute reaction flux",
  ylab="Flux category"
)


postscript("results/use_categories.eps",width=9,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(plot)
graphics.off()
