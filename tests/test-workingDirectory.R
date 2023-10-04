library(testthat)
library(WebAnalytics)

test_that("populate works", {
  local_edition(3)
  skip_on_cran()
  wkdir = paste0(tempdir(),"/testwkdir/")
  workingDirectoryPopulate(wkdir)
  # recursive=TRUE to suppress the txdata directory name being listed
  expect_equal(list.files(wkdir,recursive=TRUE), list.files(system.file("templates", ".", package="WebAnalytics",mustWork=TRUE)))
  workingDirectoryPopulate(wkdir)
  expect_equal(list.files(wkdir,recursive=TRUE), list.files(system.file("templates", ".", package="WebAnalytics",mustWork=TRUE)))
  unlink(wkdir,recursive=TRUE)
})

