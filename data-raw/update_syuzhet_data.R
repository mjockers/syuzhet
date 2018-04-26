# Process for updating a lexicon. . . 
library(syuzhet)
library(readr)
load("R/sysdata.rda")
newfinn <- read_tsv("~/Desktop/afinn.txt", col_names = F) #downloaded from external
colnames(newfinn) <- c("word", "value")
afinn <- as.data.frame(newfinn)
save(afinn, bing, nrc, syuzhet_dict, file='R/sysdata.rda', compress='xz')

