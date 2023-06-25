\name{plotSave}
\alias{plotSave}
\alias{plotSaveGG}
\title{Save a plot to a file with a generated name}
\description{
These two functions save a base graphics plot function call or a ggplot object to a file with a generated name in the format (eps or jpg) specified and return the generated file name.   
}
\usage{
plotSaveGG(thePlot, fileID, fileType = "jpg") 
plotSave(thePlot,
      fileID, 
      fileType = "jpg", 
      imageQuality=90, 
      imageDefaultWidth=600, 
      imageDefaultHeight=400) 
}
\arguments{
  \item{thePlot}{
  Either a base graphics plot function call or a ggplot plot object.  The base graphics function call is valuated within the function, not at the time of the call (A peculiarity of the R language)
  }
  \item{fileID}{
	A unique ID for the file.  This ID is used to generate a hash which is used as the file name.  The ID may contain any characters and can, for example be a URL which would not otherwise be a valid filename.  
  }
  \item{fileType}{
Either eps or jpg depending on the file format required.  EPS files grow significantly as the number of data points grows.  For very large data sets jpg is preferable.    
  }
  \item{imageQuality}{
The percent quality for JPG file construction.  EPS files are metafiles and do not have a percent quality.  
  }
  \item{imageDefaultWidth}{
  The width in pixels of the image 
  }
  \item{imageDefaultHeight}{
  The height in pixels of the image 
  }
}
\value{
The function returns the generated file name after creating the file.  
}
\author{
Greg Hunt <greg@firmansyah.com>
}
\examples{
\dontshow{
datd = paste0(tempdir(),"/minconfigtemp")
unlink(datd)
dir.create(paste0(tempdir(),"/minconfigtemp"))
logfile = paste0(datd,"/log.log")
fileConn = gzfile(system.file("extdata", "compressed.log", package = "WebAnalytics"))
writeLines(readLines(fileConn,n=100),con=logfile)
close(fileConn)
# set the files directory name suitable for an R example
configVariableSet("config.workdir", tempdir())
setDTthreads(threads = 1)
}
logFileName = logFileNamesGetLast(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log")[[1]]

cols = logFileFieldsGetIIS(logFileName)

logdf = logFileRead(logFileName, columnList=cols, 
            logTimeZone = "", timeFormat = "")

plotSaveGG(plotErrorRateByHour(logdf),"xxx", "eps")
plotSave(plotResponseTimeScatter(logdf$ts, logdf$elapsed), "yyy", "jpg")
\dontshow{
# clean up the example files that were just saved
unlink(paste0(configFilesDirectoryNameGet(),"/*.jpg"))
unlink(paste0(configFilesDirectoryNameGet(),"/*.eps"))
}
}
\keyword{ file }
\keyword{ input }
\keyword{ fields }
\keyword{ columns }
\keyword{ csv }
