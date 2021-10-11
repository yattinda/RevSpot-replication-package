library(tidyverse)
library(ggplot2)
library(gridExtra)
library("ggpubr")

raw = read.csv(paste0("motivation.csv"),stringsAsFactors = F)
# raw_time = read.csv(paste0("motivation_time.csv"),stringsAsFactors = F)
raw$dataset <- factor(raw$dataset, levels = c('OpenstackNova','OpenstackIronic', 'QtBase'), ordered = TRUE)
# raw_time$dataset <- factor(raw_time$dataset, levels = c('OpenstackNova','OpenstackIronic','QtBase'), ordered = TRUE)

initial_feedback_time <- raw %>% select(c("dataset","initial_feedback_time"))
percentage_time_cost <- raw %>% select(c("dataset","percentage_time_cost"))
code_size <- raw %>% select(c("dataset","added_lines"))
time_size_relation <- raw %>% select(c("dataset","added_lines","initial_feedback_time"))
percentage_cost_size_relation <- raw %>% select(c("dataset","added_lines","percentage_time_cost"))
time_size_relation %>% View()
g1 <- percentage_time_cost %>% ggplot() + geom_boxplot(aes(x=dataset, y = percentage_time_cost, fill=dataset),show.legend = FALSE)  + scale_y_continuous(breaks = 0:5*0.2, labels = scales::percent)+ scale_fill_brewer(palette = "Blues", direction=-1) + theme_bw() + labs(x="")+ labs(y="The Proportion of the Waiting Hours") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 

g2 <- initial_feedback_time %>% ggplot() + geom_boxplot(aes(x=dataset, y = initial_feedback_time, fill=dataset), show.legend = FALSE) + coord_cartesian(ylim= c(0,500))+ scale_fill_brewer(palette = "Blues", direction=-1) + theme_bw() + labs(x="") + labs(y="Waiting Hours to Receive the First Comment") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 

g3 <- code_size %>% ggplot() + geom_boxplot(aes(x=dataset, y = added_lines, fill=dataset), show.legend = FALSE) + coord_cartesian(ylim= c(0,500))+ scale_fill_brewer(palette = "Blues", direction=-1) + theme_bw() + labs(x="") + labs(y="Patchsize for Changed Patches") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 

g4 <- time_size_relation %>% ggplot(aes(x=added_lines,y=initial_feedback_time)) + geom_point(aes(color=factor(dataset)), show.legend = FALSE) + coord_cartesian(xlim=c(0,500),ylim= c(0,500))

g5 <- percentage_cost_size_relation %>% ggplot(aes(x=added_lines,y=percentage_time_cost)) + geom_point(aes(color=factor(dataset)), show.legend = FALSE) + coord_cartesian(xlim=c(0,500),ylim= c(0,1))

# spearman correlation test

cor_nova <- time_size_relation %>% filter(dataset == "OpenstackNova")
cor_ironic <- time_size_relation %>% filter(dataset == "OpenstackIronic")
cor_base <- time_size_relation %>% filter(dataset == "QtBase")

res_nova <- cor.test(cor_nova$added_lines,cor_nova$initial_feedback_time, method = c("spearman"))
res_ironic <- cor.test(cor_ironic$added_lines,cor_ironic$initial_feedback_time, method = c("spearman"))
res_base <- cor.test(cor_base$added_lines,cor_base$initial_feedback_time, method = c("spearman"))


pdf("./figures/motivation.pdf", width=4, height = 4)
grid.arrange(g2,g1,g3, ncol=3)
dev.off()

