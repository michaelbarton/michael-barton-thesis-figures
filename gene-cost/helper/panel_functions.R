library(grid)

panel.anova <- function(x,y){
  aov_summary <- summary.lm(aov(y ~ x))
  r_sq <- round(digits = 2,aov_summary$adj.r.squared)
  p    <- signif(digits = 2,1 - pf(aov_summary$fstatistic[1],aov_summary$fstatistic[2],aov_summary$fstatistic[3]))

  grid.text(
    paste('R = ',r_sq,', p = ',p),
    x=unit(0.05,"npc"),
    y=unit(0.95,"npc"),
    just='left'
  )
}
