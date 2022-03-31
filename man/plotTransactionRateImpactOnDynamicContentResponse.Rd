\name{plotTransactionRateImpactOnDynamicContentResponse}
\alias{plotTransactionRateImpactOnDynamicContentResponse}
\title{Generate a plot of mean transaction rate by interval against dynamic content response}
\description{
Calls \code{\link{plotByRate}} internally to generate a rate plot.   
}
\usage{
plotTransactionRateImpactOnDynamicContentResponse(b)
}
\arguments{
  \item{b}{
	a transaction data frame created by \code{\link{logFileRead}} or \code{\link{logFileListRead}} 
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

plotTransactionRateImpactOnDynamicContentResponse(logdf)

}
\seealso{
\code{\link{plotByRate}}
\code{\link{savePlot}}
\code{\link{logFileRead}}
\code{\link{logFileListRead}}
}
\keyword{ manip }
