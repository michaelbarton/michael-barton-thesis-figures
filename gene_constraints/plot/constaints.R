rm(list=ls())
library(reshape)
library(limma)
library(lattice)

source('helpers/find_replace.R')
data <- read.csv(file='data/gene_constraint.csv',header=TRUE)

melted      <- melt(data,measure.var=c('reaction'))
convergence <- cast(melted, gene + setup + type ~ environment + variable)
convergence[,4:6] <- ! is.na(convergence[,4:6])

result <- data.frame(
  environment = character(0),
  type        = character(0),
  setup       = character(0),
  counts      = numeric(0)
)

# Venn type counts of environmental reaction use
types <- unique(data$type)
setups <- unique(data$setup)

for(k in 1:length(setups)){
for(i in 1:length(types)){
  counts <- as.data.frame(vennCounts(subset(convergence,setup == setups[k] & type == types[i])[,4:6])[,1:4])
  names(counts)[1:3] <- levels(data$environment)

  # Replace 1s with name of environment
  for(j in 1:length(unique(data$environment))){
    counts[counts[,j] == 0,j] <- ""
    counts[counts[,j] == 1,j] <- names(counts)[j]
  }
  
  # Merge environments to create variable
  counts <- cbind(counts,environment=1:dim(counts)[1])
  for(c in 1:dim(counts)[1]){
    counts$environment[c] <- paste(counts[c,1],counts[c,2],counts[c,3],sep="")
  }

  result <- rbind(result,
    data.frame(
      environment = counts$environment,
      setup       = setups[k],
      type        = types[i],
      count       = counts$Count
    )
  )
}
}

# Replace names of environments
result$environment <- find.replace(result$environment,
  c('ammglcsul', 'glc',           'amm',            'sul',            'ammsul', 'glcsul', 'ammglc'),
  c('all',       'glucose\nonly', 'ammonium\nonly', 'sulphate\nonly', 'mixed',  'mixed',  'mixed' )
)

# Aggregate mixed environments
result <- cast(melt(result,measure.var=c('count')),fun=sum)

# Order environment types in plot
ordered_types <- as.ordered(1:5)
levels(ordered_types)[1] <- "all"
levels(ordered_types)[2] <- "glucose\nonly"
levels(ordered_types)[3] <- "ammonium\nonly"
levels(ordered_types)[4] <- "sulphate\nonly"
levels(ordered_types)[5] <- "mixed"
result$environment <- factor(result$environment,levels=ordered_types)

# Order solutions types in plot
ordered_types <- as.ordered(1:2)
levels(ordered_types)[1] <- "suboptimal"
levels(ordered_types)[2] <- "optimal"
result$setup <- factor(result$setup,levels=ordered_types)

plot <- barchart(
  count ~ environment | type + setup,
  data=subset(result,type != 'at maximum' & environment != "" ),
  ylab="Reaction frequency",
  xlab="Environment use",
  col="grey60"
)
plot$y.limits <- c(0,175)

postscript("results/constraints.eps",width=12,height=8,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()

