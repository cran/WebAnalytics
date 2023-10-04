\name{logFileFieldsGetIIS}
\alias{logFileFieldsGetIIS}
\title{Get field names from an IIS log file}
\description{
Retrieves and validates the log fields from an IIS Log file.  An IIS log file contains one or more comments records (leading hash) that identify the software that produced the log and the fields that were written.  There may be multiple fields records, the code does not attempt to handle the case where different fields are written in different parts of the log.  The MS names are mapped to the names used by this package. 

Fields that the package does not use have names which begin with 'ignored: ' and these are dropped when the file is read.  
}
\usage{
logFileFieldsGetIIS(fileName)
}
\arguments{
  \item{fileName}{
  name of the file to be examined
	}
}
\value{
Returns a list of field names mapped to the   
}
\author{
Greg Hunt <greg@firmansyah.com>
}
\examples{
logFileFieldsGetIIS(system.file("extdata", "compressed.log", package = "WebAnalytics"))
}
\keyword{ manip }
