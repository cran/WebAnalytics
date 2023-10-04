\name{percentileBaselinePrint}
\alias{percentileBaselinePrint}
\title{Print a \LaTeX table comparing current and baseline values and return a bar graph of the same data 
}
\description{
Calculate quantile values for a supplied numeric list.  This is a wrapper around the R quantile function.
}
\usage{
percentileBaselinePrint(column, 
        baselineColumn, 
        columnNames = c("Delta", "Current", "Baseline", "Percentile")) 
}
\arguments{
  \item{column}{
	a vector of numeric values from the current dataset  The values will be rounded to two decimal places before calculation.  
	}
  \item{baselineColumn}{
	a vector of numeric values from the baseline data.  The values will be rounded to two decimal places before calculation.  
}
  \item{columnNames}{
	names of the columns in the table that is printed by this function.  
	}
}
\value{
Returns a ggplot graph of the data.  
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
# set the files directory name suitable for an R example
configVariableSet("config.workdir", tempdir())
setDTthreads(threads=1)
}

fileNameList = logFileNamesGetAll(dataDirectory=datd)

logdf = logFileListRead(fileNameList, 
          readFunction=logFileRead, 
          columnList=logFileFieldsGetIIS(fileNameList[[1]]))

logbasedf = logFileListRead(fileNameList, 
          readFunction=logFileRead, 
          columnList=logFileFieldsGetIIS(fileNameList[[1]]))
plotWriteFilenameToLaTexFile(
  plotSaveGG(
    percentileBaselinePrint(logdf$elapsed, 
              logbasedf$elapsed, 
              columnNames = c("Delta", "Current", "Baseline", "Percentile"))
    , "xxx")
    )

\dontshow{
# clean up example work directory
unlink(paste0(configFilesDirectoryNameGet(),"/*.jpg"))
}
}
\keyword{ manip }
