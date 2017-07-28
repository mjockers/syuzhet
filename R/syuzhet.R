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
#' Parses a string into a vector of word tokens.
#' @param text_of_file A Text String
#' @param pattern A regular expression for token breaking
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
#' @param fix_curly_quotes logical.  If \code{TRUE} curly quotes will be 
#' converted to ASCII representation before splitting.
#' @param as_vector If \code{TRUE} the result is unlisted.  If \code{FALSE}
#' the result stays as a list of the original text string elements split into 
#' sentences.
#' @return A Character Vector of Sentences
#' @export
#' @examples
#' (x <- c(paste0(
#'     "Mr. Brown comes! He says hello. i give him coffee.  i will ",
#'     "go at 5 p. m. eastern time.  Or somewhere in between!go there"
#' ),
#' paste0(
#'     "Marvin K. Mooney Will You Please Go Now!", "The time has come.",
#'     "The time has come. The time is now. Just go. Go. GO!",
#'     "I don't care how."
#' )))
#' 
#' get_sentences(x)
#' get_sentences(x, as_vector = FALSE)
#' 
#' 
get_sentences <- function(text_of_file, fix_curly_quotes = TRUE, as_vector = TRUE){

  if (!is.character(text_of_file)) stop("Data must be a character vector.")
  if (isTRUE(fix_curly_quotes)) text_of_file <- replace_curly(text_of_file)

  splits <- textshape::split_sentence(text_of_file)
  if (isTRUE(as_vector)) splits <- unlist(splits)
  splits
}

## helper curly quote replacement function
replace_curly <- function(x, ...){
    replaces <- c('\x91', '\x92', '\x93', '\x94')
    Encoding(replaces) <- "latin1"
    for (i in 1:4) {
        x <- gsub(replaces[i], c("'", "'", "\"", "\"")[i], x, fixed = TRUE)
    }
    x
}


#' Get Sentiment Values for a String
#' @description
#' Iterates over a vector of strings and returns sentiment values based on user supplied method. The default method, "syuzhet" is a custom sentiment dictionary developed in the Nebraska Literary Lab.  The default dictionary should be better tuned to fiction as the terms were extracted from a collection of 165,000 human coded sentences taken from a small corpus of contemporary novels.
#' 
#' @param char_v A vector of strings for evaluation.
#' @param method A string indicating which sentiment method to use. Options include "syuzhet", "bing", "afinn", "nrc" and "stanford."  See references for more detail on methods.
#' @param cl Optional, for parallel sentiment analysis.
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
get_sentiment <- function(char_v, method = "syuzhet", path_to_tagger = NULL, cl=NULL){
  if(is.na(pmatch(method, c("syuzhet", "afinn", "bing", "nrc", "stanford")))) stop("Invalid Method")
  if(!is.character(char_v)) stop("Data must be a character vector.")
  if(!is.null(cl) && !inherits(cl, 'cluster')) stop("Invalid Cluster")
  if(method == "syuzhet"){
    char_v <- gsub("-", "", char_v) #syuzhet lexicon removes hyphens from compound words.
  }
  if(method == "afinn" || method == "bing" || method == "syuzhet"){
    word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
    if(is.null(cl)){
      result <- unlist(lapply(word_l, get_sent_values, method))
    }
    else {
      result <- unlist(parallel::parLapply(cl=cl, word_l, get_sent_values, method))
    }
  }
  else if(method == "nrc"){
    #TODO Try parallelize nrc sentiment
    result <- get_nrc_sentiment(char_v, cl=cl)
    result <- (result$negative*-1) + result$positive
  } 
  else if(method == "stanford") {
    if(is.null(path_to_tagger)) stop("You must include a path to your installation of the coreNLP package.  See http://nlp.stanford.edu/software/corenlp.shtml")
    result <- get_stanford_sentiment(char_v, path_to_tagger)
  }
  return(result)
}

#' Assigns Sentiment Values
#' @description
#' Assigns sentiment values to words based on preloaded dictionary. The default is the syuzhet dictionary.
#' @param char_v A string
#' @param method A string indicating which sentiment dictionary to use
#' @return A single numerical value (positive or negative)
#' based on the assessed sentiment in the string
#' @export
#'
get_sent_values <- function(char_v, method = "syuzhet"){
  if(method == "bing") {
    result <- sum(bing[which(bing$word %in% char_v), "value"])
  }
  else if(method == "afinn"){
    result <- sum(afinn[which(afinn$word %in% char_v), "value"])
  }
  else if(method == "syuzhet"){
    char_v <- gsub("-", "", char_v)
    result <- sum(syuzhet_dict[which(syuzhet_dict$word %in% char_v), "value"])
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
#' 
#' @param char_v A character vector
#' @param cl Optional, for parallel analysis
#' @return A data frame where each row represents a sentence
#' from the original file.  The columns include one for each
#' emotion type as well as a positive or negative valence.  
#' The ten columns are as follows: "anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust", "negative", "positive." 
#' @references Saif Mohammad and Peter Turney.  "Emotions Evoked by Common Words and Phrases: Using Mechanical Turk to Create an Emotion Lexicon." In Proceedings of the NAACL-HLT 2010 Workshop on Computational Approaches to Analysis and Generation of Emotion in Text, June 2010, LA, California.  See: http://saifmohammad.com/WebPages/lexicons.html
#'
#' @export
get_nrc_sentiment <- function(char_v, cl=NULL){
  if (!is.character(char_v)) stop("Data must be a character vector.")
  if(!is.null(cl) && !inherits(cl, 'cluster')) stop("Invalid Cluster")
  word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
  if(is.null(cl)){
    nrc_data <- lapply(word_l, get_nrc_values)
  }
  else{
    nrc_data <- parallel::parLapply(cl=cl, word_l, get_nrc_values)
  }
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
#' @export
get_nrc_values <- function(word_vector){
  colSums(nrc[which(rownames(nrc) %in% word_vector), ])
}

#' Fourier Transform and Reverse Transform Values
#' @description 
#' Converts input values into a standardized set of filtered and reverse transformed values for easy plotting and/or comparison.
#' @param raw_values the raw sentiment values calculated for each sentence
#' @param low_pass_size The number of components to retain in the low pass filtering. Default = 3
#' @param x_reverse_len the number of values to return. Default = 100
#' @param padding_factor the amount of zero values to pad raw_values with, as a factor of the size of raw_values. Default = 2.
#' @param scale_range Logical determines whether or not to scale the values from -1 to +1.  Default = FALSE.  If set to TRUE, the lowest value in the vector will be set to -1 and the highest values set to +1 and all the values scaled accordingly in between.
#' @param scale_vals Logical determines whether or not to normalize the values using the scale function  Default = FALSE.  If TRUE, values will be scaled by subtracting the means and scaled by dividing by their standard deviations.  See ?scale
#' @return The transformed values
#' @examples 
#' s_v <- get_sentences("I begin this story with a neutral statement. 
#' Now I add a statement about how much I despise cats. 
#' I am allergic to them. 
#' Basically this is a very silly test.")
#' raw_values <- get_sentiment(s_v, method = "bing")
#' get_transformed_values(raw_values)
#' @export 
#' 
get_transformed_values <- function(raw_values, low_pass_size = 2, x_reverse_len = 100, padding_factor = 2, scale_vals = FALSE, scale_range = FALSE){
  if(!is.numeric(raw_values)) stop("Input must be an numeric vector")
  if(low_pass_size > length(raw_values)) stop("low_pass_size must be less than or equal to the length of raw_values input vector")
  raw_values.len <- length(raw_values)
  padding.len <- raw_values.len * padding_factor
  # Add padding, then fft
  values_fft <- stats::fft( c(raw_values, rep(0, padding.len)) )
  low_pass_size <- low_pass_size * (1 + padding_factor)
  keepers <- values_fft[1:low_pass_size]
  # Preserve frequency domain structure
  modified_spectrum <- c(keepers, rep(0, (x_reverse_len * (1+padding_factor)) - (2*low_pass_size) + 1), rev(Conj( keepers[2:(length(keepers))] )))
  inverse_values <- stats::fft(modified_spectrum, inverse=T)
  # Strip padding
  inverse_values <- inverse_values[1:(x_reverse_len)]
  transformed_values <- Re(inverse_values)
  if(scale_vals & scale_range) stop("ERROR: scale_vals and scale_range cannot both be true.")
  if(scale_vals){
    return(scale(transformed_values))
  }
  if(scale_range){
    return(rescale(transformed_values))
  }
  return(transformed_values)
}

#' Chunk a Text and Get Means
#' @description 
#' Chunks text into 100 Percentage based segments and calculates means.
#' @param raw_values Raw sentiment values
#' @param bins The number of bins to split the input vector.
#' Default is 100 bins.
#' @export 
#' @return A vector of mean values from each chunk
#'
get_percentage_values <- function(raw_values, bins = 100){
  if(!is.numeric(raw_values) | !is.numeric(bins)) stop("Input must be a numeric vector")
  if(length(raw_values)/bins < 2){
    stop("Input vector needs to be twice as long as value number to make percentage based segmentation viable")
  }
  chunks <- split(raw_values, cut(1:length(raw_values),bins))
  means <- sapply(chunks, mean)
  names(means) <- 1:bins
  return(means)
}

#' Get Sentiment from the Stanford Tagger
#' @description 
#' Call the Stanford Sentiment tagger with a
#' vector of strings.  The Stanford tagger automatically
#' detects sentence boundaries and treats each sentence as a 
#' distinct instance to measure. As a result, the vector 
#' that gets returned will not be the same length as the
#' input vector.
#' @param text_vector A vector of strings
#' @param path_to_stanford_tagger a local file path indicating 
#' where the coreNLP package is installed.
#' @export 
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

#' Vector Value Rescaling
#' @description
#' Rescale Transformed values from -1 to 1
#' 
#' @param x A vector of values
#' @export
rescale <- function(x){
  2 * (x - min(x))/( max(x) - min(x)) -1
}

#' Bi-Directional x and y axis Rescaling
#' @description
#' Rescales input values to two scales (0 to 1 and  -1 to 1) on the y-axis and also creates a scaled vector of x axis values from 0 to 1.  This function is useful for plotting and plot comparison.
#' @param v A vector of values
#' @return A list of three vectors (x, y, z).  x is a vector of values from 0 to 1 equal in length to the input vector v. y is a scaled (from 0 to 1) vector of the input values equal in lenght to the input vector v. z is a scaled (from -1 to +1) vector of the input values equal in length to the input vector v.
#' @export
rescale_x_2 <- function(v){
  x <- 1:length(v)/length(v)
  y <- v/max(v)
  z <- 2 * (v - min(v))/(max(v) - min(v)) - 1
  return (list(x=x,y=y,z=z))
}

#' Plots simple and rolling shapes overlayed
#' @description A simple function for comparing three smoothers
#' @param raw_values the raw sentiment values
#' calculated for each sentence
#' @param title for resulting image
#' @param legend_pos positon for legend
#' @param lps size of the low pass filter. I.e. the number of low frequency components to retain
#' @param window size of the rolling window for the rolling mean expressed as a percentage.
#' @export
simple_plot <- function (raw_values, title = "Syuzhet Plot", legend_pos = "top", lps=10, window = 0.1){
  wdw <- round(length(raw_values) * window)
  rolled <- rescale(zoo::rollmean(raw_values, k = wdw, fill = 0))
  half <- round(wdw/2)
  rolled[1:half] <- NA
  end <- length(rolled) - half
  rolled[end:length(rolled)] <- NA
  trans <- get_dct_transform(raw_values, low_pass_size = lps, x_reverse_len = length(raw_values), 
                             scale_range = T)
  x <- 1:length(raw_values)
  y <- raw_values
  raw_lo <- stats::loess(y ~ x, span = 0.5)
  low_line <- rescale(stats::predict(raw_lo))
  graphics::par(mfrow = c(2, 1))
  graphics::plot(low_line, type = "l", ylim = c(-1, 1), main = title, 
                 xlab = "Full Narrative Time", ylab = "Scaled Sentiment", col="blue", lty = 2)
  graphics::lines(rolled, col = "grey", lty = 2)
  graphics::lines(trans, col = "red")
  graphics::abline(h=0, lty=3)
  graphics::legend(legend_pos, c("Loess Smooth", "Rolling Mean", 
                                 "Syuzhet DCT"), lty = 1, lwd = 1, col = c("blue", "grey", 
                                                                           "red"), bty = "n", cex = 0.75)
  normed_trans <- get_dct_transform(raw_values, scale_range = T, low_pass_size = 5)
  graphics::plot(normed_trans, type = "l", ylim = c(-1, 1), 
                 main = "Simplified Macro Shape", xlab = "Normalized Narrative Time", 
                 ylab = "Scaled Sentiment", col = "red")
  graphics::par(mfrow = c(1, 1))
}

#' Discrete Cosine Transformation with Reverse Transform.
#' @description
#' Converts input values into a standardized
#' set of filtered and reverse transformed values for
#' easy plotting and/or comparison.
#' @param raw_values the raw sentiment values
#' calculated for each sentence
#' @param low_pass_size The number of components
#' to retain in the low pass filtering. Default = 5
#' @param x_reverse_len the number of values to return via decimation. Default = 100
#' @param scale_range Logical determines whether or not to scale the values from -1 to +1.  Default = FALSE.  If set to TRUE, the lowest value in the vector will be set to -1 and the highest values set to +1 and all the values scaled accordingly in between.
#' @param scale_vals Logical determines whether or not to normalize the values using the scale function  Default = FALSE.  If TRUE, values will be scaled by subtracting the means and scaled by dividing by their standard deviations.  See ?scale 
#' @return The transformed values
#' @examples
#' s_v <- get_sentences("I begin this story with a neutral statement.
#' Now I add a statement about how much I despise cats.  
#' I am allergic to them. I hate them. Basically this is a very silly test. But I do love dogs!")
#' raw_values <- get_sentiment(s_v, method = "syuzhet")
#' dct_vals <- get_dct_transform(raw_values)
#' plot(dct_vals, type="l", ylim=c(-0.1,.1))
#' @export
get_dct_transform <- function(raw_values, low_pass_size = 5, x_reverse_len = 100, scale_vals = FALSE, scale_range = FALSE){
  if (!is.numeric(raw_values)) 
    stop("Input must be an numeric vector")
  if (low_pass_size > length(raw_values)) 
    stop("low_pass_size must be less than or equal to the length of raw_values input vector")
  values_dct <- dtt::dct(raw_values, variant = 2)
  keepers <- values_dct[1:low_pass_size]
  padded_keepers <- c(keepers, rep(0, x_reverse_len-low_pass_size))
  dct_out <- dtt::dct(padded_keepers, inverted = T)
  if (scale_vals & scale_range) 
    stop("ERROR: scale_vals and scale_range cannot both be true.")
  if (scale_vals) {
    return(scale(dct_out))
  }
  if(scale_range) {
    return(rescale(dct_out))
  }
  return(dct_out)
}

#' Sentiment Dictionaries
#' @description
#' Get the sentiment dictionaries used in \pkg{syuzhet}.
#' @param dictionary A string indicating which sentiment dictionary to return.  Options include "syuzhet", "bing", "afinn", and "nrc".
#' @return A \code{\link[base]{data.frame}} 
#' @examples
#' get_sentiment_dictionary()
#' get_sentiment_dictionary('bing')
#' get_sentiment_dictionary('afinn')
#' get_sentiment_dictionary('nrc')
#' @export
#'
get_sentiment_dictionary <- function(dictionary = 'syuzhet'){
    switch(dictionary,
        syuzhet = syuzhet_dict,
        bing = bing,
        nrc = nrc,
        afinn = afinn,
        stop("Must be one of: 'syuzhet', 'bing', 'nrc', or 'afinn'")
    )
}
