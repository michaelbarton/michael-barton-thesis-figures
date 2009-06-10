library(grid)

panel.anova <- function(x,y){
  aov_summary <- summary.lm(aov(y ~ x))
  r_sq <- round(digits = 2,aov_summary$adj.r.squared)
  p    <- signif(digits = 2,1 - pf(
    aov_summary$fstatistic[1],
    aov_summary$fstatistic[2],
    aov_summary$fstatistic[3])
  )

  panel.regression.values(r_sq,p)
}

panel.spearman <- function(x,y){
  cor <- cor.test(x,y,method="spear")
  r_sq <- round(cor$estimate,3)
  p    <- round(cor$p.value,3)
  panel.regression.values(r_sq,p)
}

panel.regression.values <- function(r.square,p.value){
  grid.text(
    paste('R = ',r.square,', p = ',p.value),
    x=unit(0.05,"npc"),
    y=unit(0.95,"npc"),
    just='left'
  )
}
