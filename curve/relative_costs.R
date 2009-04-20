rm(list=ls())
library(lattice)

data <- data.frame(
  cost        = c(0.07,0.1,0.09,0.06,0.2,0.29),
  environment = c("Glucose Limited","Glucose Limited","Glucose Limited","Ammonium Limited","Ammonium Limited","Ammonium Limited"),
  acid        = c("Tryptophan","Histidine","Glycine","Tryptophan","Histidine","Glycine")
)

trellis.par.set("superpose.polygon", 
  list(
    col=c("grey30","grey50","grey70"),
    border=c("grey30","grey50","grey70")
  )
)


postscript("relative_costs.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
barchart(
  cost ~ environment, 
  groups=acid,
  auto.key=TRUE,
  horiz=FALSE,
  ylab="Relative cost",
  data=data)
graphics.off()
