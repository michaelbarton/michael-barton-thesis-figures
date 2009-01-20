rm(list=ls())
library(lattice)

data <- data.frame(
  category = c(
    "All",
    "A",
    "B",
    "C"
  ),
  count = c(
    1266,
    810,
    579,
    262
  )
)


postscript("costs.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
barplot(
  data$count,
  names.arg=data$category,
  ylab="Number in iND750",
  xlab="Reaction type"
)
graphics.off()
