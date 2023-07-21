pkgname <- "tsentiment"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('tsentiment')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("checkConfirmForUSer")
### * checkConfirmForUSer

flush(stderr()); flush(stdout())

### Name: checkConfirmForUSer
### Title: User file permission checker
### Aliases: checkConfirmForUSer

### ** Examples

## Not run: 
##D checkConfirmForUser()
## End(Not run)



cleanEx()
nameEx("checkVersionForSentiment")
### * checkVersionForSentiment

flush(stderr()); flush(stdout())

### Name: checkVersionForSentiment
### Title: Check r Version
### Aliases: checkVersionForSentiment

### ** Examples

checkVersionForSentiment()



cleanEx()
nameEx("getAnalysis")
### * getAnalysis

flush(stderr()); flush(stdout())

### Name: getAnalysis
### Title: Start analysis after defined Twitter API information
### Aliases: getAnalysis

### ** Examples

## Not run: 
##D clearPrevious()
##D getCloudSentiment()
##D getBarSentiment()
## End(Not run)



cleanEx()
nameEx("getTweet")
### * getTweet

flush(stderr()); flush(stdout())

### Name: getTweet
### Title: Get Tweet
### Aliases: getTweet

### ** Examples

## Not run: 
##D fetchParams <- list(headers = headers,params = params,url = APIinfo$url)
##D getTweet(fetchParams)
## End(Not run)



cleanEx()
nameEx("setAccount")
### * setAccount

flush(stderr()); flush(stdout())

### Name: setAccount
### Title: Set Twitter Developer Account Api Information
### Aliases: setAccount

### ** Examples

params <- list(BEARER_TOKEN = "DSEFS55SSS",query = "binance")
setAccount(params)



cleanEx()
nameEx("writeToCSV")
### * writeToCSV

flush(stderr()); flush(stdout())

### Name: writeToCSV
### Title: Create CSV
### Aliases: writeToCSV

### ** Examples

## Not run: 
##D writeToCSV()
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
