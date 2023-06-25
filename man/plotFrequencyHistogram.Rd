\name{plotFrequencyHistogram}
\alias{plotFrequencyHistogram}
\title{Plot histogram of response times for a transaction dataframe 
}
\description{
Generates a plot of response time frequencies.  

Times are expressed in seconds.  

The histogram bin width is a minimum of 0.1 seconds, or 1/200 of the maximum elapsed time.  The graph tries to show a minimum of 20 bins (2 seconds), 
for data with very small elapsed times this can lead to graphs with significant empty space on the right.  

If the maximum elapsed is greater than 99 seconds, the x axis labels are rotated so that they do not overlap.  
}
\usage{
plotFrequencyHistogram(theDf) 
}
\arguments{
  \item{theDf}{
	a transaction data frame  
	}
}
\value{
Returns a ggplot2 plot.  This function is intended to be wrapped in a call to \code{\link{plotSaveGG}}
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

plotFrequencyHistogram(logdf) 
}
\keyword{ manip }
