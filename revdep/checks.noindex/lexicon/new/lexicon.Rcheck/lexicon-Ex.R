pkgname <- "lexicon"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('lexicon')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("available_data")
### * available_data

flush(stderr()); flush(stdout())

### Name: available_data
### Title: Get Available 'lexicon' Data
### Aliases: available_data

### ** Examples

available_data()
available_data('hash_')
available_data('hash_sentiment')
available_data('python')
available_data('prof')
available_data('English')
available_data('Stopword')



cleanEx()
nameEx("hash_emoticons")
### * hash_emoticons

flush(stderr()); flush(stdout())

### Name: hash_emoticons
### Title: Emoticons
### Aliases: hash_emoticons
### Keywords: datasets

### ** Examples

## Not run: 
##D library(data.table)
##D hash_emoticons[c(':-(', '0:)')]
## End(Not run)



cleanEx()
nameEx("hash_grady_pos")
### * hash_grady_pos

flush(stderr()); flush(stdout())

### Name: hash_grady_pos
### Title: Grady Ward's Moby Parts of Speech
### Aliases: hash_grady_pos grady_pos_feature
### Keywords: datasets

### ** Examples

## Not run: 
##D library(data.table)
##D 
##D hash_grady_pos <- grady_pos_feature(hash_grady_pos)
##D hash_grady_pos['dog']
##D hash_grady_pos[primary == TRUE, ]
##D hash_grady_pos[primary == TRUE & space == FALSE, ]
## End(Not run)



cleanEx()
nameEx("hash_sentiment_nrc")
### * hash_sentiment_nrc

flush(stderr()); flush(stdout())

### Name: hash_sentiment_nrc
### Title: NRC Sentiment Polarity Table
### Aliases: hash_sentiment_nrc
### Keywords: datasets

### ** Examples

## Not run: 
##D library(data.table)
##D hash_sentiment_nrc[c('happy', 'angry')]
## End(Not run)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
