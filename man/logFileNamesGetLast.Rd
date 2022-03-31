\name{logFileNamesGetLast}
\alias{logFileNamesGetLast}
\title{Get lexically last file names from a list of log directories.  
}
\description{
The function searches in a list of log file directories for log file names and returns a list of names found (the last name in each directory). 
This function does not check that the found file names are all the same from each directory.
This is intended to be used to locate the most recent day's log file for reporting.  
}
\usage{
logFileNamesGetLast(dataDirectory = getwd(), 
  directoryNames=c("."), 
  fileNamePattern=".*[.]log")
}
\arguments{
  \item{dataDirectory}{
	a string containing the root directory under which the log file directories are found
	}
  \item{directoryNames}{
	a list of directory names that is concatenated with the data directory name.  
	This is intended to support the structure where logs are collected into a series of per-server log directories.  
	}
  \item{fileNamePattern}{
	a string containing a regular expression for the log file names that are to be processed
	}
}
\value{
Returns a list of character string file names.  
}
\author{
Greg Hunt <greg@firmansyah.com>
}
\examples{
datd = dirname(system.file("extdata", "compressed.log", package = "WebAnalytics"))
logFileNamesGetLast(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log")
}
\keyword{ manip }
