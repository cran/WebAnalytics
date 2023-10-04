library(testthat)
library(WebAnalytics)

test_that("missing Software line detected", {
  expect_error(logFileFieldsGetIIS("u_getIISFields2.log"), 'log file does not appear to be an IIS log,')
})
test_that("mismatched fields detected", {
  expect_error(logFileFieldsGetIIS("u_getIISFields1.log"), 'more than one unique Field')
})
test_that("missing fields line detected", {
  expect_error(logFileFieldsGetIIS("u_getIISFields3.log"), 'no Fields: specification')
})
test_that("field list construction failure detected", {
  expect_error(logFileFieldsGetIIS("u_getIISFields4.log"), 'field list not constructed from Fields')
})
test_that("missing date detected", {
  expect_error(logFileFieldsGetIIS("u_getIISFields6.log"), 'Fields specification does not include both date and time')
})
test_that("missing time detected", {
  expect_error(logFileFieldsGetIIS("u_getIISFields7.log"), 'Fields specification does not include both date and time')
})
test_that("out of order date and time detected", {
  expect_error(logFileFieldsGetIIS("u_getIISFields8.log"), 'Date and Time fields are not consecutive')
})
test_that("correct fields are emitted",{
          expect_equal(logFileFieldsGetIIS("u_getIISFields5.log"), c("MSTimestamp", "ignored: s-ip","httpop", "url",                     
          "ignored: cs-uri-query",  "ignored: s-port",
          "ignored: cs-username", "userip",       
          "useragent", "ignored: cs(Referer)",    
          "httpcode", "ignored: sc-substatus",   
          "ignored: sc-win32-status","elapsedms"))
          })