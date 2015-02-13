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