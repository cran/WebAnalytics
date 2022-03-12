\name{WebAnalytics-package}
\alias{WebAnalytics-package}
\alias{WebAnalytics}
\docType{package}
\title{
Tools for web server log performance reporting
}
\description{
The WebAnalytics package is a simple, low-impact way of getting detailed insights into the performance of a web application and of identifying opportunities for remediation.  It generates detailed analytical reports on application response time from web server logs.  
}
\details{
\tabular{ll}{
Package: \tab WebAnalytics\cr
Type: \tab Package\cr
Version: \tab 0.9\cr
Date: \tab 2021-11-21\cr
License: \tab GPL 3\cr
}
The objective of the package is to extract the maximum value from web server log data and to use that information to identify problems and potential areas for remediation.  It enables you to easily read web server log files; generate histograms, scatter plots and tabular reports of response times, overall and per URL; to generate some diagnostic plots; and to generate a \LaTeX document that can then be formatted as a PDF.  The package supplies scripts and templates to do that document generation.  

The generated report provides the following:

Response Time Overview
\itemize{
\item Detailed Response Time Percentiles
\item Response Time Change over baseline workload (if baseline supplied)
\item Request/Response Size Percentile Breakdown 
\item Response Times by Time - Scatter Plot 
\item Response Time Histogram 
\item Request Status by Hour 
\item Top Transactions by 95th percentile response time 
\item Top Transactions by aggregate response time 
\item Top Transactions by error rate
}

This overview addresses questions such as
\itemize{
\item How many static, dynamic and monitoring requests are there in the logs?
\item How much of total system processing time is accounted for by static, dynamic and monitoring requests?
\item How much static, dynamic and monitoring data transfer is there?
\item How many requests per hour are made and in what hours?
\item What are the transactions with the highest 95th percentile response times?
\item What are the transactions that account for the most aggregate wait time in the system?
}

Transaction Data for each URL
\itemize{
\item response time percentiles
\item response time scatter plot by time of day
\item response time histogram
\item error rate by hour
\item and variances over a baseline dataset (useful for comparing before and after release performance)
}

This addresses questions such as
\itemize{
\item What is the clock time distribution of requests and response times for a URL?
\item How many distinct groups of response times are there for a URL? 
\item For the above, how have these metrics changed relative to a baseline set of log data?
}

Browser Mix Percentages 
\itemize{
\item Browser family percentiles
\item Browser family and version percentiles
}

These percentages are useful for identifying which browsers and versions need to be tested.  

Diagnostic Charts
\itemize{
\item 95th percentile response time by request rate
\item Dynamic Content Response time by degree of request concurrency
\item Static Content Redirects by degree of request concurrency 
\item Static Content (successful requests) by request concurrency 
\item Static Content (successful requests) by outbound data rate
} 

These plots mostly adddress the scalability of the system.  

Percentile Comparison of transaction mix with baseline reporting period 
\itemize{
\item Input Data stats
\item Transaction Counts and percentages by URL 
\item Transaction Waits and percentages by URL 
}

These are primarily used for callibrating test workloads to ensure that the transaction mix is similar to the production workload, or the planned workload.  

Server and Session Analysis 
\itemize{
\item Server Request Counts 
\item Session Request Counts
\item Unique Sessions by Hour
}

A function \code{\link{workingDirectoryPopulate}} is provided to populate a working directory with all needed supporting files and a sample \R report file which can be edited as needed.  

\itemize{
\item \code{sampleRfile.R} - sample report template
\item \code{\link{sample.config}} - configuration file for the report
\item \code{logo.eps} - a 2cm by 2cm logo graphic in EPS format
\item \code{makerpt.ps1} - PowerShell script to run the report and process the output with \code{xelatex}
\item \code{makerpt.sh} - bash script to run the report and process the output with \code{xelatex} 
\item WebAnalytics.cls - the report LaTeX class
}

Generally the supplied
configuration file \code{\link{sample.config}} read by the report script is enough for most purposes.

To generate a sample report PDF you need \code{xelatex} installed.  Run the sample script and config file that are created in that directory using the command \code{. ./makerpt.sh sample} or  \code{powershell -f makerpt.ps1 sample} to generate a sample PDF from the test data supplied as part of the package.  

The easiest way to configure the report is by editing the sample config file, \code{\link{sample.config}}.  The log format is described in the config file as a list of column names corresponding with the log file format.  A utility \code{\link{logFileFieldsGetIIS}} is provided to read the list of column names from an IIS log file header.    

The package requires Apache or IIS log files to contain elapsed times in addition to timestamps, HTTP verbs, HTTP response codes and URLs. In Apache the elapsed time is provided by the \code{\%d} or \code{\%D} format specifier in a log format specification  string.  In IIS the \code{time-taken} field must be added to the log format.  If supplied, the request and response sizes are also used by the report.  For WebSphere applications, adding the JSESSIONID cookie to the log enables server-level session statistics (the server ID is parsed out of the WebSphere JSESSIONID cookie value, if the JSESSIONID cookie is not of the format \code{serverID:sessionID} the server distribution will be represented by a single server. To get session-level information without the cookie being present, it might be possible to use the client IP (depending on the structure of the network), in which case, adding

\preformatted{b$jsessionid = b$userip
b$serverid = 1
}

to the \code{config.fix.data} function, in the sample configuration file, will provide some useful information.  

The package uses the CRAN package \CRANpkg{brew} to produce \LaTeX source and comes with its own \LaTeX document class which can be tailored as needed.  

The generated \LaTeX document has been tested with \code{xelatex} and is known not to work with plain LaTeX because of font issues.  

}
\author{
Maintainer: \email{Greg Hunt <greg@firmansyah.com>}
}
\keyword{ 
package 
}
\examples{
\dontshow{
filesDir =  paste0(tempdir(),"/ex")
wkDir = paste0(tempdir(),"/ey")
# set the files directory name suitable for an R example
configVariableSet("config.workdir", filesDir)
# setup the work directory 
workingDirectoryPopulate(wkDir)
}
# get the data file path from the package 
datd = dirname(system.file("extdata", "compressed.log", package = "WebAnalytics"))

# find the *.log files in the directory 
logFileName = logFileNamesGetLast(dataDirectory=datd, 
  directoryNames=c(".", "."), 
  fileNamePattern="*[.]log")[[1]]

# get the columns from an IIS log
cols = logFileFieldsGetIIS(logFileName)

# read the log file as the current data 
logdf = logFileListRead(logFileName, 
          readFunction=logFileRead, 
          columnList=cols)
          
# read a baseline data set 
logbasedf = logFileListRead(logFileName, 
          readFunction=logFileRead, 
          columnList=cols)
  
# compare percentage counts and delays between 
#   baseline and current, useful for load test callibration 
plotWriteFilenameToLaTexFile(
  plotSaveGG(
    # convert elapsed time to seconds
    percentileBaselinePrint(logdf$elapsed/1000, 
              logbasedf$elapsed/1000,    
              columnNames = c("Delta", "Current", "Baseline", "Percentile"))
    , "xxx")
    )

# plot one of the diagnostic graphs
plotParallelismRateImpactOnResponse(logdf, 
includeURLOverall="/QWERTYTest/XRMServices/2011/Organization.svc", 
includeStatus="Success",
percentileCutoff = 0.95)


\dontshow{
unlink(wkDir,recursive=TRUE)
unlink(filesDir,recursive=TRUE)
}
}