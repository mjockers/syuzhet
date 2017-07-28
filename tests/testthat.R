Sys.setenv("R_TESTS" = "")
library(testthat)
library(syuzhet)

test_check("syuzhet")
