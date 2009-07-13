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

attach(data)
levels <- tapply(gene,list(essential,constraint,environment,solution),length)
detach(data)

environments <- unique(data$environment)
solutions <- unique(data$solution)
constraints <- unique(data$constraint)
essentials <- unique(data$essential)

results <- data.frame(
  environment = character(),
  solution    = character(),
  constraint  = character(),
  essential   = character(),
  chi         = numeric(),
  observed    = numeric(),
  residual    = numeric()
)

for(i in 1:length(solutions)){
  for(j in 1:length(environments)){
    test <- chisq.test(levels[,,environments[j],solutions[i]])
    chi  <- round(test$p.value,digits=3)

    for(l in 1:length(constraints)){
      for(m in 1:length(essentials)){

        results <- rbind(results,data.frame(
          environment = environments[j],
          solution    = solutions[i],
          constraint  = constraints[l],
          essential   = essentials[m],
          chi         = chi,
          observed    = test$observed[essentials[m],constraints[l]],
          residual    = round(test$residuals[essentials[m],constraints[l]],digits=2)
        ))
      }
    }
  }
}

write.csv(file="results/essential/constraint.csv",results)

ordered_environments <- as.ordered(1:3)
levels(ordered_environments)[3] <- "glucose"
levels(ordered_environments)[2] <- "ammonium"
levels(ordered_environments)[1] <- "sulfur"
results$environment <- factor(results$environment,levels=ordered_environments)

ordered_solutions <- as.ordered(1:2)
levels(ordered_solutions)[1] <- "optimal"
levels(ordered_solutions)[2] <- "suboptimal"
results$solution <- factor(results$solution,levels=ordered_solutions)

ordered_essentials <- as.ordered(1:2)
levels(ordered_essentials)[1] <- "viable"
levels(ordered_essentials)[2] <- "inviable"
results$essential <- factor(results$essential,levels=ordered_essentials)

plot <- dotplot(
  residual ~ constraint | essential + environment,
  group = solution,
  auto.key=TRUE,
  ylab = "Pearson chi square residual",
  panel = function(x,y,...){
    panel.dotplot(x,y,...)
    panel.abline(h=0,lty=2)
  },
  data = results
)

postscript("results/essential/constraint.eps",width=6,height=10,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
print(plot)
graphics.off()
