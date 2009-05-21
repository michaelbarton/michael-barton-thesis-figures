panel.confidence <- function(x,y,lwd=2,col="grey50"){

  model = rlm(y ~ x)
  continuous <- seq(min(x),max(x),(max(x) - min(x)) * 0.01)
  predicted <- predict(model,data.frame(x=continuous))
  confidence <- predict(model,data.frame(x=continuous),level = 0.95, interval = "confidence")

  panel.lines(continuous,predicted,lwd=lwd,col=col)
  panel.lines(continuous,confidence[,2],lty=2,lwd=lwd,col=col)
  panel.lines(continuous,confidence[,3],lty=2,lwd=lwd,col=col)
}
