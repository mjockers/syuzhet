#' Load Text from a File
#' @description
#' Loads a file as a single text sting. 
#' @param path_to_file file path
#' @export
#' @return A character vector of length 1 containing the text of the file in the path_to_file argument.
#' 
get_text_as_string <- function(path_to_file){
  text_of_file <- readLines(path_to_file)
  return(NLP::as.String(paste(text_of_file, collapse = " ")))
}

#' Word Tokenization
#' @description
#' Parses a string into a vector of word tokens
#' @param text_of_file A Text String
#' @return A Character Vector of Words
#' @export
#' 
get_tokens <- function(text_of_file, pattern = "\\W"){
  tokens <- unlist(strsplit(text_of_file, pattern))
  tolower(tokens[which(tokens != "")])
}

#' Sentence Tokenization
#' @description
#' Parses a string into a vector of sentences.
#' @param text_of_file A Text String
#' @param strip_quotes Logical. Default of TRUE results in 
#' removal of quote marks from text input prior to sentence 
#' parsing.
#' @return A Character Vector of Sentences
#' @export
#' 
get_sentences <- function(text_of_file, strip_quotes = TRUE){
  if (!is.character(text_of_file)) stop("Data must be a character vector.")
  text_of_file <- NLP::as.String(text_of_file)
  if(strip_quotes){
    text_of_file <- gsub("\"", "", text_of_file)
  }
  sent_token_annotator <- openNLP::Maxent_Sent_Token_Annotator()
  sentence_bounds <- NLP::annotate(text_of_file, sent_token_annotator)
  text_of_file[sentence_bounds]
}

#' Get Sentiment Values for a String
#' @description
#' Iterates over a vector of strings and returns sentiment values based on user supplied method.
#' 
#' @param char_v A vector of strings for evaluation.
#' @param method A string indicating which sentiment method to use. Options include "bing", "afinn", "nrc" and "stanford."  See references for more detail on methods.
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
#' @return Return value is a numeric vector of sentiment values, one value for each input sentence.
#' @export
#' 
get_sentiment <- function(char_v, method = c("afinn", "bing", "nrc", "stanford"), path_to_tagger = NULL){
  if (!is.character(char_v)) stop("Data must be a character vector.")
  method <- match.arg(method)
  if(method == "afinn" || method == "bing"){
    word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
    result <- unlist(lapply(word_l, get_sent_values, method))
  }
  else if(method == "nrc"){
    result <- get_nrc_sentiment(char_v)
    result <- (result$negative*-1) + result$positive
  } 
  else if(method == "stanford") {
    if(is.null(path_to_tagger)) stop("You must include a path to your installation of the coreNLP package.  See http://nlp.stanford.edu/software/corenlp.shtml")
    result <- get_stanford_sentiment(char_v, path_to_tagger)
  }
  else if(method == ""){
    stop("invalid method: be sure to use afinn, bing, nrc, or stanford")
  } else {
    return(result)
  }
}

#' Assigns Sentiment Values
#' @description
#' Assigns sentiment values to words based on preloaded dictionary
#'
#' @param char_v A string
#' @param method A string indicating which sentiment dictionary to use
#' @return A single numerical value (positive or negative)
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

#' Get Emotions and Valence from NRC Dictionary
#' @description
#' Calls the NRC sentiment dictionary to calculate
#' the presence of eight different emotions and their
#' corresponding valence in a text file.
#' @export
#' @param char_v A character vector
#' @return A data frame where each row represents a sentence
#' from the original file.  The columns include one for each
#' emotion type as well as a positive or negative valence.  The ten columns are as follows: "anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust", "negative", "positive." 
#' @references Saif Mohammad and Peter Turney.  "Emotions Evoked by Common Words and Phrases: Using Mechanical Turk to Create an Emotion Lexicon." In Proceedings of the NAACL-HLT 2010 Workshop on Computational Approaches to Analysis and Generation of Emotion in Text, June 2010, LA, California.  See: http://saifmohammad.com/WebPages/lexicons.html
#'
get_nrc_sentiment<-function(char_v){
  if (!is.character(char_v)) stop("Data must be a character vector.")
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

#' Summarize NRC Values
#' @description
#' Access the NRC dictionary to compute emotion types and
#' valence for a set of words in the input vector.
#' @param word_vector A character vector.
#' @return A vector of values for the emotions and valence
#' detected in the input vector.
#'
get_nrc_values <- function(word_vector){
  colSums(nrc[which(rownames(nrc) %in% word_vector), ])
}

#'  Fourier Transform and Reverse Transform Values
#' @description
#'  Converts input values into a standardized
#'  set of filtered and reverse transformed values for
#'  easy plotting and/or comparison.
#'  @param raw_values the raw sentiment values
#'  calculated for each sentence
#'  @param low_pass_size The number of components
#'  to retain in the low pass filtering. Default = 3
#'  @param x_reverse_len the number of values to return. Default = 100
#'  @param padding_factor the amount of zero values to pad raw_values with, as a factor of the size of raw_values. Default = 2.
#'  @param scale_range Logical determines whether or not to scale the values from -1 to +1.  Default = FALSE.  If set to TRUE, the lowest value in the vector will be set to -1 and the highest values set to +1 and all the values scaled accordingly in between.
#'  @param scale_vals Logical determines whether or not to normalize the values using the scale function  Default = FALSE.  If TRUE, values will be scaled by subtracting the means and scaled by dividing by their standard deviations.  See ?scale 
#'  @return The transformed values
#'  @export
#'  @examples
#'  s_v <- get_sentences("I begin this story with a neutral statement.
#'  Now I add a statement about how much I despise cats.  
#'  I am allergic to them. Basically this is a very silly test.")
#'  raw_values <- get_sentiment(s_v, method = "bing")
#'  get_transformed_values(raw_values)
#'  
get_transformed_values <- function(raw_values, low_pass_size = 3, x_reverse_len = 100, padding_factor = 2, scale_vals = FALSE, scale_range = FALSE){
  if(!is.numeric(raw_values)) stop("Input must be an numeric vector")
  if(low_pass_size > length(raw_values)) stop("low_pass_size must be less than or equal to the length of raw_values input vector")
  raw_values.len <- length(raw_values)
  padding.len <- raw_values.len * padding_factor
  # Add padding, then fft
  values_fft <- fft( c(raw_values, rep(0, padding.len)) )
  low_pass_size <- low_pass_size * (1 + padding_factor)
  keepers <- values_fft[1:low_pass_size]
  # Preserve frequency domain structure
  modified_spectrum <- c(keepers,
    rep(0, (x_reverse_len * (1+padding_factor)) - (2*low_pass_size) + 1),
    rev(Conj( keepers[2:(length(keepers))] )))
  inverse_values <- fft(modified_spectrum, inverse=T)
  # Strip padding
  inverse_values <- inverse_values[1:(x_reverse_len)]
  transformed_values <- Re(inverse_values)
  if(scale_vals & scale_range) stop("ERROR: scale_vals and scale_range cannot both be true.")
  if(scale_vals){
    return(scale(transformed_values))
  } else if(scale_range & !scale_vals) {
    return(rescale(transformed_values))
  } else {
    return(transformed_values)
  }
}

#' Chunk a Text and Get Means
#' @description
#' Chunks text into 100 Percentage based segments and calculates means.
#'
#'@param raw_values Raw sentiment values
#'@param bins The number of bins to split the input vector.
#' Default is 100 bins.
#'@export
#'@return A vector of mean values from each chunk
#'
get_percentage_values <- function(raw_values, bins = 100){
  if(!is.numeric(raw_values)) stop("Input must be a numeric vector")
  if(length(raw_values)/bins < 2){
    stop("Input vector needs to be twice as long as value number to make percentage based segmentation viable")
  }
  chunks <- split(raw_values, cut(1:length(raw_values),bins))
  means = sapply(chunks, mean)
  names(means) = 1:bins
  return(means)
}

#'  Get Sentiment from the Stanford Tagger
#' @description
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
#'  @description
#'  Rescale Transformed values from -1 to 1
#'  @param x A vector of values
#'  @export
rescale <- function(x){
  2 * (x - min(x))/( max(x) - min(x)) -1
}

#'  Bi-Directional x and y axis Rescaling
#'  @description
#'  Rescale Transformed values from -1 to 1 on the y-axis and scale from zero to 1 on the x-axis
#'  @param v A vector of values
#'  @export
rescale2 <- function(v){
  x <- 1:length(v)/length(v)
  y <- v/max(v)
  z <- 2 * (v - min(v))/(max(v) - min(v)) - 1
  return (list(x=x,y=y,z=z))
}

#'  Transformation to normalize narrative time axis
#'  @description
#'  Uses the Fourier transform and reverse transform with all frequency components retained and a arbitrary maximum length argument to return a time normalized vector of sentiment values.
#'  @param raw_values the raw sentiment values
#'  calculated for each sentence
#'  @param arbitrary_max should be set to a value that is something larger the length of the longest sentence vector in a corpus of books being compared.
#'  @export
transform_for_comparison <- function(raw_values, arbitrary_max){
  if(!is.numeric(raw_values)) stop("raw_values must be a numeric vector")
  if(!is.numeric(arbitrary_max)) stop("arbitrary_max must be a numeric vector")
  values_fft <- fft(raw_values)
  if(length(values_fft) >= arbitrary_max) stop("arbitrary_max must be greater than the length of raw_values")
  keepers <- values_fft[1:length(values_fft)]
  padded_keepers <- c(keepers, rep(0,  arbitrary_max - length(values_fft)))
  inverse_values <- fft(padded_keepers, inverse=T)
  Re(inverse_values)
}


#'  Fourier Transform and Reverse Transform Values
#' @description
#'  Converts input values into a standardized
#'  set of filtered and reverse transformed values for
#'  easy plotting and/or comparison.
#'  @param raw_values the raw sentiment values
#'  calculated for each sentence
#'  @param low_pass_size The number of components
#'  to retain in the low pass filtering. Default = 3
#'  @param x_reverse_len the number of values to return. Default = 100
#'  @param scale_range Logical determines whether or not to scale the values from -1 to +1.  Default = FALSE.  If set to TRUE, the lowest value in the vector will be set to -1 and the highest values set to +1 and all the values scaled accordingly in between.
#'  @param scale_vals Logical determines whether or not to normalize the values using the scale function  Default = FALSE.  If TRUE, values will be scaled by subtracting the means and scaled by dividing by their standard deviations.  See ?scale 
#'  @return The transformed values
#'  @export
#'  @examples
#'  s_v <- get_sentences("I begin this story with a neutral statement.
#'  Now I add a statement about how much I despise cats.  
#'  I am allergic to them. Basically this is a very silly test.")
#'  raw_values <- get_sentiment(s_v, method = "bing")
#'  get_transformed_values(raw_values)
#'  
get_transformed_values <- function(raw_values, low_pass_size = 3, x_reverse_len = 100, padding_factor = 1.25, scale_vals = FALSE, scale_range = FALSE){
  if(!is.numeric(raw_values)) stop("Input must be an numeric vector")
  if(low_pass_size > length(raw_values)) stop("low_pass_size must be less than or equal to the length of raw_values input vector")
  raw_values.len <- length(raw_values)
  padding.len <- raw_values.len * padding_factor
  # Add padding, then fft
  values_fft <- fft( c(raw_values, rep(0, padding.len)) )
  keepers <- values_fft[1:low_pass_size]
  # Preserve frequency domain structure
  modified_spectrum <- c(keepers,
                         rep(0, (x_reverse_len * (1+padding_factor)) - (2*low_pass_size) + 1),
                         rev(Conj( keepers[2:(length(keepers))] )))
  inverse_values <- fft(modified_spectrum, inverse=T)
  # Strip padding
  inverse_values <- inverse_values[1:(x_reverse_len)]
  transformed_values <- Re(inverse_values)
  if(scale_vals & scale_range) stop("ERROR: scale_vals and scale_range cannot both be true.")
  if(scale_vals){
    return(scale(transformed_values))
  } else if(scale_range & !scale_vals) {
    return(rescale(transformed_values))
  } else {
    return(transformed_values)
  }
}



