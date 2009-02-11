rm(list=ls())

data <- read.csv('data/total_amino_acids.csv')

postscript("results/total_amino_acids.eps",width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

barplot(
  data$amino_acids,
  names.arg=data$species,
  xlab="Saccharomyces species",
  ylab="Number of amino acids counted"
)

graphics.off()
