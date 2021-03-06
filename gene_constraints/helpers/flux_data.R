source('helpers/find_replace.R')

flux_data_with_clusters <- function(){

  scaled <- flux_data()

  # Cluster flux into zero high low medium
  scaled$cluster <- factor(kmeans(scaled$value,c(-15,0,10))$cluster)
  scaled$cluster <- find.replace(scaled$cluster,c(1,2,3),c("zero","low","high"))

  scaled
}

flux_data <- function(){
  library(reshape)

  data <- read.csv(file='data/gene_constraint.csv',header=TRUE)

  scaled <- cast( melt(data,measure.var="flux"), gene + reaction + setup ~ environment + variable)

  scaled <- na.omit(scaled)

  # ignore rows where all values are very close to zero or the same across environments
  scaled <- subset(scaled, !(abs(glc_flux) < 0.001 & abs(amm_flux) < 0.001 & abs(sul_flux) < 0.001))
  scaled <- subset(scaled, !(glc_flux == amm_flux & amm_flux == sul_flux))

  # convert back to long data frame
  class(scaled) <- "data.frame"
  scaled <- melt(scaled,id.var=c("gene","setup","reaction"))

  # Take absolute log of each value
  scaled$value <- log2(abs(scaled$value + 0.00001))

  # Replace environment name
  scaled$variable <- find.replace(scaled$variable,
    c("glc_flux","amm_flux","sul_flux"),
    c("glucose", "ammonium","sulphate")
  )

  scaled
}
