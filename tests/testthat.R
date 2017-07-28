Sys.unsetenv("R_TESTS") # Becasue https://github.com/hadley/testthat/issues/144

library(testthat)
library(syuzhet)

test_check("syuzhet")
