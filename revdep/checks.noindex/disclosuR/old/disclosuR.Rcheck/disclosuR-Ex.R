pkgname <- "disclosuR"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('disclosuR')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("conference_call_segmenter")
### * conference_call_segmenter

flush(stderr()); flush(stdout())

### Name: conference_call_segmenter
### Title: Earnings call segmenter
### Aliases: conference_call_segmenter

### ** Examples

earnings_calls_df <- conference_call_segmenter(file = system.file("inst",
"examples",
"earnings_calls", "earnings_example_01.pdf",
package = "disclosuR"));
earnings_calls_df_sentiment <- conference_call_segmenter(file = system.file("inst",
"examples",
"newswire", "earnings_example_01.pdf",
package = "disclosuR"),
sentiment = TRUE);




cleanEx()
nameEx("conference_call_segmenter_folder")
### * conference_call_segmenter_folder

flush(stderr()); flush(stdout())

### Name: conference_call_segmenter_folder
### Title: Earnings call segmenter (multiple files)
### Aliases: conference_call_segmenter_folder

### ** Examples

earnings_calls_df <- conference_call_segmenter_folder(
folder_path = system.file("inst",
"examples",
"earnings_calls",
package = "disclosuR"));
earnings_calls_df_sentiment <- conference_call_segmenter_folder(
folder_path = system.file("inst",
"examples",
"newswire",
sentiment = TRUE,
package = "disclosuR"));




cleanEx()
nameEx("impression_offsetting")
### * impression_offsetting

flush(stderr()); flush(stdout())

### Name: impression_offsetting
### Title: Impression offsetting
### Aliases: impression_offsetting

### ** Examples

## Not run: 
##D impression_offsetting(event_data, press_data)
## End(Not run)



cleanEx()
nameEx("newswire_segmenter")
### * newswire_segmenter

flush(stderr()); flush(stdout())

### Name: newswire_segmenter
### Title: Newswire segmenter
### Aliases: newswire_segmenter

### ** Examples

newswire_df <- newswire_segmenter(
file = system.file("inst",
"examples",
"newswire", "newswire_example_01.pdf",
package = "disclosuR"));
newswire_df_sentiment <- newswire_segmenter(
file = system.file("inst",
"examples",
"newswire", "newswire_example_01.pdf",
sentiment = TRUE,
package = "disclosuR"));



cleanEx()
nameEx("newswire_segmenter_folder")
### * newswire_segmenter_folder

flush(stderr()); flush(stdout())

### Name: newswire_segmenter_folder
### Title: Newswire segmenter (multiple files)
### Aliases: newswire_segmenter_folder

### ** Examples

newswire_df <- newswire_segmenter_folder(
folder_path = system.file("inst",
"examples",
"newswire",
package = "disclosuR"));
newswire_df_sentiment <- newswire_segmenter_folder(
folder_path = system.file("inst",
"examples",
"newswire",
package = "dislosuR"), sentiment = TRUE);




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
