rm(list=ls())
require(lattice)
require(reshape)

data <- read.csv(file="data/ancestral_acid_mutation_rates.csv")

shingle_levels <- 6
intervals <- co.intervals(data$mutation,shingle_levels)
interval_boundaries <- intervals[1:shingle_levels - 1,2]

plot_data <- data.frame(
  acid      = character(0),
  fixed     = logical(0),
  level     = numeric(0),
  cost      = numeric(0),
  cost_type = numeric(0),
  count     = numeric(0)
)

types <- unique(data$cost_type)
for(i in 1:length(types)){
 sub_data <- subset(data, cost_type == types[i])

  for(j in 1:length(interval_boundaries)){
    bound <- interval_boundaries[j]
    tmp <- sub_data
    
    # Determine row with greater mutation rate than threshold
    tmp$fixed <- (tmp$mutation <= j)

    # Count the numbers of each amino acid
    melted <- melt(tmp,measure.var=c("mutation"))
    tmp <- cast(melted,fun.aggregate=length)

    plot_data <- rbind(plot_data,data.frame(
      acid      = tmp$acid,
      fixed     = tmp$fixed,
      level     = j,
      cost      = tmp$cost,
      cost_type = tmp$cost_type,
      count     = tmp$mutation
    ))
  }
}

plot_data <- subset(plot_data,fixed == FALSE)

plot <- xyplot(
  count ~ cost | level + cost_type,
  data=plot_data,
  scale="free"
)


postscript(file="results/ancestral_usage_vs_fixation.eps",width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()

