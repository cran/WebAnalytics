\name{plotDataRateImpactOnResponse}
\alias{plotDataRateImpactOnResponse}
\title{Get list of latest files from log directories
}
\description{
Generates a plot of 95th percentile response time for a specified combination of transaction and response status against 
aggregate data rate, for ten minute intervals in the dataframe provided.  
}
\usage{
plotDataRateImpactOnResponse(dataFrame, filterURL, status) 
}
\arguments{
  \item{dataFrame}{
	a transaction data frame  
	}
  \item{filterURL}{
	the URL to be examined
	}
  \item{status}{
	the status of the request: 'Success', 'Redirect', 'Client Error' or 'Server Error'
	}
}
\value{
Returns an R base graphics plot.  This function is intended to be wrapped in a call to \code{\link{plotSave}}
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
plotDataRateImpactOnResponse(logdf, "/QWERTYTest/XRMServices/2011/Organization.svc", "Success") 

}
\keyword{ manip }
