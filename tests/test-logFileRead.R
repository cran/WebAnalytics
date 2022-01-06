library(testthat)
library(WebAnalytics)

test_that("expected record count is read",{
          expect_true(59414 == nrow(logFileRead("u_getIISFields5.log", columnList = logFileFieldsGetIIS("u_getIISFields5.log"))))
          })

fullVarList = c("MSTimestamp","ignored: s-ip","httpop","url", "ignored: cs-uri-query","ignored: s-port","ignored: cs-username", "userip", "useragent", "ignored: cs(Referer)", "httpcode", "ignored: sc-substatus", "ignored: sc-win32-status", "elapsedms")

test_that("minimum columns",{
  #for(i in c(1,3,4,8,9,11,14))
  #{
  #  expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(i)]),"specified column set does not include a timestamp: ApacheTimestamp or MSTimestamp")
  #}
   expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(1)]),"specified column set does not include a timestamp: ApacheTimestamp or MSTimestamp")
   expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(4)]),"specified column set does not include all of the minimum required columns: url missing")
   expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(11)]),"specified column set does not include all of the minimum required columns: httpcode missing")
   expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(14)]),"specified column set does not include a duration: elapsedms, elaspedus, elapseds")
   expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(3)]),"more columns than column names")
   expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(8)]),"more columns than column names")
   expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(9)]),"more columns than column names")
   tempVarList = fullVarList
   tempVarList[2] = "not a known variable"
   expect_error(logFileRead("u_getIISFields5.log", columnList = tempVarList),"column name \"not a known variable\" is neither a defined column name nor begins with the text 'ignore'")
})

test_that("dropping ignore columns",{
  df =  logFileRead("u_getIISFields5.log", columnList = fullVarList)
  expect_false(any(grepl("ignore.*", names(df))))
})
  
test_that("report different column counts",{
  expect_error(any(grepl("ignore.*", names(logFileRead("u_getIISFields9.log", columnList = fullVarList)))))
})
