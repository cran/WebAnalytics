\name{plotErrorRateByHour}
\alias{plotErrorRateByHour}
\title{Plots rates of HTTP response code groups by hour  
}
\description{
Generates a stacked bar plot of http response code types (2xx Success, 3xx Redirect, 4xx User Error and 5xx System Error) by hour.

The x-axis is hours and the plot is limited to 24 axis labels (optimally this is one day) regardless of how many days are being reported. 
This ensures that the labels are readable.  
}
\usage{
plotErrorRateByHour(dataFrame) 
}
\arguments{
  \item{dataFrame}{
	a transaction data frame created by \code{\link{logFileRead}} or \code{\link{logFileListRead}} 
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
writeLines(readLines(fileConn),con=logfile)
close(fileConn)
# set the files directory name suitable for an R example
configVariableSet("config.workdir", tempdir())
}
logFileName = logFileNamesGetLast(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log")[[1]]

cols = logFileFieldsGetIIS(logFileName)

logdf = logFileRead(logFileName, columnList=cols, 
            logTimeZone = "", timeFormat = "")

plotErrorRateByHour(logdf) 
}
\seealso{
\code{\link{logFileRead}}
\code{\link{logFileListRead}}
}
\keyword{ manip }
