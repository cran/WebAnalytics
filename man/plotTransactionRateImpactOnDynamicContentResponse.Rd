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
datd = dirname(system.file("extdata", "compressed.log", package = "WebAnalytics"))
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
