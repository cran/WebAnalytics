\name{plotWriteFilenameToLaTexFile}
\alias{plotWriteFilenameToLaTexFile}
\title{Write an includegraphic element to the generated \LaTeX file}
\description{
Writes an includegraphic element to the brew-generated \LaTeX file.  Written to be used in a series of nested calls as shown in the example. 
}
\usage{
plotWriteFilenameToLaTexFile(graphicFileName) 
}
\arguments{
  \item{graphicFileName}{
The name of the file to be included in the LaTeX
  }
}
\value{
Does not return a value
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

plotWriteFilenameToLaTexFile(plotSaveGG(plotErrorRateByHour(logdf),"xxx", "eps"))
\dontshow{
# clean up the example files that were just saved
unlink(paste0(configFilesDirectoryNameGet(),"/*.eps"))
}
}
\keyword{ file }
\keyword{ input }
\keyword{ fields }
\keyword{ columns }
\keyword{ csv }
