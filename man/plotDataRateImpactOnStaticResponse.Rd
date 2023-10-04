\name{plotDataRateImpactOnStaticResponse}
\alias{plotDataRateImpactOnStaticResponse}
\title{Plot static object response time against aggregate data rate
}
\description{
Generates a plot of 95th percentile response time for static objects against 
aggregate data rate, for ten minute intervals in the dataframe provided.  
}
\usage{
plotDataRateImpactOnStaticResponse(dataFrame) 
}
\arguments{
  \item{dataFrame}{
	a transaction data frame  
	}
}
\value{
Returns a base graphics plot.  This function is intended to be wrapped in a call to \code{\link{plotSave}}
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

plotDataRateImpactOnStaticResponse(logdf) 
}
\keyword{ manip }
