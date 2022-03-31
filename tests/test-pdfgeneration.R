library(testthat)
library(WebAnalytics)
library(fs)

test_that("pdf is generated from sample data", {
  local_edition(3)
  skip_on_cran()
  skip_on_os("mac")
  skip_on_os("linux")
  skip_on_os("solaris")
  skip_on_os("windows")
  wkdir = paste0(tempdir(),"/testpdf/")
  workingDirectoryPopulate(wkdir)
  file.copy("./minimum.config", wkdir)
  expect_snapshot(system(paste0("cmd /c cd ", wkdir, "& powershell -f makerpt.ps1 minimum")))
  pdfName = list.files(wkdir,pattern=".*\\.pdf")[[1]]
  system(paste0("cmd /c start ",wkdir,pdfName))
  unlink(wkdir,recursive=TRUE)
})

test_that("pdf is generated using pdfGenerate", {
  local_edition(3)
  skip_on_cran()
  skip_on_os("mac")
  skip_on_os("linux")
  skip_on_os("solaris")
  skip_on_os("windows")
  wkdir = paste0(tempdir(),"/testpdf2/")
  workingDirectoryPopulate(wkdir)
  file.copy("./minimum.config", wkdir)
  expect_snapshot(pdfGenerate(workDir = wkdir,configFile="minimum.config"))
  pdfName = list.files(wkdir,pattern=".*\\.pdf")[[1]]
  system(paste0("cmd /c start ",wkdir,pdfName))
  unlink(wkdir,recursive=TRUE)
})

