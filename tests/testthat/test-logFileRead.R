library(testthat)
library(WebAnalytics)

tests <- function(what)
{
  # it appears that skip in cran is not working.  If skip doesn't work, remove the test
  #skip()


  test_that(paste(what, "expected record count is read"),{
    #skip_on_cran()
    expect_true(59414 == nrow(logFileRead("u_getIISFields5.log", columnList = logFileFieldsGetIIS("u_getIISFields5.log"))))
  })

  fullVarList = c("MSTimestamp","ignored: s-ip","httpop","url", "ignored: cs-uri-query","ignored: s-port","ignored: cs-username", "userip", "useragent", "ignored: cs(Referer)", "httpcode", "ignored: sc-substatus", "ignored: sc-win32-status", "elapsedms")

  test_that(paste(what, "minimum columns"),{
    # it appears that skip in cran is not working.  If skip doesn't work, remove the test
    #skip()
    skip_on_cran()
;    expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(1)]),"specified column set does not include a timestamp: ApacheTimestamp or MSTimestamp")
    expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(4)]),"specified column set does not include all of the minimum required columns: url missing")
    expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(11)]),"specified column set does not include all of the minimum required columns: httpcode missing")
    expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(14)]),"specified column set does not include a duration: elapsedms, elapsedus, elapseds")
    if(what == "core")
    {
      expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(3)]),"more columns than column names")
      expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(8)]),"more columns than column names")
      expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(9)]),"more columns than column names")
    } else {
      expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(3)]),"colClasses= is an unnamed vector of types, length 14, but there are 15 columns")
      expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(8)]),"colClasses= is an unnamed vector of types, length 14, but there are 15 columns")
      expect_error(logFileRead("u_getIISFields5.log", columnList = fullVarList[-(9)]),"colClasses= is an unnamed vector of types, length 14, but there are 15 columns")
    }
    tempVarList = fullVarList
    tempVarList[2] = "not a known variable"
    expect_error(logFileRead("u_getIISFields5.log", columnList = tempVarList),"column name \"not a known variable\" is neither a defined column name nor begins with the text 'ignore'")
  })

  test_that(paste(what, "dropping ignore columns"),{
    # it appears that skip in cran is not working.  If skip doesn't work, remove the test
    #skip()
    skip_on_cran()
    df =  logFileRead("u_getIISFields5.log", columnList = fullVarList)
    expect_false(any(grepl("ignore.*", names(df))))
  })
    
  test_that(paste(what, "report different column counts"),{
    # it appears that skip in cran is not working.  If skip doesn't work, remove the test
    #skip()
    skip_on_cran()
    if(what == "core")
    {
      expect_error(any(grepl("ignore.*", names(logFileRead("u_getIISFields9.log", columnList = fullVarList)))))

    } else {
      expect_warning(any(grepl("ignore.*", names(logFileRead("u_getIISFields9.log", columnList = fullVarList)))))
    }
  })
}

#tests("default")

configVariablesLoad("variables.config")
configVariableSet("config.read.function", "core")

tests("core") 

configVariablesLoad("variables.config")
configVariableSet("config.read.function", "data.table")

tests("data.table")  

test_that(paste("invalid read function is reported"),{
    skip_on_cran()
    configVariablesLoad("variables.config")
    configVariableSet("config.read.function", "qqq")
    expect_error(logFileRead("u_getIISFields5.log", columnList = logFileFieldsGetIIS("u_getIISFields5.log")), "config.read.function qqq must be either \"core\" or \"data.table\" ")
})


