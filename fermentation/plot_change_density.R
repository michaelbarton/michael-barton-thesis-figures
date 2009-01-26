rm(list=ls())
library(lattice)

# Added desriptor column to each data type
data <- rbind(
  cbind(read.csv(file="data/original.csv")[,-4],type="Original"),
  cbind(read.csv(file="data/closed_reactions.csv")[,-4],type="Closed Reactions"),
  cbind(read.csv(file="data/closed_reactions_with_moma.csv")[,-4],type="Closed Reactions + MOMA")
)

# Sort data by difference in between environments
data$diff <- data$resp - data$ferm
data <- data[order(data$diff),]

# Calculate density for each type

density_results <- data.frame(x=numeric(),y=numeric(),type=character())
types <- sort(unique(data$type))
for(i in 1:length(types)){
  subset_by_type = subset(data,type == types[i])

  density_by_type <- density(
                       log2(
                         abs(subset_by_type$diff)))

  density_results <- rbind(
    density_results,
    data.frame(x=density_by_type$x,y=density_by_type$y,type=types[i])
  )

}

# Plot
lines <- c(3,2,1)
cols <- c("grey30","grey50","grey70")


postscript("fermentation_density.eps",width=7,height=7,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(
  density_results$x,
  density_results$y,
  type='n',
  xlab="Absolute change in reaction flux (log. 2)",
  ylab="Density"
)

for(i in 1:length(types)){
  density_by_type = subset(density_results,type == types[i])

  lines(
    density_by_type$x,
    density_by_type$y,
    col=cols[i],
    lty=lines[i],
    lwd=3
  )

}

legend(
  'topright',
  legend = types,
  lty=lines,
  lwd=3,
  col=cols
)

graphics.off()

for(i in 1:length(types)){
  subset_by_type = subset(data,type == types[i])
 
  print(
    paste(
      "Non-zero changes for",
      types[i],
      ":",
      dim(subset(subset_by_type, diff != 0))[1]
    )
  )
}
