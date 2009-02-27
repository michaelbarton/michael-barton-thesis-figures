rm(list=ls())

data <- read.csv('data/acid_mutation_rates.csv')

print(
  cor.test(data$weight,log(data$fixed),method='spear')
)
