library(testthat)
library(WebAnalytics)
library(fs)

# test commented out to meet CRAN requirement

# test_that("author name lookup with whoami minimally works", {
#   local_edition(3)
#   skip_on_cran()
#   skip_if_offline()
#   skip_if(Sys.info()["nodename"] != "ListiarMacBook2")
#   
#   libraryLocations=NULL
#   
#   print(.libPaths())
#   # fake the rstudio CRAN entry, the test runs without a value in options("repos").  
#   
#   n = "https://cran.rstudio.com/"
#   names(n) = "CRAN"
#   attr(n, "Rstudio") = TRUE
#   
#   origOptions = options(repos=n)
#   
#   if(require("whoami",quietly=TRUE))
#   {
#     libraryLocations = path.package("whoami")
#     libraryLocations = sub("(.*)/.*$","\\1",libraryLocations[1])
#   }
#   
#   if(!is.null(libraryLocations))
#   {
#     if(length(libraryLocations) > 1)
#     {
#       stop("multiple installs of whoami, too complicated to resolve, giving up")
#     }
#     detach("package:whoami",unload=TRUE)
#     remove.packages(c("whoami"), libraryLocations)
#   }
#   
#   wkdir = paste0(tempdir(),"/testpdf/")
#   workingDirectoryPopulate(wkdir)
#   
#   configVariablesLoad(paste0(wkdir,"/sample.config"))
#   authorNowhoami = configVariableGet("config.author")
#   
#   install.packages("whoami")
#   detach("package:WebAnalytics", unload=TRUE)
#   library("WebAnalytics")
#   library("whoami")
#   
#   configVariablesLoad(paste0(wkdir,"/sample.config"))
#   authorWithwhoami = configVariableGet("config.author")
#   
#   expect_match(authorNowhoami, "Author")
#   expect_match(authorWithwhoami, "Listiari Hunt")
# 
#   improbableAuthorName = "M V Llosa"
#   configVariableSet("config.author", improbableAuthorName)
#   expect_match(configVariableGet("config.author"), improbableAuthorName)  
# 
# 
#   unlink(wkdir,recursive=TRUE)
# 
#   if(is.null(libraryLocations))
#   {
#     remove.packages("whoami",lib=libraryLocations)
#   } else
#   {
#     install.packages("whoami",lib=libraryLocations)
#   }
#   options(origOptions)
# })


test_that("config default values are correct", {
  local_edition(3)

  wkdir = paste0(tempdir(),"/testpdf/")
  workingDirectoryPopulate(wkdir)
  
  detach("package:WebAnalytics", unload=TRUE)
  library("WebAnalytics")
  
  configVariablesLoad("minimum.config")
  
  expect_equal(configVariableGet("config.generateGraphForTimeOver"), 10000)
  expect_equal(configVariableGet("config.generateServerSessionStats"), TRUE)
  expect_equal(configVariableGet("config.generatePercentileRankings"), FALSE)
  expect_equal(configVariableGet("config.readBaseline"), FALSE)
  expect_equal(configVariableGet("config.generateTransactionDetails"), TRUE)
  expect_equal(configVariableGet("config.generateDiagnosticPlots"), TRUE)
  expect_equal(configVariableGet("config.securityClass"), "Commercial-In-Confidence")
  expect_equal(configVariableGet("config.readBaseline"), FALSE)
  expect_equal(configVariableGet("config.useragent.generateFrequencies"), TRUE)
  expect_equal(configVariableGet("config.useragent.minimumPercentage"), 2)
  expect_equal(configVariableGet("config.useragent.maximumPercentile"), 96)
  expect_equal(configVariableGet("config.useragent.discardOther"), TRUE)
  
  unlink(wkdir,recursive=TRUE)
})

test_that("minimum config file works", {
  local_edition(3)
  
  skip_on_cran()

  skip_on_os("windows")
  skip_on_os("linux")
  skip_on_os("solaris")
  
  wkdir = paste0(tempdir(),"/testpdf/")
  workingDirectoryPopulate(wkdir)
  fs::file_copy(paste0(getwd(), "/minimum.config"), paste0(wkdir,"/sample.config"),overwrite=TRUE)
  
  expect_snapshot(system(paste0("cd ", wkdir, "; ls; . ./makerpt.sh sample")))

  system(paste0("open ",wkdir, "*.pdf ; sleep 1"))
  unlink(wkdir,recursive=TRUE)
})