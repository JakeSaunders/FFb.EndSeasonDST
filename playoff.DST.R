# set dir and load data 
setwd("C:/Users/saundecj/Google Drive/@R/fantasy.football/FFb2020/EndSeasonDST")
sch <-  read.csv("schedule.csv",stringsAsFactors = F)[1:32,]
rnk <- read.csv("Rankings.csv",stringsAsFactors = F)

#clean data
rnk$OPRK <- as.numeric(sub("st|nd|rd|th","",rnk$OPRK))
getRanks <- rnk$OPRK
getRanks <- c(getRanks,NA)
names(getRanks) <- c(sub("\\s","",rnk$OPP), "BYE")
sch$PLAYER <- sub("\\sD/ST","",sch$PLAYER)

#check things are working
getRanks
getRanks["BYE"]
getRanks["Atl"]
getRanks["Wsh"]

getRanks[sch$OPP]
getRanks[sch$NFL.WEEK.11]
getRanks[sch$NFL.WEEK.12]

sch$OPP[ names(getRanks) %in% sch$OPP]
getRanks[ names(getRanks) %in% sch$OPP]

sch$OPP[ sch$OPP %in% names(getRanks)]
getRanks[ sch$OPP %in% names(getRanks)]


# add columns with num rank
sch$wk14rnk <- getRanks[sch$NFL.WEEK.14]
sch$wk15rnk <- getRanks[sch$NFL.WEEK.15]
sch$wk16rnk <- getRanks[sch$NFL.WEEK.16]

# make more workerable df
df <- sch[,c(1,6:8,10:12)]
rownames(df) <- df$PLAYER
df$avg <- round(rowMeans(df[,5:7]),2)
df$sd <- round(apply(df[,5:7],1,sd),2)
    
#make heat map
hm <- df[,5:7]
rownames(hm) <- df[,1]
hm
hm[order(-df$avg),]


pheatmap::pheatmap(
    mat = hm[order(-df$avg),],color =  colorRampPalette(c("red","gray", "blue"))(30),
    scale = "none", 
    #cellheight = 9,cellwidth = 20,
    cellwidth = 40,border_color=NA,
    cluster_cols = F,cluster_rows = F,
    legend = T,legend_breaks = c(5,25),legend_labels = c("Lower Score Against","Higher Score Against"),
    #annotation_col = df[order(-df$avg),8],
    display_numbers = df[order(-df$avg),2:4],
    #number_color = "black",
    number_color = "orange",
    fontsize_number = 12,
    main = "DST with Weakest Fantasy Playoff Schedule"
)

barplot(
    height = df$avg[order(df$avg)],
    names.arg = df$PLAYER[order(df$avg)],
    las=2,cex.axis = 0.75,
    ylab="Avg Opponent Rank",
    main="DST with Weakest Fantasy Playoff Schedule"
)


pheatmap::pheatmap(
    mat = hm[order(-df$avg),],color =  colorRampPalette(c("red","gray", "blue"))(30),
    scale = "none", 
    #cellheight = 9,cellwidth = 20,
    cellwidth = 40,border_color=NA,
    cluster_cols = F,cluster_rows = F,
    legend = T,legend_breaks = c(5,25),legend_labels = c("Lower Score Against","Higher Score Against"),
    #annotation_col = df[order(-df$avg),8],
    display_numbers = df[order(-df$avg),2:4],
    number_color = "black",
    #number_color = "orange",
    fontsize_number = 12,
    main = "DST with Weakest Fantasy Playoff Schedule",
    filename = "Playoff.DST.pdf",width = 4.85,height = 8
)
