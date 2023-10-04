\name{logFileNamesGetAll}
\alias{logFileNamesGetAll}
\title{Get the list of file names matching a regex (default picks .log files) from a list of log directories
}
\description{
The function returns a list of names found in a list of directories.  
}
\usage{
logFileNamesGetAll(dataDirectory = getwd(), 
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
logFileNamesGetAll(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log")
}
\keyword{ manip }
