#' Load Text from File
#' Load a file as a single text sting. 
#' @param path_to_file file path
#' @export
#' 
get_text_as_string <- function(path_to_file){
  text_of_file <- scan(file = path_to_file, what = "character")
  return(NLP::as.String(paste(text_of_file, collapse = " ")))
}

#' Sentence Tokenization
#' Parses a string into a vector of sentences
#' @param text_of_file A Text String
#' @return A Character Vector of Sentences
#' @export
#' 
get_sentences <- function(text_of_file){
  text_of_file <- NLP::as.String(text_of_file)
  sent_token_annotator <- openNLP::Maxent_Sent_Token_Annotator()
  sentence_bounds <- NLP::annotate(text_of_file, sent_token_annotator)
  text_of_file[sentence_bounds]
}

#' Get Sentiment Values for a String
#' 
#' Iterates over a vector of strings and returns sentiment values based on user supplied method
#' 
#' @param char_v A vector of strings for evaluation
#' @param method A string indicating which sentiment method to use. Options include "bing", "afinn", "nrc" and "stanford."  See references for more detail.
#' @details In this version there are four possible methods to choose, as follows: "bing", "afinn", "nrc" and "stanford." 
#' 
#' @references Bing Liu, Minqing Hu and Junsheng Cheng. "Opinion Observer: Analyzing and Comparing Opinions on the Web." Proceedings of the 14th International World Wide Web conference (WWW-2005), May 10-14, 2005, Chiba, Japan.  
#' 
#' @references Minqing Hu and Bing Liu. "Mining and Summarizing Customer Reviews." Proceedings of the ACM SIGKDD International Conference on Knowledge Discovery and Data Mining (KDD-2004), Aug 22-25, 2004, Seattle, Washington, USA.  See: http://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html#lexicon
#' 
#' @references Saif Mohammad and Peter Turney.  "Emotions Evoked by Common Words and Phrases: Using Mechanical Turk to Create an Emotion Lexicon." In Proceedings of the NAACL-HLT 2010 Workshop on Computational Approaches to Analysis and Generation of Emotion in Text, June 2010, LA, California.  See: http://saifmohammad.com/WebPages/lexicons.html
#' 
#' @references Finn Arup Nielsen. "A new ANEW: Evaluation of a word list for sentiment analysis in microblogs", Proceedings of the ESWC2011 Workshop on 'Making Sense of Microposts':Big things come in small packages 718 in CEUR Workshop Proceedings : 93-98. 2011 May. http://arxiv.org/abs/1103.2903. See: http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010
#' 
#' @references Manning, Christopher D., Surdeanu, Mihai, Bauer, John, Finkel, Jenny, Bethard, Steven J., and McClosky, David. 2014. The Stanford CoreNLP Natural Language Processing Toolkit. In Proceedings of 52nd Annual Meeting of the Association for Computational Linguistics: System Demonstrations, pp. 55-60.  See: http://nlp.stanford.edu/software/corenlp.shtml
#' 
#' @references Richard Socher, Alex Perelygin, Jean Wu, Jason Chuang, Christopher Manning, Andrew Ng and Christopher Potts.  "Recursive Deep Models for Semantic Compositionality Over a Sentiment Treebank Conference on Empirical Methods in Natural Language Processing" (EMNLP 2013).  See: http://nlp.stanford.edu/sentiment/
#' 
#' @param path_to_tagger local path to location of Stanford CoreNLP package
#' @return Return format is based on method.  When method is "bing," "afinn" or "stanford" the return value is a numeric vector of sentiment values, one value for each input sentence.  When the method is "nrc" the return is a data frame with the ten columns and a row for each input sentence.  The ten columns are as follows: "anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust", "negative", "positive."  For details see 
#' @export
#' 
get_sentiment <- function(char_v, method = "", path_to_tagger = NULL){
  if(method == "afinn" || method == "bing"){
    word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
    result <- unlist(lapply(word_l, get_sent_values, method))
  }
  else if(method == "nrc"){
    result <- get_nrc_sentiment(char_v)
    result <- (result$negative*-1) + result$positive
  } 
  else if(method == "stanford") {
    result <- get_stanford_sentiment(char_v, path_to_tagger)
  }
  else if(method == ""){
    stop("invalid method")
  } else {
    return(result)
  }
}

#' Assigns Sentiment Values to Words Based on preloaded dictionary
#'
#' @param char_v a string
#' @param method a string indicating which sentiment dictionary to use
#' @return a single numerical value (positive or negative)
#' based on the assessed sentiment in the string
#'
get_sent_values<-function(char_v, method = "bing"){
  if(method == "bing") {
    result <- sum(bing[which(bing$word %in% char_v), "value"])
  }
  else if(method == "afinn"){
    result <- sum(afinn[which(afinn$word %in% char_v), "value"])
  }
  else if(method == "nrc") {
    result <- get_nrc_sentiment(char_v)
  }
  return(result)
}

#' Get Emotions and Valence Values Using NRC Dictionary
#'
#' Calls the NRC sentiment dictionary to calculate
#' the presence of eight different emotions and their
#' corresponding valence in a text file
#' @export
#' @param char_v a character vector
#' @return a data frame where each row represents a sentence
#' from the original file.  The columns include one for each
#' emotion type was well as a positive or negative valence
#' @references Saif Mohammad and Peter Turney.  "Emotions Evoked by Common Words and Phrases: Using Mechanical Turk to Create an Emotion Lexicon." In Proceedings of the NAACL-HLT 2010 Workshop on Computational Approaches to Analysis and Generation of Emotion in Text, June 2010, LA, California.  See: http://saifmohammad.com/WebPages/lexicons.html
#'
get_nrc_sentiment<-function(char_v){
  word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
  nrc_data <- lapply(word_l, get_nrc_values)
  result_df <- as.data.frame(do.call(rbind, nrc_data), stringsAsFactors=F)
  # reorder the columns
  my_col_order <- c(
    "anger", 
    "anticipation", 
    "disgust", 
    "fear", 
    "joy", 
    "sadness", 
    "surprise", 
    "trust", 
    "negative", 
    "positive"
  )
  result_df[, my_col_order]
}

#' Summarize NRC values
#'
#' Access the NRC dictionary to compute emotion types and
#' valence for a set of words in the input vector
#' @param word_vector A character vector
#' @return a vector of values for the emotions and valence
#' detected in the input vector
#'
get_nrc_values <- function(word_vector){
  colSums(nrc[which(rownames(nrc) %in% word_vector), ])
}

#'  Fourier Transform and Reverse Transform Values
#'
#'  Converts input values into a standardized
#'  set of filtered and reverse transformed values for
#'  easy plotting and/or comparison.
#'  @param raw_values the raw sentiment values
#'  calculated for each sentence
#'  @param low_pass_size The number of components
#'  to retain in the low pass filtering. Default = 3
#'  @param x_reverse_len the number of values to return. Default = 100
#'  @param rescale_vals Logical determines whether or not to scale the values from -1 to +1.  Default = TRUE
#'  for the uniform y-axis
#'  @return The transformed values
#'  @export
#'  @examples
#'  s_v <- get_sentences("I begin this story with a neutral statement. 
#'  Basically this is a very silly test.")
#'  raw_values <- get_sentiment(s_v, method = "bing")
#'  get_transformed_values(raw_values)
#'  
get_transformed_values <- function(raw_values, low_pass_size = 3, x_reverse_len = 100, rescale_vals = TRUE){
  values_fft <- fft(raw_values)
  keepers <- values_fft[1:low_pass_size]
  padded_keepers <- c(keepers, rep(0, x_reverse_len - low_pass_size))
  inverse_values <- fft(padded_keepers, inverse=T)
  transformed_values <- Re(inverse_values)
  if(rescale_vals){
    return(rescale(transformed_values))
  } else {
    return(transformed_values)
  }
}

#' Get Percentage Means
#'
#'@param raw_values Raw sentiment values
#'@export
#'@return A vector of mean values from each chunk
#'
get_percentage_values <- function(raw_values){
  if(length(raw_values) < 100){
    chunk.max <- length(raw_values)
  } else {
    chunk.max <- length(raw_values)/100
  }
  x <- seq_along(raw_values)
  chunks <- split(raw_values, ceiling(x/chunk.max))
  unlist(lapply(chunks, mean))
}

#'  Get Sentiment from the Stanford Tagger
#'  Call the Stanford Sentiment tagger with a
#'  vector of strings.  The Stanford tagger automatically
#'  detects sentence boundaries and treats each sentence as a 
#'  distinct instance to measure. As a result, the vector 
#'  that gets returned will not be the same length as the
#'  input vector.
#'  @param text_vector A vector of strings
#'  @param path_to_stanford_tagger a local file path indicating where the coreNLP package is installed.
#'  
get_stanford_sentiment <- function(text_vector, path_to_stanford_tagger){
  cmd <- paste(
    'cd ', 
    path_to_stanford_tagger, 
    '; java -cp "*" -mx5g edu.stanford.nlp.sentiment.SentimentPipeline -stdin', 
    sep=""
  )
  results <- system(cmd, input = text_vector, intern = TRUE, ignore.stderr = TRUE)
  c_results <- gsub(".*Very positive", "1", results)
  c_results <- gsub(".*Very negative", "-1", c_results)
  c_results <- gsub(".*Positive", "0.5", c_results)
  c_results <- gsub(".*Neutral", "0", c_results)
  c_results <- gsub(".*Negative", "-0.5", c_results)
  return(as.numeric(c_results))
}

#'  Vector Value Rescaling
#'  Rescale Transformed values from -1 to 1
#'  @param x A vector of values
#'  
rescale <- function(x){
  2 * (x - min(x))/( max(x) - min(x)) -1
}


