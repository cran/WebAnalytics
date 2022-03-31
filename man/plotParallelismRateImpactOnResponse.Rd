\name{plotParallelismRateImpactOnResponse}
\alias{plotParallelismRateImpactOnResponse}
\title{Plot response time against degree of parallelism}
\description{
Generates a plot of the effect of overall parallelism on response time possibly limited to a single URL in the overall background, the URL whose time is calculated, and by http response type and status.
}
\usage{
plotParallelismRateImpactOnResponse(b, 
      intervalLength = 600, 
			excludeURLOverall="", 
			includeURLOverall="",
			excludeResponse="",
			includeResponse="", 
			excludeStatus="",
			includeStatus="",
			percentileCutoff = 1,
			title="Degree of Parallelism and Response Time", 
			subtitle="")
}
\arguments{
  \item{b}{
	a transaction data frame  
	}
  \item{intervalLength}{
	length of the intervals (in seconds) that parallelism is calculated over
	}
  \item{excludeURLOverall}{
	a URL to be deleted from the dataset
	}
  \item{includeURLOverall}{
	the URL to be included from the dataset
	}
  \item{excludeResponse}{
	a URL to be excluded from the response time calculation
	}
  \item{includeResponse}{
	the URL to be used for the response time calculation
	}
  \item{excludeStatus}{
	a status to be excluded from the response time calculation, for example success statuses could be excluded.  Possible status values are: 'Success', 'Redirect', 'Client Error' or 'Server Error'
	}
  \item{includeStatus}{
	a status to filter URLs by, for example, only include success responses in the response time calculation 
	}
  \item{percentileCutoff}{
	exclude values above the specified quantile, intended for use in excluding outlier events that would distort the elapsed time calculation 
	}
  \item{title}{
the plot title
	}
  \item{subtitle}{
the plot subtitle
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
plotParallelismRateImpactOnResponse(logdf,
            includeStatus="Success",
            excludeResponse="Static Content Requests",
            percentileCutoff=0.95)
}
\keyword{ manip }
