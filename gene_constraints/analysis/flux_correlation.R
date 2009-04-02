rm(list=ls())
library(Hmisc)
library(reshape)
source('helpers/flux_data.R')

data <- flux_data()
data <- cast(data)

optimal <- as.matrix.data.frame(subset(data,setup == "optimal")[,4:6])
suboptimal <- as.matrix.data.frame(subset(data,setup == "suboptimal")[,4:6])

write.table(rcorr(optimal,type="spear")$r,file="results/optimal_flux_correlation.txt")
write.table(rcorr(optimal,type="spear")$P,append=TRUE,file="results/optimal_flux_correlation.txt")

write.table(rcorr(suboptimal,type="spear")$r,file="results/suboptimal_flux_correlation.txt")
write.table(rcorr(suboptimal,type="spear")$P,append=TRUE,file="results/suboptimal_flux_correlation.txt")
