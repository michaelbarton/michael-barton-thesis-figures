rm(list=ls())

postscript("results/orfs.eps",width=6,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

barplot(
 c( 4819, 977, 811),
 names.arg = c("verified", "uncharacterised", "dubious"),
 ylab="Open Reading Frames"
)

graphics.off()
