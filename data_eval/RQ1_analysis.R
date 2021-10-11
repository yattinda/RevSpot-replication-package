library(ScottKnottESD)
library(ggplot2)
library(dplyr)

# RQ1.1
# load data
rq1file <- read.csv("csv_commented_fileLevel.csv")
rq1file <- rq1file[rq1file$Measure %in% c("AUC","Precision","Recall","F1 measure"),]
rq1file$Technique <- factor(rq1file$Technique, levels = c("RF", "DT","LG","Random Guessing"))
levels(rq1file$Technique) <- c("RF","DT","LR","Random")
rq1file$Datasets <- factor(rq1file$Datasets, levels=c("nova","ironic","base"))
levels(rq1file$Datasets) <- c("OpenstackNova","OpenstackIronic","QtBase")
rq1file <- rq1file %>% mutate_if(is.numeric, round, digits = 2)
ggplot(data=rq1file, aes(x=Technique, y=Value, fill=Technique)) + facet_grid( Datasets ~ Measure) + theme_bw() + 
  geom_bar(color="black",stat="identity",position = 'dodge') + scale_fill_brewer(name = "", labels = c("...."), palette = "Blues", direction=-1) + theme(legend.position = "none",legend.title = element_blank(),axis.title=element_blank()) + geom_col() +
  geom_text(aes(label = Value), colour = "black",size = 3,vjust = 1.3, hjust = 0.5) + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 
ggsave("./figures/RQ1.1.pdf",width=5,height=4)

# RQ1.2
# load data
rq2file <- read.csv("csv_revised_fileLevel.csv")
rq2file <- rq2file[rq2file$Measure %in% c("AUC","Precision","Recall","F1 measure"),]
rq2file$Technique <- factor(rq2file$Technique, levels = c("RF", "LG","NB","DT","Random Guessing"))
levels(rq2file$Technique) <- c("RF", "LR","NB","DT","Random")
rq2file$Datasets <- factor(rq2file$Datasets, levels=c("nova","ironic","base"))
levels(rq2file$Datasets) <- c("OpenstackNova","OpenstackIronic","QtBase")
rq2file <- rq2file %>% mutate_if(is.numeric, round, digits = 2)
ggplot(data=rq2file, aes(x=Technique, y=Value, fill=Technique)) + facet_grid( Datasets ~ Measure) + theme_bw() + 
  geom_bar(color="black",stat="identity",position = 'dodge') + scale_fill_brewer(name = "", labels = c("...."), palette = "Blues", direction=-1) + theme(legend.position = "none",legend.title = element_blank(),axis.title=element_blank()) + geom_col() +
  geom_text(aes(label = Value), colour = "black",size = 3,vjust = 1.3, hjust = 0.5) + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 
ggsave("./figures/RQ1.2.pdf",width=5,height=4)