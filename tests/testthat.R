Sys.unsetenv("R_TESTS") # becasue https://github.com/hadley/testthat/issues/144
library(testthat)
library(syuzhet)

test_check("syuzhet")
