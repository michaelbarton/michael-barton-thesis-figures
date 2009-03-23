
constraint_data <- function(){
  library(reshape)

  data <- read.csv(file='data/gene_constraint.csv',header=TRUE)

  scaled <- cast( melt(data,measure.var="flux"), gene + reaction + setup ~ environment + variable)

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
