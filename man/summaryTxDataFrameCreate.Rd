\name{summaryTxDataFrameCreate}
\alias{summaryTxDataFrameCreate}
\title{Creates a dataframe containing summary URL performance metrics
}
\description{
From a dataframe containing log data, calculate 95th percentile response, total wait and error counts, embed TeX hyperlinks referencing the URL.  
Return these in a dataframe intended for printing in a report.  
}
\usage{
summaryTxDataFrameCreate(logDataframe) 
}
\arguments{
  \item{logDataframe}{
	a dataframe created by the functions that read log files.
	}
}
\value{
Returns a dataframe containing columns
\describe{
  \item{Response (sec, 95th pctl)}{95th Percentile response time for the URL}
  \item{Transaction}{The URL}
  \item{Count}{Number of requests for that URL}
  \item{Total Wait (sec)}{Total wait time for the URL in seconds}
  \item{Server Errors}{Number of HTTP 5xx  errors}
  \item{Client Error}{Number of HTTP 4xx errors}
  \item{Redirect}{Number of HTTP 3xx responses}
  \item{Success}{Number of HTTP 200 responses}
}
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

summarydf = summaryTxDataFrameCreate(logdf)
}
\keyword{ manip }
