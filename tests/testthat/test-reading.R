context("Getting text from files")

file  <- system.file("extdata", "portrait.txt", package = "syuzhet")
joyce <- get_text_as_string(file)

test_that("Text files can be read locally and parsed correctly",{
  expect_that(joyce, is_a("String"))
  expect_that(length(joyce), equals(1))
})

context("Parsing sentences")

sents <- get_sentences(joyce)

test_that("Sentences are correctly parsed.", {
  expect_that(sents, is_a("character"))
  expect_true(length(sents) > 1 ) # i.e., it's not just a single string anymore
  expect_equal(sents[2], "He was baby tuckoo.")
})

context("Getting sentiment")

syu   <- get_sentiment(sents, method = "syuzhet")
bing  <- get_sentiment(sents, method = "bing")
afinn <- get_sentiment(sents, method = "afinn")
nrc   <- get_sentiment(sents, method = "nrc")

test_that("Sentiments are returned correctly", {
  expect_that(syu, is_a("numeric"))
  expect_that(bing, is_a("integer"))
  expect_that(afinn, is_a("integer"))
  expect_that(nrc, is_a("numeric")) # because it is averages
  expect_equal(length(sents), length(syu))
  expect_equal(length(sents), length(bing))
  expect_equal(length(sents), length(afinn))
  expect_equal(length(sents), length(nrc))
})