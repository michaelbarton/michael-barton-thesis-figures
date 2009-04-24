rm(list=ls())
require(lattice)
require(reshape)

data <- read.csv(file="data/fixation_usage.csv")

plot_data <- data.frame(
  species  = character(0),
  acid     = character(0),
  fixed    = logical(0),
  level    = numeric(0),
  weight   = numeric(0),
  count    = numeric(0)
)

for(i in 1:3){
  tmp <- data
  tmp$fixed <- (tmp$fixed >= i)
  melted <- melt(tmp,measure.var="count")
  tmp <- cast(melted,fun.aggregate=sum)
  plot_data <- rbind(plot_data,data.frame(
    species  = tmp$species,
    acid     = tmp$acid,
    fixed    = tmp$fixed,
    level    = i,
    weight   = tmp$weight,
    count    = tmp$count
  ))
}

plot_data$level <- ordered(plot_data$level)
levels(plot_data$level) <- c("weak","strong","identical")

plot_data$fixed <- ordered(plot_data$fixed)
levels(plot_data$fixed) <- c("variable","fixed")


plot <- xyplot(
  count ~ weight | fixed + factor(level),
  data=plot_data,
  xlab="Molecular weight (Da)",
  ylab="Amino acid frequency",
  panel=function(x,y,subscripts){

    panel.xyplot(x,y,col="grey60")

    # Calculate median values for acids between species
    panel_data <- melt(plot_data[subscripts,],measure.var="count")
    panel_data <- na.omit(cast(panel_data,acid + fixed + weight ~ variable,median))

    panel.loess(panel_data$weight,panel_data$count,lty=2)
    panel.xyplot(panel_data$weight,panel_data$count)

    spearman = cor(panel_data$weight,panel_data$count,method="spearman")
    panel.text(95,135000,
      paste("R = ",round(spearman,digits=3))
    )
  }
)

postscript("results/usage_given_fixation.eps",width=8,height=12,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
