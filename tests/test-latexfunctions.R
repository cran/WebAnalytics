library(testthat)
library(WebAnalytics)

test_that("pargraph is written", {
  expect_output(laTeXParagraphWrite(), "\n\\paragraph{}",fixed=TRUE)
  expect_output(laTeXParagraphWrite("test string"), "\n\\paragraph{}test string",fixed=TRUE)
})

