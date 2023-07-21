pkgname <- "sentimentr"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('sentimentr')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("as_key")
### * as_key

flush(stderr()); flush(stdout())

### Name: as_key
### Title: Create/Manipulate Hash Keys
### Aliases: as_key update_key update_polarity_table
###   update_valence_shifter_table is_key
### Keywords: hash key lookup

### ** Examples

key <- data.frame(
    words = sample(letters),
    polarity = rnorm(26),
    stringsAsFactors = FALSE
)

(mykey <- as_key(key))

## Looking up values
mykey[c("a", "k")][[2]]

## Drop terms from key
update_key(mykey, drop = c("f", "h"))

## Add terms to key
update_key(mykey, x = data.frame(x = c("dog", "cat"), y = c(1, -1)))

## Add terms & drop to/from a key
update_key(mykey, drop = c("f", "h"), x = data.frame(x = c("dog", "cat"), y = c(1, -1)))

## Explicity key type (wrapper for `update_key` for sentiment table.
## See `update_valence_shifter_table` a corresponding valence shifter updater.
library(lexicon)
updated_hash_sentiment <- sentimentr:::update_polarity_table(lexicon::hash_sentiment_huliu,
    x = data.frame(
        words = c('frickin', 'hairy'),
        polarity = c(-1, -1),
        stringsAsFactors = FALSE
    )
)

## Checking if you have a key
is_key(mykey)
is_key(key)
is_key(mtcars)
is_key(update_key(mykey, drop = c("f", "h")))

## Using syuzhet's sentiment lexicons
## Not run: 
##D library(syuzhet)
##D (bing_key <- as_key(syuzhet:::bing))
##D as_key(syuzhet:::afinn)
##D as_key(syuzhet:::syuzhet_dict)
##D 
##D sam <- gsub("Sam-I-am", "Sam I am", sam_i_am)
##D sentiment(sam, , polarity_dt = bing_key)
##D 
##D ## The nrc dictionary in syuzhet requires a bit of data wrangling before it 
##D ## is in the correct shape to convert to a key.  
##D 
##D library(syuzhet)
##D library(tidyverse)
##D 
##D nrc_key <- syuzhet:::nrc %>% 
##D     dplyr::filter(
##D         sentiment %in% c('positive', 'negative'),
##D         lang == 'english'
##D     ) %>%
##D     dplyr::select(-lang) %>% 
##D     mutate(value = ifelse(sentiment == 'negative', value * -1, value)) %>%
##D     dplyr::group_by(word) %>%
##D     dplyr::summarize(y = mean(value)) %>%
##D     sentimentr::as_key()
##D     
##D sentiment(sam, polarity_dt = nrc_key)
##D 
##D ## The lexicon package contains a preformatted nrc sentiment hash table that 
##D ## can be used instead.
##D sentiment(sam, polarity_dt = lexicon::hash_sentiment_nrc)
## End(Not run)

## Using 2 vectors of words
## Not run: 
##D install.packages("tm.lexicon.GeneralInquirer", repos="http://datacube.wu.ac.at", type="source")
##D require("tm.lexicon.GeneralInquirer")
##D 
##D positive <- terms_in_General_Inquirer_categories("Positiv")
##D negative <- terms_in_General_Inquirer_categories("Negativ")
##D 
##D geninq <- data.frame(
##D     x = c(positive, negative),
##D     y = c(rep(1, length(positive)), rep(-1, length(negative))),
##D     stringsAsFactors = FALSE
##D ) %>%
##D     as_key()
##D 
##D geninq_pol <- with(presidential_debates_2012,
##D     sentiment_by(dialogue,
##D     person,
##D     polarity_dt = geninq
##D ))
##D 
##D geninq_pol %>% plot()
## End(Not run)



cleanEx()
nameEx("average_downweighted_zero")
### * average_downweighted_zero

flush(stderr()); flush(stdout())

### Name: average_downweighted_zero
### Title: Downweighted Zeros Averaging
### Aliases: average_downweighted_zero average_weighted_mixed_sentiment
###   average_mean

### ** Examples

x <- c(1, 2, 0, 0, 0, -1)
mean(x)
average_downweighted_zero(x)
average_downweighted_zero(c(NA, x))
mean(c(0, 0, 0, x))
average_downweighted_zero(c(0, 0, 0, x))



cleanEx()
nameEx("combine_data")
### * combine_data

flush(stderr()); flush(stdout())

### Name: combine_data
### Title: Combine 'sentimentr"s Sentiment Data Sets
### Aliases: combine_data

### ** Examples

combine_data()
combine_data(c("kotzias_reviews_amazon_cells", "kotzias_reviews_imdb", 
    "kotzias_reviews_yelp"))



cleanEx()
nameEx("emotion")
### * emotion

flush(stderr()); flush(stdout())

### Name: emotion
### Title: Compute Emotion Rate
### Aliases: emotion

### ** Examples

mytext <- c(
    "I am not afraid of you",
    NA,
    "",
    "I love it [not really]", 
    "I'm not angry with you", 
    "I hate it when you lie to me.  It's so humiliating",
    "I'm not happpy anymore.  It's time to end it",
    "She's a darn good friend to me",
    "I went to the terrible store",
    "There is hate and love in each of us",
    "I'm no longer angry!  I'm really experiencing peace but not true joy.",
    
    paste("Out of the night that covers me, Black as the Pit from pole to", 
      "pole, I thank whatever gods may be For my unconquerable soul."
     ),
    paste("In the fell clutch of circumstance I have not winced nor cried",
        "aloud. Under the bludgeonings of chance My head is bloody, but unbowed."
    ),
    paste("Beyond this place of wrath and tears Looms but the Horror of the", 
        "shade, And yet the menace of the years Finds, and shall find, me unafraid."
    ),
    paste("It matters not how strait the gate, How charged with punishments", 
        "the scroll, I am the master of my fate: I am the captain of my soul."
    )    
    
)

## works on a character vector but not the preferred method avoiding the 
## repeated cost of doing sentence boundary disambiguation every time 
## `emotion` is run
emotion(mytext)

## preferred method avoiding paying the cost 
split_text <- get_sentences(mytext)
(emo <- emotion(split_text))
emotion(split_text, drop.unused.emotions = TRUE)

## Not run: 
##D plot(emo)
##D plot(emo, drop.unused.emotions = FALSE)
##D plot(emo, facet = FALSE)
##D plot(emo, facet = 'negated')
##D 
##D library(data.table)
##D fear <- emo[
##D     emotion_type == 'fear', ][, 
##D     text := unlist(split_text)][]
##D     
##D fear[emotion > 0,]
##D 
##D brady <- get_sentences(crowdflower_deflategate)
##D brady_emotion <- emotion(brady)
##D brady_emotion
## End(Not run)



cleanEx()
nameEx("emotion_by")
### * emotion_by

flush(stderr()); flush(stdout())

### Name: emotion_by
### Title: Emotion Rate By Groups
### Aliases: emotion_by
### Keywords: emotion

### ** Examples

## Not run: 
##D mytext <- c(
##D     "I am not afraid of you",
##D     NA,
##D     "",
##D     "I love it [not really]", 
##D     "I'm not angry with you", 
##D     "I hate it when you lie to me.  It's so humiliating",
##D     "I'm not happpy anymore.  It's time to end it",
##D     "She's a darn good friend to me",
##D     "I went to the terrible store",
##D     "There is hate and love in each of us",
##D     "I'm no longer angry!  I'm really experiencing peace but not true joy.",
##D     
##D     paste("Out of the night that covers me, Black as the Pit from pole to", 
##D       "pole, I thank whatever gods may be For my unconquerable soul.",
##D       "In the fell clutch of circumstance I have not winced nor cried",
##D       "aloud. Under the bludgeonings of chance My head is bloody, but unbowed.",
##D       "Beyond this place of wrath and tears Looms but the Horror of the", 
##D       "shade, And yet the menace of the years Finds, and shall find, me unafraid.",
##D       "It matters not how strait the gate, How charged with punishments", 
##D       "the scroll, I am the master of my fate: I am the captain of my soul."
##D     )    
##D     
##D )
##D 
##D ## works on a character vector but not the preferred method avoiding the 
##D ## repeated cost of doing sentence boundary disambiguation every time 
##D ## `emotion` is run
##D emotion(mytext)
##D emotion_by(mytext)
##D 
##D ## preferred method avoiding paying the cost 
##D mytext <- get_sentences(mytext)
##D 
##D emotion_by(mytext)
##D get_sentences(emotion_by(mytext))
##D 
##D (myemotion <- emotion_by(mytext))
##D stats::setNames(get_sentences(emotion_by(mytext)),
##D     round(myemotion[["ave_emotion"]], 3))
##D 
##D pres <- get_sentences(presidential_debates_2012)
##D pres_emo_sent <- emotion_by(pres)
##D 
##D ## method 1
##D pres_emo_per_time <- presidential_debates_2012 %>%
##D     get_sentences() %>%
##D     emotion_by(by = c('person', 'time'))
##D     
##D pres_emo_per_time
##D 
##D ## method 2
##D library(magrittr)
##D presidential_debates_2012 %>%
##D     get_sentences() %$%
##D     emotion_by(., by = c('person', 'time'))
##D 
##D ## method 3
##D presidential_debates_2012 %>%
##D     get_sentences() %$%
##D     emotion_by(dialogue, by = list(person, time))
##D 
##D ## method 4
##D presidential_debates_2012 %>%
##D     get_sentences() %>%
##D     with(emotion_by(dialogue, by = list(person, time)))
##D 
##D plot(pres_emo_sent)
##D plot(pres_emo_per_time)
## End(Not run)



cleanEx()
nameEx("extract_emotion_terms")
### * extract_emotion_terms

flush(stderr()); flush(stdout())

### Name: extract_emotion_terms
### Title: Extract Emotion Words
### Aliases: extract_emotion_terms

### ** Examples

## Not run: 
##D mytext <- c(
##D     "I am not afraid of you",
##D     NA,
##D     "",
##D     "I love it [not really]", 
##D     "I'm not angry with you", 
##D     "I hate it when you lie to me.  It's so humiliating",
##D     "I'm not happpy anymore.  It's time to end it",
##D     "She's a darn good friend to me",
##D     "I went to the terrible store",
##D     "There is hate and love in each of us",
##D     "I'm no longer angry!  I'm really experiencing peace but not true joy.",
##D     
##D     paste("Out of the night that covers me, Black as the Pit from pole to", 
##D       "pole, I thank whatever gods may be For my unconquerable soul.",
##D       "In the fell clutch of circumstance I have not winced nor cried",
##D       "aloud. Under the bludgeonings of chance My head is bloody, but unbowed.",
##D       "Beyond this place of wrath and tears Looms but the Horror of the", 
##D       "shade, And yet the menace of the years Finds, and shall find, me unafraid.",
##D       "It matters not how strait the gate, How charged with punishments", 
##D       "the scroll, I am the master of my fate: I am the captain of my soul."
##D     )    
##D     
##D )
##D 
##D mytext2 <- get_sentences(mytext)
##D emotion(mytext2)
##D 
##D emo_words <- extract_emotion_terms(mytext2)
##D emo_words
##D emo_words$sentence
##D emo_words[, c('anger', 'anticipation', 'disgust', 'fear', 'joy', 'sadness', 'surprise', 'trust')]
##D 
##D attributes(emo_words)$counts
##D attributes(emo_words)$elements
##D 
##D ## directly ona  character string (not recommended: use `get_sentences` first)
##D extract_emotion_terms(mytext)
##D 
##D brady <- get_sentences(crowdflower_deflategate)
##D brady_emo <- extract_emotion_terms(brady)
##D 
##D brady_emo
##D attributes(brady_emo)$counts
##D attributes(brady_emo)$elements
## End(Not run)



cleanEx()
nameEx("extract_profanity_terms")
### * extract_profanity_terms

flush(stderr()); flush(stdout())

### Name: extract_profanity_terms
### Title: Extract Profanity Words
### Aliases: extract_profanity_terms

### ** Examples

## Not run: 
##D bw <- sample(lexicon::profanity_alvarez, 4)
##D mytext <- c(
##D    sprintf('do you %s like this %s?  It is %s. But I hate really bad dogs', bw[1], bw[2], bw[3]),
##D    'I am the best friend.',
##D    NA,
##D    sprintf('I %s hate this %s', bw[3], bw[4]),
##D    "Do you really like it?  I'm not happy"
##D )
##D 
##D 
##D x <- get_sentences(mytext)
##D profanity(x)
##D 
##D prof_words <- extract_profanity_terms(x)
##D prof_words
##D prof_words$sentence
##D prof_words$neutral
##D prof_words$profanity
##D data.table::as.data.table(prof_words)
##D 
##D attributes(extract_profanity_terms(x))$counts
##D attributes(extract_profanity_terms(x))$elements
##D 
##D 
##D brady <- get_sentences(crowdflower_deflategate)
##D brady_swears <- extract_profanity_terms(brady)
##D 
##D attributes(extract_profanity_terms(brady))$counts
##D attributes(extract_profanity_terms(brady))$elements
## End(Not run)



cleanEx()
nameEx("extract_sentiment_terms")
### * extract_sentiment_terms

flush(stderr()); flush(stdout())

### Name: extract_sentiment_terms
### Title: Extract Sentiment Words
### Aliases: extract_sentiment_terms

### ** Examples

library(data.table)
set.seed(10)
x <- get_sentences(sample(hu_liu_cannon_reviews[[2]], 1000, TRUE))
sentiment(x)

pol_words <- extract_sentiment_terms(x)
pol_words
pol_words$sentence
pol_words$neutral
data.table::as.data.table(pol_words)

attributes(extract_sentiment_terms(x))$counts
attributes(extract_sentiment_terms(x))$elements

## Not run: 
##D library(wordcloud)
##D library(data.table)
##D 
##D set.seed(10)
##D x <- get_sentences(sample(hu_liu_cannon_reviews[[2]], 1000, TRUE))
##D sentiment_words <- extract_sentiment_terms(x)
##D 
##D sentiment_counts <- attributes(sentiment_words)$counts
##D sentiment_counts[polarity > 0,]
##D 
##D par(mfrow = c(1, 3), mar = c(0, 0, 0, 0))
##D ## Positive Words
##D with(
##D     sentiment_counts[polarity > 0,],
##D     wordcloud(words = words, freq = n, min.freq = 1,
##D           max.words = 200, random.order = FALSE, rot.per = 0.35,
##D           colors = brewer.pal(8, "Dark2"), scale = c(4.5, .75)
##D     )
##D )
##D mtext("Positive Words", side = 3, padj = 5)
##D 
##D ## Negative Words
##D with(
##D     sentiment_counts[polarity < 0,],
##D     wordcloud(words = words, freq = n, min.freq = 1,
##D           max.words = 200, random.order = FALSE, rot.per = 0.35,
##D           colors = brewer.pal(8, "Dark2"), scale = c(4.5, 1)
##D     )
##D )
##D mtext("Negative Words", side = 3, padj = 5)
##D 
##D sentiment_counts[, 
##D     color := ifelse(polarity > 0, 'red', 
##D         ifelse(polarity < 0, 'blue', 'gray70')
##D     )]
##D 
##D ## Positive & Negative Together
##D with(
##D     sentiment_counts[polarity != 0,],
##D     wordcloud(words = words, freq = n, min.freq = 1,
##D           max.words = 200, random.order = FALSE, rot.per = 0.35,
##D           colors = color, ordered.colors = TRUE, scale = c(5, .75)
##D     )
##D )
##D mtext("Positive (red) & Negative (blue) Words", side = 3, padj = 5)
## End(Not run)



cleanEx()
nameEx("general_rescale")
### * general_rescale

flush(stderr()); flush(stdout())

### Name: general_rescale
### Title: Rescale a Numeric Vector
### Aliases: general_rescale

### ** Examples


general_rescale(c(1, 0, -1))
general_rescale(c(1, 0, -1, 1.4, -2))
general_rescale(c(1, 0, -1, 1.4, -2), lower = 0, upper = 1)
general_rescale(c(NA, -4:3))
general_rescale(c(NA, -4:3), keep.zero = FALSE)
general_rescale(c(NA, -4:3), keep.zero = FALSE, lower = 0, upper = 100)

## mute extreme values
set.seed(10)
x <- sort(c(NA, -100, -10, 0, rnorm(10, 0, .1), 10, 100), na.last = FALSE)
general_rescale(x)
general_rescale(x, mute = 5)
general_rescale(x, mute = 10)
general_rescale(x, mute = 100)



cleanEx()
nameEx("get_sentences")
### * get_sentences

flush(stderr()); flush(stdout())

### Name: get_sentences
### Title: Get Sentences
### Aliases: get_sentences

### ** Examples

dat <- data.frame(
    w = c('Person 1', 'Person 2'),
    x = c(paste0(
        "Mr. Brown comes! He says hello. i give him coffee.  i will ",
        "go at 5 p. m. eastern time.  Or somewhere in between!go there"
    ), "One more thought for the road! I am going now.  Good day."),
    y = state.name[c(32, 38)], 
    z = c(.456, .124),
    stringsAsFactors = FALSE
)
get_sentences(dat$x)
get_sentences(dat)



cleanEx()
nameEx("highlight")
### * highlight

flush(stderr()); flush(stdout())

### Name: highlight
### Title: Polarity Text Highlighting
### Aliases: highlight

### ** Examples

## Not run: 
##D library(data.table)
##D dat <- presidential_debates_2012
##D setDT(dat)
##D 
##D dat[, gr:={gr= paste(person, time); cumsum(c(TRUE, gr[-1]!= gr[-.N]))}]
##D dat <- dat[, list(person=person[1L], time=time[1L], dialogue=paste(dialogue,
##D     collapse = ' ')), by = gr][,gr:= NULL][, 
##D     dialogue_split := get_sentences(dialogue)][]
##D 
##D (sent_dat <- with(dat, sentiment_by(dialogue_split, list(person, time))))
##D 
##D highlight(sent_dat)
##D 
##D ## tidy approach
##D library(dplyr)
##D library(magrittr)
##D 
##D hu_liu_cannon_reviews %>%
##D     filter(review_id %in% sample(unique(review_id), 3)) %>%
##D     mutate(review = get_sentences(text)) %$%
##D     sentiment_by(review, review_id) %>%
##D     highlight()
## End(Not run)



cleanEx()
nameEx("profanity")
### * profanity

flush(stderr()); flush(stdout())

### Name: profanity
### Title: Compute Profanity Rate
### Aliases: profanity

### ** Examples

## Not run: 
##D bw <- sample(unique(tolower(lexicon::profanity_alvarez)), 4)
##D mytext <- c(
##D    sprintf('do you like this %s?  It is %s. But I hate really bad dogs', bw[1], bw[2]),
##D    'I am the best friend.',
##D    NA,
##D    sprintf('I %s hate this %s', bw[3], bw[4]),
##D    "Do you really like it?  I'm not happy"
##D )
##D 
##D ## works on a character vector but not the preferred method avoiding the 
##D ## repeated cost of doing sentence boundary disambiguation every time 
##D ## `profanity` is run
##D profanity(mytext)
##D 
##D ## preferred method avoiding paying the cost 
##D mytext2 <- get_sentences(mytext)
##D profanity(mytext2)
##D 
##D plot(profanity(mytext2))
##D 
##D brady <- get_sentences(crowdflower_deflategate)
##D brady_swears <- profanity(brady)
##D brady_swears
##D 
##D ## Distribution of profanity proportion for all comments
##D hist(brady_swears$profanity)
##D sum(brady_swears$profanity > 0)
##D 
##D ## Distribution of proportions for those profane comments
##D hist(brady_swears$profanity[brady_swears$profanity > 0])
##D 
##D combo <- combine_data()
##D combo_sentences <- get_sentences(crowdflower_deflategate)
##D racist <- profanity(combo_sentences, profanity_list = lexicon::profanity_racist)
##D combo_sentences[racist$profanity > 0, ]$text
##D extract_profanity_terms(
##D     combo_sentences[racist$profanity > 0, ]$text, 
##D     profanity_list = lexicon::profanity_racist
##D )
##D 
##D ## Remove jerry, que, and illegal from the list
##D library(textclean)
##D 
##D racist2 <- profanity(
##D     combo_sentences, 
##D     profanity_list = textclean::drop_element_fixed(
##D         lexicon::profanity_racist, 
##D         c('jerry', 'illegal', 'que')
##D     )
##D )
##D combo_sentences[racist2$profanity > 0, ]$text
## End(Not run)



cleanEx()
nameEx("profanity_by")
### * profanity_by

flush(stderr()); flush(stdout())

### Name: profanity_by
### Title: Profanity Rate By Groups
### Aliases: profanity_by

### ** Examples

## Not run: 
##D bw <- sample(lexicon::profanity_alvarez, 4)
##D mytext <- c(
##D    sprintf('do you like this %s?  It is %s. But I hate really bad dogs', bw[1], bw[2]),
##D    'I am the best friend.',
##D    NA,
##D    sprintf('I %s hate this %s', bw[3], bw[4]),
##D    "Do you really like it?  I'm not happy"
##D )
##D 
##D ## works on a character vector but not the preferred method avoiding the 
##D ## repeated cost of doing sentence boundary disambiguation every time 
##D ## `profanity` is run
##D profanity(mytext)
##D profanity_by(mytext)
##D 
##D ## preferred method avoiding paying the cost 
##D mytext <- get_sentences(mytext)
##D 
##D profanity_by(mytext)
##D get_sentences(profanity_by(mytext))
##D 
##D (myprofanity <- profanity_by(mytext))
##D stats::setNames(get_sentences(profanity_by(mytext)),
##D     round(myprofanity[["ave_profanity"]], 3))
##D 
##D brady <- get_sentences(crowdflower_deflategate)
##D library(data.table)
##D bp <- profanity_by(brady)
##D crowdflower_deflategate[bp[ave_profanity > 0,]$element_id, ]
##D 
##D vulgars <- bp[["ave_profanity"]] > 0
##D stats::setNames(get_sentences(bp)[vulgars],
##D     round(bp[["ave_profanity"]][vulgars], 3))
##D     
##D bt <- data.table(crowdflower_deflategate)[, 
##D     source := ifelse(grepl('^RT', text), 'retweet', 'OP')][,
##D     belichick := grepl('\\bb[A-Za-z]+l[A-Za-z]*ch', text, ignore.case = TRUE)][]
##D 
##D prof_bel <- with(bt, profanity_by(text, by = list(source, belichick)))
##D 
##D plot(prof_bel)
## End(Not run)



cleanEx()
nameEx("sentiment")
### * sentiment

flush(stderr()); flush(stdout())

### Name: sentiment
### Title: Polarity Score (Sentiment Analysis)
### Aliases: sentiment

### ** Examples

mytext <- c(
   'do you like it?  But I hate really bad dogs',
   'I am the best friend.',
   "Do you really like it?  I'm not a fan",
   "It's like a tree."
)

## works on a character vector but not the preferred method avoiding the 
## repeated cost of doing sentence boundary disambiguation every time 
## `sentiment` is run.  For small batches the loss is minimal.
## Not run: 
##D sentiment(mytext)
## End(Not run)

## preferred method avoiding paying the cost 
mytext <- get_sentences(mytext)
sentiment(mytext)
sentiment(mytext, question.weight = 0)

sam_dat <- get_sentences(gsub("Sam-I-am", "Sam I am", sam_i_am))
(sam <- sentiment(sam_dat))
plot(sam)
plot(sam, scale_range = TRUE, low_pass_size = 5)
plot(sam, scale_range = TRUE, low_pass_size = 10)
    
## Not run: 
##D ## legacy transform functions from suuzhet
##D plot(sam, transformation.function = syuzhet::get_transformed_values)
##D plot(sam, transformation.function = syuzhet::get_transformed_values,  
##D     scale_range = TRUE, low_pass_size = 5)
## End(Not run)

y <- get_sentences(
    "He was not the sort of man that one would describe as especially handsome."
)
sentiment(y)
sentiment(y, n.before=Inf)

## Not run: 
##D ## Categorize the polarity (tidyverse vs. data.table):
##D library(dplyr)
##D sentiment(mytext) %>%
##D as_tibble() %>%
##D     mutate(category = case_when(
##D         sentiment < 0 ~ 'Negative', 
##D         sentiment == 0 ~ 'Neutral', 
##D         sentiment > 0 ~ 'Positive'
##D     ) %>%
##D     factor(levels = c('Negative', 'Neutral', 'Positive'))
##D )
##D 
##D library(data.table)
##D dt <- sentiment(mytext)[, category := factor(fcase(
##D         sentiment < 0, 'Negative', 
##D         sentiment == 0, 'Neutral', 
##D         sentiment > 0, 'Positive'
##D     ), levels = c('Negative', 'Neutral', 'Positive'))][]
##D dt
## End(Not run)

dat <- data.frame(
    w = c('Person 1', 'Person 2'),
    x = c(paste0(
        "Mr. Brown is nasty! He says hello. i give him rage.  i will ",
        "go at 5 p. m. eastern time.  Angry thought in between!go there"
    ), "One more thought for the road! I am going now.  Good day and good riddance."),
    y = state.name[c(32, 38)], 
    z = c(.456, .124),
    stringsAsFactors = FALSE
)
sentiment(get_sentences(dat$x))
sentiment(get_sentences(dat))

## Not run: 
##D ## tidy approach
##D library(dplyr)
##D library(magrittr)
##D 
##D hu_liu_cannon_reviews %>%
##D    mutate(review_split = get_sentences(text)) %$%
##D    sentiment(review_split)
## End(Not run)

## Emojis
## Not run: 
##D ## Load R twitter data
##D x <- read.delim(system.file("docs/r_tweets.txt", package = "textclean"), 
##D     stringsAsFactors = FALSE)
##D 
##D x
##D 
##D library(dplyr); library(magrittr)
##D 
##D ## There are 2 approaches
##D ## Approach 1: Replace with words
##D x %>%
##D     mutate(Tweet = replace_emoji(Tweet)) %$%
##D     sentiment(Tweet)
##D 
##D ## Approach 2: Replace with identifier token
##D combined_emoji <- update_polarity_table(
##D     lexicon::hash_sentiment_jockers_rinker,
##D     x = lexicon::hash_sentiment_emojis
##D )
##D 
##D x %>%
##D     mutate(Tweet = replace_emoji_identifier(Tweet)) %$%
##D     sentiment(Tweet, polarity_dt = combined_emoji)
##D     
##D ## Use With Non-ASCII
##D ## Warning: sentimentr has not been tested with languages other than English.
##D ## The example below is how one might use sentimentr if you believe the 
##D ## language you are working with are similar enough in grammar to for
##D ## sentimentr to be viable (likely Germanic languages)
##D ## english_sents <- c(
##D ##     "I hate bad people.",
##D ##     "I like yummy cookie.",
##D ##     "I don't love you anymore; sorry."
##D ## )
##D 
##D ## Roughly equivalent to the above English
##D danish_sents <- stringi::stri_unescape_unicode(c(
##D     "Jeg hader d\\u00e5rlige mennesker.", 
##D     "Jeg kan godt lide l\\u00e6kker is.", 
##D     "Jeg elsker dig ikke mere; undskyld."
##D ))
##D 
##D danish_sents
##D 
##D ## Polarity terms
##D polterms <- stringi::stri_unescape_unicode(
##D     c('hader', 'd\\u00e5rlige', 'undskyld', 'l\\u00e6kker', 'kan godt', 'elsker')
##D )
##D 
##D ## Make polarity_dt
##D danish_polarity <- as_key(data.frame(
##D     x = stringi::stri_unescape_unicode(polterms),
##D     y = c(-1, -1, -1, 1, 1, 1)
##D ))
##D 
##D ## Make valence_shifters_dt
##D danish_valence_shifters <- as_key(
##D     data.frame(x='ikke', y="1"), 
##D     sentiment = FALSE, 
##D     comparison = NULL
##D )
##D 
##D sentiment(
##D     danish_sents, 
##D     polarity_dt = danish_polarity, 
##D     valence_shifters_dt = danish_valence_shifters, 
##D     retention_regex = "\\d:\\d|\\d\\s|[^\\p{L}',;: ]"
##D )
##D 
##D ## A way to test if you need [:alpha:] vs \p{L} in `retention_regex`:
##D 
##D ## 1. Does it wreck some of the non-ascii characters by default?
##D sentimentr:::make_sentence_df2(danish_sents) 
##D 
##D ## 2.Does this?
##D sentimentr:::make_sentence_df2(danish_sents, "\\d:\\d|\\d\\s|[^\\p{L}',;: ]")
##D 
##D ## If you answer yes to #1 but no to #2 you likely want \p{L}
## End(Not run)



cleanEx()
nameEx("sentiment_attributes")
### * sentiment_attributes

flush(stderr()); flush(stdout())

### Name: sentiment_attributes
### Title: Extract Sentiment Attributes from Text
### Aliases: sentiment_attributes

### ** Examples

## Not run: 
##D sentiment_attributes(presidential_debates_2012$dialogue)
## End(Not run)



cleanEx()
nameEx("sentiment_by")
### * sentiment_by

flush(stderr()); flush(stdout())

### Name: sentiment_by
### Title: Polarity Score (Sentiment Analysis) By Groups
### Aliases: sentiment_by

### ** Examples

mytext <- c(
   'do you like it?  It is red. But I hate really bad dogs',
   'I am the best friend.',
   "Do you really like it?  I'm not happy"
)

## works on a character vector but not the preferred method avoiding the 
## repeated cost of doing sentence boundary disambiguation every time 
## `sentiment` is run
## Not run: 
##D sentiment(mytext)
##D sentiment_by(mytext)
## End(Not run)

## preferred method avoiding paying the cost 
mytext <- get_sentences(mytext)

sentiment_by(mytext)
sentiment_by(mytext, averaging.function = average_mean)
sentiment_by(mytext, averaging.function = average_weighted_mixed_sentiment)
get_sentences(sentiment_by(mytext))

(mysentiment <- sentiment_by(mytext, question.weight = 0))
stats::setNames(get_sentences(sentiment_by(mytext, question.weight = 0)),
    round(mysentiment[["ave_sentiment"]], 3))

pres_dat <- get_sentences(presidential_debates_2012)

## Not run: 
##D ## less optimized way
##D with(presidential_debates_2012, sentiment_by(dialogue, person))
## End(Not run)

## Not run: 
##D sentiment_by(pres_dat, 'person')
##D 
##D (out <- sentiment_by(pres_dat, c('person', 'time')))
##D plot(out)
##D plot(uncombine(out))
##D 
##D sentiment_by(out, presidential_debates_2012$person)
##D with(presidential_debates_2012, sentiment_by(out, time))
##D 
##D highlight(with(presidential_debates_2012, sentiment_by(out, list(person, time))))
## End(Not run)

## Not run: 
##D ## tidy approach
##D library(dplyr)
##D library(magrittr)
##D 
##D hu_liu_cannon_reviews %>%
##D    mutate(review_split = get_sentences(text)) %$%
##D    sentiment_by(review_split)
## End(Not run)



cleanEx()
nameEx("sentimentr_data")
### * sentimentr_data

flush(stderr()); flush(stdout())

### Name: available_data
### Title: Get Available Data
### Aliases: available_data sentimentr_data

### ** Examples

sentimentr_data()
available_data() ## generic version for export
available_data(package = 'datasets')
sentimentr_data('^hu')
sentimentr_data('^(hu|kot)')
combine_data(sentimentr_data('^(hu|kot)')[[1]])

## Not run: 
##D if (!require("pacman")) install.packages("pacman")
##D pacman::p_load(sentimentr, tidyverse, magrittr)
##D 
##D sentiment_data <- sentimentr_data('^hu') %>%
##D     pull(Data) %>%
##D     combine_data() %>%
##D     mutate(id = seq_len(n())) %>%
##D     as_tibble()
##D     
##D sentiment_test <- sentiment_data %>%
##D     select(-sentiment) %>%
##D     get_sentences() %$%
##D     sentiment(., by = c('id'))
##D 
##D testing <- sentiment_data %>%
##D     left_join(sentiment_test, by = 'id') %>%
##D     as_tibble() %>%
##D     mutate(
##D         actual = sign(sentiment),
##D         predicted = sign(ave_sentiment)
##D     )
##D 
##D testing %$%
##D     ftable(predicted, actual)
## End(Not run)



cleanEx()
nameEx("uncombine")
### * uncombine

flush(stderr()); flush(stdout())

### Name: uncombine
### Title: Ungroup a 'sentiment_by' Object to the Sentence Level
### Aliases: uncombine

### ** Examples

mytext <- c(
   'do you like it?  But I hate really bad dogs',
   'I am the best friend.',
   "Do you really like it?  I'm not happy"
)

mytext <- get_sentences(mytext)
(x <- sentiment_by(mytext))
uncombine(x)

## Not run: 
##D (y <- with(
##D     presidential_debates_2012, 
##D     sentiment_by(
##D         text.var = get_sentences(dialogue), 
##D         by = list(person, time)
##D     )
##D ))
##D uncombine(y)
## End(Not run)



cleanEx()
nameEx("validate_sentiment")
### * validate_sentiment

flush(stderr()); flush(stdout())

### Name: validate_sentiment
### Title: Validate Sentiment Score Sign Against Known Results
### Aliases: validate_sentiment

### ** Examples

actual <- c(1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, 1,-1)
predicted <- c(1, 0, 1, -1, 1, 0, -1, -1, -1, -1, 0, 1,-1)
validate_sentiment(predicted, actual)

scores <- hu_liu_cannon_reviews$sentiment
mod <- sentiment_by(get_sentences(hu_liu_cannon_reviews$text))

validate_sentiment(mod$ave_sentiment, scores)
validate_sentiment(mod, scores)

x <- validate_sentiment(mod, scores)
attributes(x)$confusion_matrix
attributes(x)$class_confusion_matrices
attributes(x)$macro_stats

## Annie Swafford Example
swafford <- data.frame(
    text = c(
        "I haven't been sad in a long time.",
        "I am extremely happy today.",
        "It's a good day.",
        "But suddenly I'm only a little bit happy.",
        "Then I'm not happy at all.",
        "In fact, I am now the least happy person on the planet.",
        "There is no happiness left in me.",
        "Wait, it's returned!",
        "I don't feel so bad after all!"
    ), 
    actual = c(.8, 1, .8, -.1, -.5, -1, -1, .5, .6), 
    stringsAsFactors = FALSE
)

pred <- sentiment_by(swafford$text) 
validate_sentiment(
    pred,
    actual = swafford$actual
)



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
