\name{logFileNamesGet}
\alias{logFileNamesGet}
\title{Base function for retrieval of file names from a base directory and a list of data directories
}
\description{
The function searches in a list of log file directories for log file names and returns a list of names found.  A typical 
directory topology for log access is to have a number of per-server directories mounted or mapped under some common root
and this function's parameters reflect that.  

Switches are provided to return all or only the lexically last file names in each directory.  Returning the lexically last file name works where a report is scheduled to be run late in a day so it will pick up the current day's file - this works for IIS logs and for typical Apache log rotation schemes. 


}
\usage{
logFileNamesGet(dataDirectory = getwd(), 
            directoryNames=c("."), 
            fileNamePattern=".*[.]log", 
            allNamesMustMatch = TRUE,
            getLastFileName = TRUE)
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
  \item{allNamesMustMatch}{
  when processing files named for the period that they contain (for example a date in a typical IIS log file name) this ensures that 
  the same log data period is processed from each log file directory. This does not guarantee that the content of the log files are complete, it just ensures that 
  the log was written for the period. This check is only applicable when getLastFileName is true.  If there are a number of files returned,
  there could be gaps in logging on one or more servers or servers may have failed over, so it does not make sense to check that the sets of
  logs from each directory are the same.  
  }
  \item{getLastFileName}{
  Returns the lexically last file name from each data directory.  
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
logFileNamesGet(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log", allNamesMustMatch=FALSE)
}
\keyword{ manip }
