\name{logFileListRead}
\alias{logFileListRead}
\title{Given a list of file names, read them as log files
}
\description{
This function calls logFileRead to read the individual log files.  
}
\usage{
logFileListRead(fileNameList, readFunction=logFileRead, columnList=NULL)
}
\arguments{
  \item{fileNameList}{
	A list of character file names 
}
  \item{readFunction}{
This function is called to read the file name.  
}
  \item{columnList}{
The columnList is a list of predefined column names.  See \code{\link{logFileRead}} for the list of valid values. 
}
}
\value{
The function returns a dataframe that is the concatenation (rbind) of the read log files.  
If the default read function is used the data frame will contain the standard column set required by the other functions in this package.
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
setDTthreads(threads = 1)
}

fileNameList = logFileNamesGetAll(dataDirectory=datd)

logdf = logFileListRead(fileNameList, 
          readFunction=logFileRead, 
          columnList=logFileFieldsGetIIS(fileNameList[[1]]))
}
\keyword{ manip }
