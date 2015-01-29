## ------------------------------------------------------------------------
library(syuzhet)
my_example_text <- "I begin this story with a neutral statement.  
  Basically this is a very silly test.  
  You are testing the syuchet package using short, inane sentences.  
  I am actually very happy today. 
  I have finally finished writing this package.  
  Tomorrow I will be very sad. 
  I won't have anything left to do. 
  I might get angry and decide to do something horrible.  
  I might destroy the entire package and start from scratch.  
  Then again, I might find it satisfying to have completed my first R package. 
  Honestly this use of the Fourier transformation is really quite elegant.  
  You might even say it's beautiful!"
s_v <- get_sentences(my_example_text)

## ------------------------------------------------------------------------
class(s_v)
str(s_v)
head(s_v)

## ----, echo = FALSE------------------------------------------------------
path_to_a_text_file <- "~/Documents/Lectures-Workshops/Stanford.so.what/So.What/code/SentimentPredictionPackage/samples/POA.txt"
joyces_portrait <- get_text_as_string(path_to_a_text_file)
poa_v <- get_sentences(joyces_portrait)

## ----, eval = FALSE------------------------------------------------------
#  path_to_a_text_file <- "http://www.gutenberg.org/cache/epub/4217/pg4217.txt"
#  joyces_portrait <- get_text_as_string(path_to_a_text_file)
#  poa_v <- get_sentences(joyces_portrait)

## ------------------------------------------------------------------------
sentiment_vector <- get_sentiment(s_v, method="bing")

## ------------------------------------------------------------------------
sentiment_vector

## ------------------------------------------------------------------------
afinn_vector <- get_sentiment(s_v, method="afinn")
afinn_vector

nrc_vector <- get_sentiment(s_v, method="nrc")
nrc_vector

tagger_path <- "/Applications/stanford-corenlp-full-2014-01-04"
stanford_vector <- get_sentiment(s_v, method="stanford", tagger_path)
stanford_vector

## ------------------------------------------------------------------------
sum(sentiment_vector)

## ------------------------------------------------------------------------
mean(sentiment_vector)

## ------------------------------------------------------------------------
summary(sentiment_vector)

## ----, fig.width = 6-----------------------------------------------------
plot(
  sentiment_vector, 
  type="l", 
  main="Example Plot Trajectory", 
  xlab = "Narrative Time", 
  ylab= "Emotional Valence"
  )

## ----, fig.width = 6-----------------------------------------------------
poa_sent <- get_sentiment(poa_v, method="bing")
plot(
  poa_sent, 
  type="h", 
  main="Example Plot Trajectory", 
  xlab = "Narrative Time", 
  ylab= "Emotional Valence"
  )

## ----, echo=FALSE, fig.width = 6-----------------------------------------
plot(
  sentiment_vector, 
  type="l", 
  main="Example Plot Trajectory", 
  xlab = "Narrative Time", 
  ylab= "Emotional Valence"
  )

lines(
    get_transformed_values(
      sentiment_vector, 
      low_pass_size = 3, 
      x_reverse_len = 12, 
      rescale=TRUE
      ), 
  col="red", 
  lwd=2
  )

## ----, fig.width = 6-----------------------------------------------------
percent_vals <- get_percentage_values(poa_sent)
plot(
  percent_vals, 
  type="l", 
  main="Joyce's Portrait Using Percentage-Based Means", 
  xlab = "Narrative Time", 
  ylab= "Emotional Valence", 
  col="red"
  )

## ----, fig.width = 6-----------------------------------------------------
ft_values <- get_transformed_values(
      poa_sent, 
      low_pass_size = 3, 
      x_reverse_len = 100,
      rescale = TRUE
      )
plot(
  ft_values, 
  type ="h", 
  main ="Joyce's Portrait using Transformed Values", 
  xlab = "Narrative Time", 
  ylab = "Emotional Valence", 
  col = "red"
  )

## ------------------------------------------------------------------------
nrc_data <- get_nrc_sentiment(s_v)

## ------------------------------------------------------------------------
angry_items <- which(nrc_data$anger > 0)
s_v[angry_items]

## ------------------------------------------------------------------------
joy_items <- which(nrc_data$joy > 0)
s_v[joy_items]

## ----, results='asis'----------------------------------------------------
pander::pandoc.table(nrc_data[, 1:8])

## ----, results='asis'----------------------------------------------------
pander::pandoc.table(nrc_data[, 9:10])

## ------------------------------------------------------------------------
valence <- (nrc_data[, 9]*-1) + nrc_data[, 10]
valence

## ----, fig.width=6-------------------------------------------------------
barplot(
  sort(colSums(prop.table(nrc_data[, 1:8]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Emotions in Sample text", xlab="Percentage"
  )


