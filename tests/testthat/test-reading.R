context("Getting text from files")

file  <- system.file("extdata", "portrait.txt", package = "syuzhet")
joyce <- get_text_as_string(file)

test_that("Text files can be read locally and parsed correctly",{
  expect_that(joyce, is_a("String"))
  expect_that(length(joyce), equals(1))
})