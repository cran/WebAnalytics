library(testthat)
library(WebAnalytics)

test_that("saveGraph saves the right file names", {
  filesDir = paste0(tempdir(), "/", "testplotfunctions/")
  dir.create(filesDir)
  configVariableSet("config.workdir", filesDir)
  fileName = "u_getIISFields5.log"
  logFields = logFileFieldsGetIIS(fileName)
  logrecs = logFileRead(fileName, columnList=logFields)
  
  #dir.create(configFilesDirectoryNameGet(),recursive=TRUE)
  
  filename = plotSave(plot(logrecs$elapsed, logrecs$ts), fileID = "x", fileType="jpg")
  
  expect_true(file.exists(filename))

  unlink(filename)

  filename = plotSave(plot(logrecs$elapsed, logrecs$ts), "y", "eps")
  expect_true(file.exists(filename))

  unlink(filename)
  #expect_error(plotSave(ggplot(data=logrecs)+aes(y=elapsed, x=posixtimes)+geom_point(), "z.eps"), "ggplot object passed to plotSave")

  qqqq = ggplot(data=logrecs)+aes(y=elapsed, x=ts)+geom_point()
  expect_equal(length(logrecs$ts),59414)
  
  filename = plotSaveGG(qqqq, "z2","eps")
  expect_true(file.exists(filename))
  
  unlink(filename)
})

