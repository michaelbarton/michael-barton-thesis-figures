rm(list=ls())
library(reshape)

find.replace <- function(vector,find,replace.with){
  if(length(find) == length(replace.with)){
    for(i in 1:length(find)){
      index <- which(levels(vector) == find[i])
      levels(vector)[index] <- replace.with[i]
    }
  } else {
    stop("Find and replace vectors should be same length")
  }
  vector
}

data <- read.csv(file='data/gene_constraint.csv',header=TRUE)

# scale each reaction by mean across environments
scaled <- cast( melt(data,measure.var="flux"), gene ~ environment + variable)

# ignore rows where all values are very close to zero
scaled <- subset(scaled, !(abs(glc_flux) < 0.001 & abs(nit_flux) < 0.001 & abs(sul_flux) < 0.001))

# ignore rows where all values are the same
scaled <- subset(scaled, !(glc_flux == nit_flux & nit_flux == sul_flux))

# convert back to long data frame
class(scaled) <- "data.frame"
scaled <- melt(scaled,id.var="gene")

# Take absolute log of each value
scaled$value <- log2(abs(scaled$value + 0.00001))

# Replace environment name
scaled$variable <- find.replace(scaled$variable,
  c("glc_flux","nit_flux","sul_flux"),
  c("glucose", "ammonium","sulphate")
)

postscript("results/use_density.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(
  density(scaled$value),
  type="n",
  ylim=c(0,0.05),
  #xlim=c(-100,50),
  xlab="Absolute reaction flux (log.2)",
  main=""
)

envs <- levels(scaled$variable)
line_types <- c(2,1,3)
colors <- c("grey20","grey40",'black')

legend(
  'topleft',
  legend = envs,
  lty    = line_types,
  col    = colors
)

for(i in 1:length(envs)){
  lines(
    density(scaled$value[scaled$variable == envs[i]]),
    lty = line_types[i],
    col = colors[i]
  )
}

graphics.off()
