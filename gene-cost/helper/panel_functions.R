library(grid)

panel.anova <- function(x,y){
  aov_summary <- summary.lm(aov(y ~ x))
  r_sq <- aov_summary$r.squared
  p    <- 1 - pf(
    aov_summary$fstatistic[1],
    aov_summary$fstatistic[2],
    aov_summary$fstatistic[3]
  )

  panel.regression.values(r_sq,p,TRUE)
}

panel.binomial <- function(x,y,lwd=2,col="grey50"){
  model <- glm(y ~ x,binomial)

  continuous <- seq(min(x),max(x),(max(x) - min(x)) * 0.01)
  predicted <- predict(model,list(x=continuous),type="response")
  panel.lines(continuous,predicted,lwd=lwd,col=col)

  model.sum <- summary.glm(model)
  p <- model.sum$coefficients[2,4]

  cor <- cor.test(predict(model,list(x=x),type="response"),y,method="spear")
  r_sq <- cor$estimate^2

  panel.regression.values(r_sq,p,TRUE)

}

panel.spearman <- function(x,y){
  cor <- cor.test(x,y,method="spear")
  r_sq <- cor$estimate
  p    <- cor$p.value
  panel.regression.values(r_sq,p)
}

panel.regression.values <- function(r.value,p.value,squared=FALSE){
  formatted_r = round(r.value,digits=3)
  formatted_p = format(p.value,scientific=TRUE,digits=2)

  if(squared == TRUE){
    r = bquote(R^2 ==  .(formatted_r))
  } else {
    r = bquote(R ==  .(formatted_r))
  }
  p = bquote(p ==  .(formatted_p))

  grid.text(r, x=unit(0.075,"npc"), y=unit(0.925,"npc"), just='left')
  grid.text(p, x=unit(0.45,"npc"), y=unit(0.908,"npc"), just='left')
}
