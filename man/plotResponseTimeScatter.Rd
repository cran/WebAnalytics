\name{plotResponseTimeScatter}
\alias{plotResponseTimeScatter}
\alias{plotLogResponseTimeScatter}
\title{Generates a scatter plot of response times  
}
\description{
Scatter plot (base graphics object) of response times from a data.  The log form uses a log10 y axis.  
}
\usage{
plotLogResponseTimeScatter(times, elapsed,timeDivisor = 1000, ylabText = "Time (log sec)") 
plotResponseTimeScatter(times, elapsed,timeDivisor = 1000, ylabText = "Time (sec)") 
}
\arguments{
  \item{times}{
POSIXct timestamps
	}
  \item{elapsed}{
elapsed milliseconds 
	}
  \item{timeDivisor}{
divisor to adjust times to seconds (the default value of 1000) or some other interval
	}
  \item{ylabText}{
divisor to adjust times to seconds (the default value of 1000) or some other interval
	}
}
\value{
Generates a base graphics plot.  This function is intended to be wrapped in a call to \code{\link{plotSave}}
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
  fileNamePattern="*[.]log")[[1]] # only want one

cols = logFileFieldsGetIIS(logFileName)

logdf = logFileRead(logFileName, columnList=cols, 
            logTimeZone = "", timeFormat = "")

plotResponseTimeScatter(logdf$ts, logdf$elapsed) 
plotLogResponseTimeScatter(logdf$ts, logdf$elapsed) 
}
\seealso{
\code{\link{savePlot}}
}
\keyword{ manip }
