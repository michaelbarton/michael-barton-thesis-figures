rm(list=ls())
require(lattice)
require(reshape)

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
levels(plot_data$level) <- c("weak conservation","strong conservation","identical")

plot_data$fixed <- ordered(plot_data$fixed)
levels(plot_data$fixed) <- c("non-conserved sites","conserved sites")

legends <- c("Molecular weight (Da)","Glucose absolute cost","Glucose relative cost")

for(i in 1:length(types)){
  sub_plot_data <- subset(plot_data,plot_data$cost_type == types[i])
  file = paste("results/usage_given_fixation_",types[i],".eps",sep="")

plot <- xyplot(
  count ~ cost | level + fixed,
  data=sub_plot_data,
  ylim=c(0,160000),
  xlab=legends[i],
  ylab="Amino acid frequency",
  panel=function(x,y,subscripts){

    panel.xyplot(x,y,col="grey60")

    # Calculate median values for acids between species
    panel_data <- melt(sub_plot_data[subscripts,],measure.var="count")
    panel_data <- na.omit(cast(panel_data,acid + fixed + cost ~ variable,median))

    panel.loess(panel_data$cost,panel_data$count,lty=2)
    panel.xyplot(panel_data$cost,panel_data$count)

    spearman = cor.test(panel_data$cost,panel_data$count,method="spearman")
    panel.text(min(x),150000,pos=4, paste("R = ",round(spearman$estimate,digits=3)))
    panel.text(min(x),135000,pos=4, paste("p = ",round(spearman$p.value,digits=4)))
  }
)

postscript(file,width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
}

