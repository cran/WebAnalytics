library(testthat)
library(WebAnalytics)

test_that("all names must match requires get last file name", {
  expect_error(logFileNamesGet(allNamesMustMatch=TRUE, getLastFileName=FALSE), 'allNamesmustMatch=TRUE requires getLastFileName=TRUE')
})
test_that("data directory existence is checked", {
  expect_error(logFileNamesGet(dataDirectory="missing"), 'Cannot find directory')
})

test_that("data directory existence is checked", {
  expect_error(logFileNamesGet(directoryNames=c("missing1","missing2")), 'Directory missing1 was not found under ')
})

test_that("last log file is returned",{
          expect_equal(normalizePath(logFileNamesGetLast()), normalizePath(paste0(getwd(),"/u_getIISFields9.log")))
          })

test_that("all log files are returned",{
  expect_equal(normalizePath(logFileNamesGetAll()), normalizePath(c(paste0(getwd(),"/u_getIISFields1.log"),paste0(getwd(),"/u_getIISFields2.log"),
                                     paste0(getwd(),"/u_getIISFields3.log"),paste0(getwd(),"/u_getIISFields4.log"),
                                     paste0(getwd(),"/u_getIISFields5.log"),paste0(getwd(),"/u_getIISFields6.log"),
                                     paste0(getwd(),"/u_getIISFields7.log"),paste0(getwd(),"/u_getIISFields8.log"),
                                     paste0(getwd(),"/u_getIISFields9.log"))
                                     ))
})

test_that("last matching files are returned",{
  expect_equal(normalizePath(logFileNamesGetLastMatching(directoryNames=c(".","."))), normalizePath(c(paste0(getwd(),"/u_getIISFields9.log"),paste0(getwd(),"/u_getIISFields9.log"))))
})