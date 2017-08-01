library(devtools)
library(dplyr)
library(readxl)
library(stringr)
library(tidyr)

load("data-raw/sysdata-old.rda")

temp_file <- tempfile(fileext = ".xlsx")
download.file("http://www.saifmohammad.com/WebDocs/NRC-Emotion-Lexicon-v0.92-InManyLanguages-web.xlsx", temp_file, quiet = TRUE)
raw_data <- read_excel(temp_file)

column_names <- tolower(names(raw_data))
column_names <- column_names %>% 
  str_replace("\\(google translate\\)", "") %>% 
  str_replace("translation", "") %>% 
  str_replace("word", "") %>% 
  str_trim() %>% 
  str_replace_all("[()]", "") %>% 
  str_replace(" ", "_")

raw_data <- setNames(raw_data, column_names)

n_sentiments <- 10
column_names_lang <- column_names[seq_len(length(column_names) - n_sentiments)]
column_names_sentiments <- column_names[-which(column_names %in% column_names_lang)]

lang_ascii <- c("basque", "catalan", "danish", "dutch", "english", "esperanto", "finnish", "french", "german", "irish", "italian", "latin", "portuguese", "romanian", "somali", "spanish", "sudanese", "swahili", "swedish", "turkish", "welsh", "zulu")

nrc <- raw_data %>% 
  gather_("lang", "word", column_names_lang) %>% 
  gather_("sentiment", "value", column_names_sentiments) %>% 
  filter(value > 0)

use_data(afinn, bing, nrc, syuzhet_dict, internal = TRUE, overwrite = TRUE)
