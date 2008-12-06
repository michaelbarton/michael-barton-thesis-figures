library(lattice)
data = read.csv(file='curve.csv')

data$change <- (data$change)
data$biomass <- data$biomass * -1

envs = unique(data$env)
for(i in 1:length(envs)) {
  env = envs[i]
  data[data$env == env,]$biomass <- data[data$env == env,]$biomass - mean(data[data$env == env,]$biomass)
  
}

names = c("glucose","ammonium")
lines = c(1,2)

nit = data[data$env == 'ammonium',]
glu = data[data$env == 'glucose',]

postscript("curve.eps",width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")

plot(biomass ~ change,data=data,type='n',
  xlab="Relative change in amino acid requirement",
  ylab="Nutrient uptake flux")
lines(biomass ~ change, data=glu,lwd=2,lty=lines[1],col="grey20")
lines(biomass ~ change, data=nit,lwd=2,lty=lines[2],col="grey20")
legend("topleft",legend=names,lty=lines,col="grey20")

graphics.off()

