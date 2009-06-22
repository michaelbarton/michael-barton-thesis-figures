rm(list=ls())
library(lattice)

source('helper/find_replace.R')
source('helper/panel_functions.R')

data <- read.csv(file='data/essentiality/constraint.csv')
data <- subset(data, constraint != "at maximum")

order <- as.ordered(1:2)
levels(order) <- c('suboptimal','optimal')
data$solution <- factor(data$solution,levels=order)

data$environment <- find.replace(data$environment,
  c('glc'     , 'amm'      , 'sul'), 
  c('glucose' , 'ammonium' , 'sulfur')
)

data$essential <- find.replace(data$essential,
  c('true'      , 'false'   ), 
  c('essential' , 'dispensible')
)
attach(data)
levels <- tapply(gene,list(essential,constraint,environment,solution),length)
detach(data)

environments <- unique(data$environment)
solutions <- unique(data$solution)


results <- data.frame(
  environment = character(),
  solution    = character(),
  value       = numeric()
)

for(i in 1:length(solutions)){
  for(j in 1:length(environments)){
    test <- chisq.test(levels[,,environments[j],solutions[i]])
    results <- rbind(results,data.frame(
      environment = environments[j],
      solution    = solutions[i],
      value       = round(test$p.value,digits=3)
    ))
  }
}

write.csv(file="results/essential/constraint_p_values.csv",results)
write.csv(file="results/essential/constraint.csv",na.omit(as.data.frame.table(levels)))
