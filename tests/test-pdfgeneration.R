library(testthat)
library(WebAnalytics)
library(fs)

test_that("pdf is generated from sample data", {
  local_edition(3)
  skip_on_cran()
  wkdir = paste0(tempdir(),"/testpdf/")
  workingDirectoryPopulate(wkdir)
  expect_snapshot(system(paste0("cd ", wkdir, "; ls; . ./makerpt.sh sample")))
  skip_on_os("windows")
  skip_on_os("linux")
  skip_on_os("solaris")
  system(paste0("open ",wkdir, "*.pdf ; sleep 1"))
  unlink(wkdir,recursive=TRUE)
})

