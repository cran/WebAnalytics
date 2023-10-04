\name{laTexFilePercentileComparisonsWrite}
\alias{laTexFilePercentileComparisonsWrite}
\title{Write percentile count comparison table  
}
\description{
Writes a LaTeX table listing URLs in decreasing order of request count for a baseline workload compared with a current workload on stdout for incorporation in a LaTeX report

}
\usage{
laTexFilePercentileComparisonsWrite(latest, 
          baseline, 
          headingLaTeX="\\\\section{Transaction Count Percentile Ranking}")
}
\arguments{
  \item{latest}{
	data frame of log records for the latest (test) workload
	}
  \item{baseline}{
	data frame of log records for the baseline workload
	}
  \item{headingLaTeX}{
	LaTeX section heading for this table
	}
}
\value{
Does not return a value.  
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

logFileName = logFileNamesGetLast(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log")[[1]]

cols = logFileFieldsGetIIS(logFileName)

logdf = logFileRead(logFileName, columnList=cols, 
            logTimeZone = "", timeFormat = "")

laTexFilePercentileComparisonsWrite(logdf, 
                logdf)
}
\keyword{ manip }
