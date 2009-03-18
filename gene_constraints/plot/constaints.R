rm(list=ls())
library(reshape)
library(lattice)

data <- read.csv('data/gene_constraint.csv')
data <- data[data$energy == 'respiratory',]

usage <- data.frame(
  gene        = character(0),
  type        = character(0),
  environment = character(0)
)

genes = unique(data$gene)
for(i in 1:length(genes)){
  subset <- data[data$gene == genes[i],]

  if(subset$type[1] == subset$type[2]){
    usage <- rbind(
      usage,
      data.frame(
        gene        = genes[i],
        type        = subset$type[1],
        environment = "both"
      )
    )
  } else {
    usage <- rbind(
      usage,
      data.frame(
        gene        = genes[i],
        type        = subset$type[subset$environment == "EX_glc(e)"],
        environment = "glucose only"
      ),
      data.frame(
        gene        = genes[i],
        type        = subset$type[subset$environment == "EX_nh4(e)"],
        environment = "ammonium only"
      )
    )
  }
}

frequency <- aggregate(
  usage$gene,
  list(
    environment = usage$environment,
    constraint  = usage$type),
  length)

plot <- barchart(
  x ~ constraint,
  groups=environment,
  auto.key=TRUE,
  xlab="Reaction type",
  ylab="Frequency",
  ylim=c(0,160),
  data=frequency
)

postscript("results/barchart.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
dev.set()

trellis.par.set("superpose.polygon", 
  list(
    col = c("grey75","grey55","grey35")
  )
)

print(plot)
graphics.off()
