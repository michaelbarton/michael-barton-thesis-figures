rm(list=ls())
library(lattice)
library(reshape)

source('helper/find_replace.R')
source('helper/panel_functions.R')

data <- read.csv(file='data/mutation/flux.csv')
data <- data[,c(1,2,3,6,7)]

data$flux <- log2(abs(data$flux) + 0000.1)

env_wise <- cast(melt(data),gene + solution ~ environment + variable)

env_wise <- subset(env_wise, !(abs(glc_flux) < 0.001 & abs(amm_flux) < 0.001 & abs(sul_flux) < 0.001))
env_wise <- subset(env_wise, !(glc_flux == amm_flux & amm_flux == sul_flux))

plot_data <- data.frame(
  gene  = rep(env_wise$gene,3),
  sol   = rep(env_wise$solution,3),
  env   = rep(c("glucose","ammonium","sulfur"),each=length(env_wise$gene)),
  dN_dS = c(env_wise$glc_dN_dS, env_wise$amm_dN_dS, env_wise$sul_dN_dS),
  flux  = c(env_wise$glc_flux, env_wise$amm_flux, env_wise$sul_flux)
)

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
plot_data$sol <- factor(plot_data$sol,levels=order)

plot <- xyplot(
  dN_dS ~ flux | env + sol,
  data=plot_data,
  xlab="log. Reaction flux",
  ylab="dN/dS",
  panel=function(x,y,...){
    panel.xyplot(x,y,...)
    panel.spearman(x,y)
  }
)

postscript("results/mutation/dn_ds/non_trivial_flux.eps",width=10,height=6,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
