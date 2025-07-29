library(testthat)
library(WebAnalytics)
library(fs)

test_that("URL shortening macro works", {
  local_edition(3)
  # unusable with Cran, test takes a non-negligible amount of time 
  skip_on_cran()
  skip_on_os("mac")
  skip_on_os("linux")
  skip_on_os("solaris")
  skip_on_os("windows")
  wkdir = paste0(tempdir(), "/testpdf/")
  workingDirectoryPopulate(wkdir)
  file.copy("./minimum.config", wkdir)
  file.copy("./texmacrotest.X", wkdir)
  unlink("sampleRfile.R", recursive=TRUE)
  file.rename(paste0(wkdir, "/texmacrotest.X"), paste0(wkdir, "/sampleRfile.R"))
#  expect_snapshot(system(paste0("bash -c \"( cd ", wkdir, "&& ./makerpt.sh minimum \ )")))
#  pdfName = list.files(wkdir,pattern=".*\\.pdf")[[1]]
#  if(isInteractive())
#  {
  system(paste0("bash -c  \" ( cd ", wkdir, " &&. ./makerpt.sh minimum ) \" "))
#    system(paste0("cmd /c start ",wkdir,pdfName))
#  }
#  unlink(wkdir,recursive=TRUE)
})

test_that("pdf is generated from sample data (Linux)", {
  local_edition(3)
  skip_on_cran()
  skip_on_os("mac")
  #skip_on_os("linux")
  skip_on_os("solaris")
  skip_on_os("windows")
  
  # workaround from 2014 (https://github.com/r-lib/testthat/issues/144) seems to evade the apparently un-fixed bug 
  Sys.setenv("R_TESTS" = "")
  
  wkdir = paste0(tempdir(), "/testpdf/")
  workingDirectoryPopulate(wkdir)
  #minpath = test_path("minimum.config")
  #file.copy("./minimum.config", wkdir)
  # have to have an expect 
  expect_no_error(
    system(paste0("bash -c  \" ( cp minimum.config ", wkdir, " && cd ", wkdir, " && . ./makerpt.sh minimum ) \" "))
  )
  pdfName = list.files(wkdir, pattern=".*\\.pdf")[[1]]
  #system(paste0("bash -c  \" evince ", paste0(wkdir, "/",pdfName), " \" "), invisible = FALSE, wait=TRUE)
  #  if(isInteractive())
#  {
#    system(paste0("cmd /c start ",wkdir,pdfName))
#  }
#  unlink(wkdir,recursive=TRUE)
})
test_that("pdf is generated from sample data (Windows)", {
  local_edition(3)
  skip_on_cran()
  skip_on_os("mac")
  skip_on_os("linux")
  skip_on_os("solaris")
  #skip_on_os("windows")
  wkdir = paste0(tempdir(), "/testpdf/")
  workingDirectoryPopulate(wkdir)
  file.copy("./minimum.config", wkdir)
  expect_no_error(system(paste0("cmd /c cd ", wkdir, "& powershell -f makerpt.ps1 minimum")))
  pdfName = list.files(wkdir, pattern=".*\\.pdf")[[1]]
  #  if(isInteractive())
  #  {
  #    system(paste0("cmd /c start ",wkdir,pdfName))
  #  }
  unlink(wkdir,recursive=TRUE)
})

test_that("pdf is generated using pdfGenerate", {
  local_edition(3)
  skip_on_cran()
  skip_on_os("mac")
  #skip_on_os("linux")
  skip_on_os("solaris")
  skip_on_os("windows")
  # since TinyTeX hijacks the local TeX installation, its not R specific its global and I don't need yet another tex installation, it causes me more problems than it solves.   
  wkdir = paste0(tempdir(), "/testpdf2/")
  workingDirectoryPopulate(wkdir)
  file.copy("./minimum.config", wkdir)
  oldwd = getwd()
  setwd(wkdir)
  # the ability to soak up an arbitrary number of wanrings is deprecated (and ironically produces a warning) so this is what I have to code
  expect_warning(expect_warning(expect_warning(expect_warning(expect_warning(expect_warning(expect_warning(expect_warning(expect_warning(expect_warning(pdfGenerate("minimum.config")))))))))))
  setwd(oldwd)
  #expect_snapshot(pdfGenerate(workDir = wkdir,configFile="minimum.config"))
  pdfName = list.files(wkdir, pattern=".*\\.pdf")[[1]]
#  if(isInteractive())
#  {
#    system(paste0("cmd /c start ",wkdir,pdfName))
#  }
  unlink(wkdir,recursive=TRUE)
})

