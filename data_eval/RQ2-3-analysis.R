library(tidyverse)
library(ggplot2)
library(reshape2)
library(gridExtra)

# RQ="1" will generate the figure for RQ2.1 and RQ3.1
# RQ = "1"
# fileName = "commented"

# RQ="2" will generate the figure for RQ2.2 and RQ3.2
RQ = "2"
fileName = "revised"


#load data generated from python scripts
tokens.lime = read.csv(paste0("csv_",fileName,"_limescore.csv"),stringsAsFactors = F)
raw.line = read.csv(paste0("csv_",fileName,"_lineLevel_raw.csv"),stringsAsFactors = F)

if(sum(is.na(raw.line$limeAvgScore)) > 0){
  raw.line[is.na(raw.line$limeAvgScore),]$limeAvgScore = 0
}

#RQ2:How accurate is our approach in predicting changed lines that reviewers should pay attention to?
lime_avg_sensitivity = data.frame()
lime_topk_sensitivity = data.frame()

for( i in 1:10){
k = 5*i
top_k.tokens = tokens.lime %>% select(-lineNumber) %>% unique() %>% filter(limeScore > 0) %>% group_by(dataset, changeId, fileName) %>% top_n(k)

top_k.counts = tokens.lime %>% left_join(top_k.tokens, by=c("dataset","changeId","fileName","token")) %>% 
  ungroup() %>% mutate(isTopK = !is.na(limeScore.y) ) %>%
  group_by(dataset, changeId, fileName, lineNumber) %>% summarize(numTopK = sum(isTopK))

results = raw.line %>% left_join(top_k.counts)  %>% ungroup() %>% mutate(predict.lime = numTopK > 0 ) %>%
  group_by(dataset, changeId, fileName) %>% summarize(lime.TP = sum(predict.lime == TRUE & groundTruth == 1), lime.FN = sum(predict.lime == FALSE & groundTruth == 1),
                                            lime.FP = sum(predict.lime == TRUE & groundTruth == 0), lime.TN = sum(predict.lime == FALSE & groundTruth == 0)) 


  results$recall = results$lime.TP/(results$lime.TP + results$lime.FN)
  results$far = results$lime.FP/(results$lime.FP + results$lime.TN)
  results[is.nan(results$far),]$far = 0
  results$d2h = sqrt((   ((1-results$recall)^2) + ((0-results$far)^2))/2)
  lime_topk_sensitivity = rbind(lime_topk_sensitivity, data.frame(k = k, avg_recall = mean(results$recall), avg_far = mean(results$far), avg_d2h = mean(results$d2h)     ))
}

lime_sensitivity = data.frame()
ngram_sensitivity = data.frame()

for(i in 0:30)
{
  ngram_t = 0
  ngram_t = ngram_t + (0.1*i)
  results = raw.line %>% ungroup() %>% mutate(predict = ngramScore > ngram_t ) %>%
    group_by(dataset, changeId, fileName) %>% summarize(TP = sum(predict == TRUE & groundTruth == 1), FN = sum(predict == FALSE & groundTruth == 1),
                                              FP = sum(predict == TRUE & groundTruth == 0), TN = sum(predict == FALSE & groundTruth == 0))
  results$recall = results$TP/(results$TP + results$FN)
  results$far = results$FP/(results$FP + results$TN)
  results[is.nan(results$far),]$far = 0
  results$d2h = sqrt((   ((1-results$recall)^2) + ((0-results$far)^2))/2)

  ngram_sensitivity = rbind(ngram_sensitivity, data.frame(ngram_t = ngram_t, avg_recall = mean(results$recall), avg_far = mean(results$far), avg_d2h = mean(results$d2h)     ))
}


lime_topk_sensitivity = lime_topk_sensitivity %>% arrange(avg_d2h) 
ngram_sensitivity = ngram_sensitivity %>% arrange(avg_d2h)
ngram_t = ngram_sensitivity$ngram_t[1]
k_t = lime_topk_sensitivity$k[1]

top_k.tokens = tokens.lime %>% select(-lineNumber) %>% unique() %>% filter(limeScore > 0) %>% group_by(dataset, changeId, fileName) %>% top_n(k_t)

top_k.tokens %>% group_by(dataset, changeId, fileName) %>% summarize(zero_score = sum(limeScore == 0), negative_score = sum(limeScore < 0)) %>% group_by(dataset) %>% summarize(num_file_zero_score = sum(zero_score > 0), num_file_negative_score = sum(negative_score > 0), total_files = n())

top_k.counts = tokens.lime %>% left_join(top_k.tokens, by=c("dataset","changeId","fileName","token")) %>% 
  ungroup() %>% mutate(isTopK = !is.na(limeScore.y) ) %>%
  group_by(dataset, changeId, fileName, lineNumber) %>% summarize(numTopK = sum(isTopK))

num_tokens = tokens.lime %>% group_by(dataset, changeId, fileName, lineNumber) %>% summarize(token.count = n())

raw.line = raw.line %>% left_join(top_k.counts) %>% left_join(num_tokens)

raw.line$numTopK <- raw.line$numTopK * raw.line$lengthScore


results = raw.line %>% ungroup() %>% mutate(predict.ngram = ngramScore > ngram_t, predict.limeTopK = numTopK > 0) %>% 
  group_by(dataset, changeId, fileName) %>% summarize(
                                            limeTopK.TP = sum(predict.limeTopK == TRUE & groundTruth == 1), limeTopK.FN = sum(predict.limeTopK == FALSE & groundTruth == 1),
                                            limeTopK.FP = sum(predict.limeTopK == TRUE & groundTruth == 0), limeTopK.TN = sum(predict.limeTopK == FALSE & groundTruth == 0),
                                            ngram.TP = sum(predict.ngram == TRUE & groundTruth == 1), ngram.FN = sum(predict.ngram == FALSE & groundTruth == 1),
                                            ngram.FP = sum(predict.ngram == TRUE & groundTruth == 0), ngram.TN = sum(predict.ngram == FALSE & groundTruth == 0)) 

results = results %>% ungroup() %>% mutate(
                                 limeTopK.recall = limeTopK.TP/(limeTopK.TP + limeTopK.FN),  
                                 limeTopK.far = limeTopK.FP/(limeTopK.FP+limeTopK.TN),
                                 ngram.recall = ngram.TP/(ngram.TP + ngram.FN),
                                 ngram.far = ngram.FP/(ngram.FP + ngram.TN))

if(sum(is.nan(results$limeTopK.far)) > 0){
  results[is.nan(results$limeTopK.far),]$limeTopK.far = 0
}

if(sum(is.nan(results$ngram.far)) > 0){
  results[is.nan(results$ngram.far),]$ngram.far = 0
}


results = results %>% ungroup() %>% mutate(
                                           limeTopK.d2h = sqrt((   ((1-limeTopK.recall)^2) + ((0-limeTopK.far)^2))/2),
                                           ngram.d2h = sqrt((   ((1-ngram.recall)^2) + ((0-ngram.far)^2))/2),
)

#RQ3: How effective is our approach in prioritizing thechanged linesthat reviewers should pay attention to?
total = raw.line %>% group_by(dataset, changeId, fileName) %>% summarize(totalTrue = sum(groundTruth), totalLine = n())
 
top10.per = raw.line %>% group_by(dataset, changeId, fileName) %>% summarize(totalTrue = sum(groundTruth))

top10.per =  raw.line %>% group_by(dataset, changeId, fileName) %>% top_n(10, ngramScore) %>%
  summarize(ngram.Top10 = sum(groundTruth)) %>% merge(top10.per) %>% mutate(ngram.Top10Per = ngram.Top10/totalTrue)


top10.per =  raw.line %>% group_by(dataset, changeId, fileName) %>% top_n(10, numTopK) %>%
  summarize(limeTopK.Top10 = sum(groundTruth)) %>% merge(top10.per) %>% mutate(limeTopK.Top10Per = limeTopK.Top10/totalTrue)


# Effort@20%Recall measures the percentage of the amount of effort that developers have to spend to find the actual 20% defective lines of a given defect-introducing commit. 
total.True = raw.line %>% group_by(dataset, changeId, fileName) %>% summarize(totalTrue = sum(groundTruth))

eff20recall = raw.line %>% merge(total.True) %>% group_by(dataset, changeId, fileName) %>% arrange(-ngramScore, .by_group = T) %>%
  mutate(recall_line = case_when(groundTruth == 1 ~ cumsum(groundTruth)/totalTrue, groundTruth == 0 ~ 0)) %>% 
  mutate(isTest = ifelse(totalTrue >= 5, which.max(round(recall_line, digits = 2) <= 0.2 & round(recall_line, digits = 2) >0), first(which(round(recall_line, digits = 2)>0))), line = row_number()) %>% 
  summarize(ngram.eff20Recall = ifelse(totalTrue >= 5, which.max(round(recall_line, digits = 2) <= 0.2 & round(recall_line, digits = 2) >0), first(which(round(recall_line, digits = 2)>0))) /n()) %>% distinct()

eff20recall = 
  raw.line %>% merge(total.True) %>% group_by(dataset, changeId, fileName) %>% arrange(-numTopK, .by_group = T) %>%
  mutate(recall_line = case_when(groundTruth == 1 ~ cumsum(groundTruth)/totalTrue, groundTruth == 0 ~ 0)) %>% 
  mutate(isTest = ifelse(totalTrue >= 5, which.max(round(recall_line, digits = 2) <= 0.2 & round(recall_line, digits = 2) >0), first(which(round(recall_line, digits = 2)>0))), line = row_number()) %>% 
  summarize(limeTopK.eff20Recall = ifelse(totalTrue >= 5, which.max(round(recall_line, digits = 2) <= 0.2 & round(recall_line, digits = 2) >0), first(which(round(recall_line, digits = 2)>0))) /n()) %>% distinct() %>% merge(eff20recall)

#Initial False Alarm (IFA) measures the number of clean lines that developers need to inspect until finding the first actual defective line for a given commit.
IFA =  raw.line %>% mutate(isFalse = groundTruth==0) %>% group_by(dataset, changeId, fileName) %>% arrange(-ngramScore, .by_group = T) %>% 
  mutate(IFA = cumsum(isFalse)) %>% filter(isFalse == FALSE) %>% summarize(ngram.IFA = first(IFA)) 

IFA =  raw.line %>% mutate(isFalse = groundTruth==0) %>% group_by(dataset, changeId, fileName) %>% arrange(-numTopK, .by_group = T) %>% 
  mutate(IFA = cumsum(isFalse)) %>% filter(isFalse == FALSE) %>% summarize(limeTopK.IFA = first(IFA)) %>% merge(IFA)

total = raw.line %>% group_by(dataset, changeId, fileName) %>% summarize(totalTrue = sum(groundTruth), totalLine = n())

# Generate figure for RQ2
performance = results %>% select(ends_with(c("dataset","changeId","fileName","recall","far","d2h")))
performance = performance %>% replace(is.na(.), 0)
performance$dataset[performance$dataset == "base"] <- "QtBase"
performance$dataset[performance$dataset == "nova"] <- "OpenstackNova"
performance$dataset[performance$dataset == "ironic"] <- "OpenstackIronic"
performance$dataset <- factor(performance$dataset, levels = c('QtBase','OpenstackNova','OpenstackIronic'), ordered = TRUE)
colnames(performance) <- c("dataset", "changeId", "fileName", "Our Approach.Recall", "N-gram.Recall", "Our Approach.FAR", "N-gram.FAR","Our Approach.d2h", "N-gram.d2h")
perforance_new = performance %>% melt() %>%
  separate(variable, c("technique","measure"), sep = "[.]") 
perforance_new$technique <- factor(perforance_new$technique, levels = c('Our Approach','N-gram'))
perforance_new %>% ggplot() + geom_boxplot(aes(x=technique, y = value, fill=technique),show.legend = FALSE) + 
  facet_wrap(. ~ measure, scales = "free", ncol=3) + scale_fill_brewer(palette = "Blues") + theme_bw() + 
  theme(legend.title = element_blank(),axis.title=element_blank(),axis.text = element_text(size = 10)) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 
ggsave(paste0("./figures/RQ2.",RQ,".pdf"), width=4, height = 3.5)

# Generate figure for RQ3
performance = results  %>% left_join(eff20recall) %>% left_join(IFA) %>% select(ends_with(c("dataset","changeId","fileName","eff20Recall","IFA")))
performance = performance %>% replace(is.na(.), 0)
performance$dataset[performance$dataset == "base"] <- "QtBase"
performance$dataset[performance$dataset == "nova"] <- "OpenstackNova"
performance$dataset[performance$dataset == "ironic"] <- "OpenstackIronic"
performance$dataset <- factor(performance$dataset, levels = c('QtBase','OpenstackNova','OpenstackIronic'), ordered = TRUE)
colnames(performance) <- c("dataset", "changeId", "fileName", "Our Approach.Effort20%Recall", "N-gram.Effort20%Recall", "Our Approach.IFA", "N-gram.IFA")
perforance_new = performance %>% melt() %>%
  separate(variable, c("technique","measure"), sep = "[.]") 

perforance_new$technique <- factor(perforance_new$technique, levels = c('Our Approach','N-gram'))
g1 <- perforance_new %>% ggplot() + geom_boxplot(aes(x=technique, y = value, fill=technique),show.legend = FALSE)  + 
  facet_wrap(. ~ measure, scales = "free", ncol=2) + scale_fill_brewer(palette = "Blues") + theme_bw() + 
  theme(legend.title = element_blank(),axis.title=element_blank(),axis.text = element_text(size = 10)) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 

top10.acc = top10.per %>% select(ends_with(c("dataset","changeId","Top10"))) %>% melt() %>% separate(variable, c("technique","measure"), sep = "[.]") %>% 
  group_by( technique) %>% summarize(Top10ACC = sum(value > 0)*100/n())

top10_x <- c("Top10Accuracy")
top10_y <- c("Our Approach","N-gram")
top10_z <- as.numeric(formatC(top10.acc$Top10ACC/100, digits=2, format="f"))
top10_z
top10_df <- data.frame(x = top10_x, y = top10_y, z = top10_z)
top10_df$title <- "Top10Accuracy"
g2 <- ggplot(data=top10_df, mapping = aes(x = y, y = z, fill = rev(y)),show.legend = FALSE) + geom_bar(color="black",stat = "identity", width=0.7, position = position_dodge(width=0)) + scale_fill_brewer(palette = "Blues") + theme_bw() + theme(legend.title = element_blank(),axis.title=element_blank(), strip.text = ,legend.position = 'none',axis.text = element_text(size = 10)) + geom_text(mapping = aes(label = top10_z), size = 3, colour = 'black', vjust = 1.3, position = position_dodge(0.5)) + ylim(0,1) + scale_x_discrete(limits=c('Our Approach','N-gram')) + facet_grid(. ~ title) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) 

pdf(paste0("./figures/RQ3.",RQ,".pdf"), width=4.5, height = 3.5)
grid.arrange(g2,g1, ncol=2, widths=c(0.33, 0.66))
dev.off()
