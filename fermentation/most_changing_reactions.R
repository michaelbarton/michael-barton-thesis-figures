rm(list=ls())

# Added desriptor column to each data type
data <- rbind(
  cbind(read.csv(file="data/original.csv")[,-4],type="Original"),
  cbind(read.csv(file="data/closed_reactions.csv")[,-4],type="Closed Reactions"),
  cbind(read.csv(file="data/closed_reactions_with_moma.csv")[,-4],type="Closed Reactions + MOMA")
)

# Sort data by difference in between environments
data$diff <- data$resp - data$ferm
data <- data[
          order(
            abs(data$diff),
            decreasing = TRUE
          ),
        ]



types <- sort(unique(data$type))
for(i in 1:length(types)){
  most_changing = head(subset(data,type == types[i]))

  cols <- c()
  for(j in 1:length(most_changing$diff)){
    if(most_changing$diff[j] > 0){
      cols[j] <- "grey30"
    } else {
      cols[j] <- "grey70"
    }
  }

  postscript(paste("changing_reactions_",i,".eps",sep=""),width=7,height=7,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
  barplot(
    log2(abs(most_changing$diff)),
    names.arg = most_changing$reaction,
    ylim = c(0,max(log2(abs(data$diff))) + 1),
    xlab = "Reaction",
    ylab = "Difference in reaction flux (log.2)",
    col=cols
    )
  graphics.off()
}

