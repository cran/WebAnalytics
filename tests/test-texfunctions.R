library(testthat)
library(WebAnalytics)

test_that("escape string works", {
  expect_equal(laTeXEscapeString("~!@#$%^&*(){}[]_-|\\"),
               "\\textasciitilde{}!@\\#\\$\\%\textasciicircum{}\\&*()\\{\\}[]\\_-|textbackslash\\{\\}")
})

