\name{plotFrequencyHistogramOutlierCutoff}
\alias{plotFrequencyHistogramOutlierCutoff}
\title{Plot frequencies of elapsed times up to a percentile cutoff}
\description{
Given a column of values or a data frame created by readFileList or readFile, generate a ggplot of a frequency histogram excluding values above a specified percentile}
\usage{
plotFrequencyHistogramOutlierCutoff(theDf, outlierCutoff) 
}
\arguments{
  \item{theDf}{
	Either a data frame created by readFile or readFileList or a vector of numeric values (assumed to be elapsed times).
	}
  \item{outlierCutoff}{
	A value between 0 and 1 which specifies the percentile above which values are excluded.  
	}
}
\details{
The function is used to produce histogram plots of elapsed times with outliers excluded.  
It can accept either a list (which is converted to a data frame with the column named 'elapsed' or a data frame from a log file.  
}
\value{
Returns a ggplot2 plot.  This function is intended to be wrapped in a call to \code{\link{plotSaveGG}}
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

plotFrequencyHistogramOutlierCutoff(logdf, 0.95) 
}
\seealso{
\code{\link{logFileRead}}
\code{\link{logFileListRead}}
}
\keyword{ manip }
