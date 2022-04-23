\name{logFileRead}
\alias{logFileRead}
\title{Given a list of file names, read them as log files
}
\description{
This function reads a file, parsing it for the fields specified, and normalises the values that have been read.    

The log file is assumed to be space delimited, which is the case for Apache and IIS.  
}
\usage{
logFileRead(fileName, 
  columnList=c("MSTimestamp", "clientip", "url", "httpcode", "elapsed"), 
  logTimeZone = "", 
  timeFormat = "") 
}
\arguments{
  \item{fileName}{
	The name, including path, of the file to read
}
  \item{columnList}{
The columns in the file, in order.  Columns are:
\tabular{llll}{
\code{ApacheTimestamp} \tab Optional \tab Apache log format timestamp \cr
\code{MSTimestamp} \tab Optional \tab IIS log format timestamp \cr
\code{servername} \tab Optional \tab Name of the web server \cr
\code{serverip} \tab Optional \tab IP of the server \cr
\code{httpop} \tab Optional \tab HTTP verb \cr
\code{url} \tab Required \tab Path part of the request \cr
\code{parms} \tab Optional \tab Query string \cr
\code{port} \tab Optional \tab TCP/IP port that the request arrived on \cr
\code{username} \tab Optional \tab User name logged by the web server \cr
\code{userip} \tab Optional \tab IP that the request was seen to originate from. \cr
\code{useragent} \tab Optional \tab User agent string in the request \cr
\code{httpcode} \tab Required \tab HTTP response code \cr
\code{windowscode} \tab Optional \tab Windows return code recorded by IIS \cr
\code{windowssubcode} \tab Optional \tab Windows sub code recorded by IIS \cr
\code{responsebytes} \tab Optional \tab Number of bytes in the HTTP response \cr
\code{requestbytes} \tab Optional \tab Number of bytes in the HTTP request \cr
\code{elapsedms} \tab Optional \tab Request elapsed time in milliseconds \cr
\code{elapsedus} \tab Optional \tab Request elapsed time in microseconds (will be rounded to milliseconds)\cr
\code{elapseds} \tab Optional \tab Request elapsed time in seconds (not recommended, will be expanded to milliseconds) \cr
\code{jsessionid} \tab Optional \tab User session identifier \cr
\code{ignore*} \tab Optional \tab Columns with names starting with 'ignore' are dropped  
}
One timestamp and one elapsed time column name must be specified.  

The Apache URL is handled partly in the fix data procedure in the config file because it wraps the operation and URL path in one field.  The IIS URL does not need this additional parsing. 
}
\item{logTimeZone}{
The timezone to use to adjust the timestamps in the log.  This is used primarily for IIS logs where the log may be either UTC or local time.  
}
  \item{timeFormat}{
If the timestamp in the log is not in the default for IIS or Apache this can be used to override the timestamp parsing.  The format is the r strptime format.  
}
}
\value{
The function returns a dataframe that contains the contents of the file.  
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
}

logFileName = logFileNamesGetLast(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log")[[1]]

cols = logFileFieldsGetIIS(logFileName)

logdf = logFileRead(logFileName, columnList=cols, 
            logTimeZone = "", timeFormat = "")
}
\keyword{ file }
\keyword{ input }
\keyword{ fields }
\keyword{ columns }
\keyword{ csv }
