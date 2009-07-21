rm(list=ls())
require(lattice)
require(reshape)
source('../helper/panel_functions.R')

data <- read.csv(file="data/fixation_usage.csv")
data <- subset(data, cost_type == "glu-rel" | cost_type == "glu-abs" | cost_type == "weight")

plot_data <- data.frame(
  species   = character(0),
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

  for(j in 1:3){
    tmp <- sub_data
    tmp$fixed <- (tmp$fixed >= j)
    melted <- melt(tmp,measure.var="count")
    tmp <- cast(melted,fun.aggregate=sum)
    plot_data <- rbind(plot_data,data.frame(
      species   = tmp$species,
      acid      = tmp$acid,
      fixed     = tmp$fixed,
      level     = j,
      cost      = tmp$cost,
      cost_type = tmp$cost_type,
      count     = tmp$count
    ))
  }
}

plot_data$level <- ordered(plot_data$level)
levels(plot_data$level) <- c("conservation at PAM250 > 0","conservation at PAM250 > 0.5","conservation at identical")

con_levels <- ordered(1:2)
levels(con_levels) <- c(TRUE,FALSE)

plot_data$fixed <- factor(plot_data$fixed, levels = con_levels)
levels(plot_data$fixed) <- c("conserved sites","non-conserved sites")

legends <- c("Molecular weight (Da)","Glucose absolute cost","Glucose relative cost")

for(i in 1:length(types)){
  sub_plot_data <- subset(plot_data,plot_data$cost_type == types[i])
  file = paste("results/usage_given_fixation_",types[i],".eps",sep="")

plot <- xyplot(
  count ~ cost | fixed + level,
  data=sub_plot_data,
  scales=list(relation="free", tick.number=3),
  ylim=list(c(0,130000),c(0,30000),c(0,130000),c(0,50000),c(0,130000),c(0,60000)),
  xlab=legends[i],
  ylab="Median amino acid frequency",
  panel=function(x,y,subscripts){

    panel.xyplot(x,y,col="grey60")

    # Calculate median values for acids between species
    panel_data <- melt(sub_plot_data[subscripts,],measure.var="count")
    panel_data <- na.omit(cast(panel_data,acid + fixed + cost ~ variable,median))

    panel.confidence(panel_data$cost,panel_data$count)
    panel.xyplot(panel_data$cost,panel_data$count)
    panel.spearman(panel_data$cost,panel_data$count)
    
  }
)

postscript(file,width=8,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
}

