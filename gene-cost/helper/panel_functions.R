library(grid)

panel.anova <- function(x,y){
  aov_summary <- summary.lm(aov(y ~ x))
  r_sq <- round(aov_summary$r.squared, digits = 3)
  p    <- round(1 - pf(
    aov_summary$fstatistic[1],
    aov_summary$fstatistic[2],
    aov_summary$fstatistic[3]),
    digits = 3
  )

  panel.regression.values(r_sq,p,TRUE)
}

panel.binomial <- function(x,y,lwd=2,col="grey50"){
  model <- glm(y ~ x,binomial)

  continuous <- seq(min(x),max(x),(max(x) - min(x)) * 0.01)
  predicted <- predict(model,list(x=continuous),type="response")
  panel.lines(continuous,predicted,lwd=lwd,col=col)

  model.sum <- summary.glm(model)
  p <- round(model.sum$coefficients[2,4],3)

  cor <- cor.test(predict(model,list(x=x),type="response"),y,method="spear")
  r_sq <- round(cor$estimate^2,3)

  panel.regression.values(r_sq,p,TRUE)

}

panel.spearman <- function(x,y){
  cor <- cor.test(x,y,method="spear")
  r_sq <- round(cor$estimate,3)
  p    <- round(cor$p.value,3)
  panel.regression.values(r_sq,p)
}

panel.regression.values <- function(r.value,p.value,squared=FALSE){
  if(squared == TRUE){
    r = bquote(R^2 ==  .(r.value))
  } else {
    r = bquote(R ==  .(r.value))
  }
  p = bquote(p ==  .(p.value))

  grid.text(r, x=unit(0.075,"npc"), y=unit(0.925,"npc"), just='left')
  grid.text(p, x=unit(0.4,"npc"), y=unit(0.905,"npc"), just='left')
}
