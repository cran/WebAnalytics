\name{WebAnalytics-package}
\alias{WebAnalytics-package}
\alias{WebAnalytics}
\docType{package}
\title{
Tools for web server log performance reporting
}
\description{
The WebAnalytics package is a simple, low-impact way of getting detailed insights into the performance of a web application and of identifying opportunities for remediation.  It generates detailed analytical reports on application response time from web server logs.  

The objective of the package is to extract the maximum value from web server log data and to use that information to identify problems and potential areas for remediation.  It enables you to easily read web server log files; generate histograms, scatter plots and tabular reports of response times, overall and per URL; to generate some diagnostic plots; and to generate a \LaTeX document that can then be formatted as a PDF.  The package supplies scripts and templates to do that document generation.  
}
\details{
\tabular{ll}{
Package: \tab WebAnalytics\cr
Type: \tab Package\cr
Date: \tab 2023-10-04\cr
License: \tab GPL 3\cr
}

This code was used for many years in a performance consulting/toubleshooting context, dealing with systems 
that were not set up with comprehensive monitoring infrastructure, and sometimes with systems that did have monitoring infrastructure but which did not generate useful measures (percentiles are difficult to calculate on stream data, sometimes too little data is retained for longitudinal analysis), or which rolled up performance metrics to mean values over long 
intervals, destroying the short term information in the logs.  For some systems the diagnostic plots were interesting by themselves.  

It is not a debugging tool, it indicates where problems are and where there are behaviours that are unexpected: the tables and histograms identifying multiple code paths that developers may not be aware of, the diagnostic plots indicating contention, the scatter plots indicating short term variations in response time that are indicative of some kind of problem.  All these enable potential fixes to be worked on, and once those fixes are developed, enabling direct measurement of the impact using the baselining graphs and tables.

A sample PDF report can be generated in the current directory, with work files saved in under the R tempdir using the following code fragment:

\preformatted{
library(WebAnalytics)
filesDir = paste0(tempdir(),"/ex")
configVariableSet("config.workdir", filesDir)
workingDirectoryPopulate(".")
pdfGenerate()
}

The generated report provides the following:

\bold{Response Time Overview}
\itemize{
\item Detailed Response Time Percentiles
\item Response Time Change over baseline workload (if a baseline log is supplied and the baseline is read)
\item Request/Response Size Percentile Breakdown 
\item Response Times by Time - Scatter Plot 
\item Response Time Histogram 
\item Request Status by Hour 
\item Top Transactions by 95th percentile response time 
\item Top Transactions by aggregate response time 
\item Top Transactions by error rate
}

This section addresses questions such as
\itemize{
\item How many static, dynamic and monitoring requests are there in the logs?
\item How much of total system processing time is accounted for by static, dynamic and monitoring requests?
\item How much static, dynamic and monitoring data transfer is there?
\item How many requests per hour are made and in what hours?
\item What are the transactions with the highest 95th percentile response times?
\item What are the transactions that account for the most aggregate wait time in the system?
}
The 95th percentile and aggregate wait time tables are useful to identify those tramnsactions that could repay some
performance optimisation.  Anything high in both lists is worth investigating.  


\bold{Transaction Data for each URL}
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
\item How have these metrics changed relative to a baseline set of log data?
}

\bold{Browser Mix Percentages} 
\itemize{
\item Browser family percentiles
\item Browser family and version percentiles
}

These percentages are useful for identifying which browsers and versions need to be tested.  

\bold{Diagnostic Charts}
\itemize{
\item 95th percentile response time by request rate
\item Dynamic Content Response time by degree of request concurrency
\item Static Content Redirect time by degree of request concurrency 
\item Static Content (successful requests) time by request concurrency 
\item Static Content (successful requests) time by outbound data rate
} 

These plots mostly adddress the scalability of the system.  

\bold{Percentile Comparison of transaction mix with baseline reporting period}
\itemize{
\item Input Data stats
\item Transaction Counts and percentages by URL 
\item Transaction Waits and percentages by URL 
}

These are primarily used for callibrating test workloads to ensure that the transaction mix is similar to the production workload, or the planned workload.  

\bold{Server and Session Analysis}
\itemize{
\item Server Request Counts 
\item Session Request Counts
\item Unique Sessions by Hour
}

A function \code{\link{workingDirectoryPopulate}} is provided to populate a working directory with all needed supporting files and a sample \R report file which can be edited as needed.  The working directory contains:

\itemize{
\item \code{sampleRfile.R} - sample report template
\item \code{\link{sample.config}} - configuration file for the report
\item \code{logo.eps} - a 2cm by 2cm logo graphic (a placeholder) in EPS format
\item \code{makerpt.ps1} - PowerShell script to run the report and process the output with \code{xelatex}
\item \code{makerpt.sh} - bash script to run the report and process the output with \code{xelatex} 
\item \code{WebAnalytics.cls} - the report LaTeX class
}

An R function, \code{\link{workingDirectoryPopulate}} will place copies of all necessary files in a directory, already configured to generate a sample PDF report from test data supplied with the package.

The supplied
configuration file \code{\link{sample.config}} read by the report script provides enough flexibility for most purposes.  Switches are provided to turn on or off different sections of the report.  Edit the config file, \code{\link{sample.config}} to update the list of column names and data types (documented in \code{\link{logFileRead}} or use the IIS log utility function \code{\link{logFileFieldsGetIIS}}.  The directory structure that it assumes is that there is a data directory identified in \code{config.current.dataDir} with multiple log directories under it (\code{config.current.dirNames}).  This applies to both current data and the baseline log.  The default behaviour of the script is to read the lexically last file name with a \code{.log} extension from each log directory and it checks that the log names are the same in each directory.  This is consistent with a structure in which logs are regularly copied into a log directory for processing or where some pre-processing is required, for example where the log is being written with a varying number of fields as a result of sme other configuration by network or admin teams.  Additional functions are provided to select all or some files: \code{\link{logFileNamesGet}}, \code{\link{logFileNamesGetAll}}, \code{\link{logFileNamesGetLast}},  and \code{\link{logFileNamesGetLastMatching}} and these can be substituted in the report template as needed.  

There are multiple ways to run \code{xelatex} on the generated template. A bash script and a Powershell script are provided to do that if you have \LaTeX already installed.  Run the sample script and config file that are created in that directory using the command \code{. ./makerpt.sh sample} or  \code{powershell -f makerpt.ps1 sample} to generate a sample PDF from the test data supplied as part of the package.  If you do not have a \LaTeX installation, The R package \CRANpkg{tinytex} can be used to install \LaTeX and a function \code{\link{pdfGenerate}} is provided in this package to do the PDF generation from within R.

The package uses the CRAN package \CRANpkg{brew} to produce the \LaTeX source from a Brew template and comes with its own \LaTeX document class and a blank logo graphic, both of which can be tailored as needed.  

The generated \LaTeX document has been tested with \code{xelatex} and is known not to work with plain LaTeX because of font issues.  

The package requires Apache or IIS log files to contain elapsed times in addition to timestamps, HTTP verbs, HTTP response codes and URLs. In Apache the elapsed time is provided by the \code{\%d} or \code{\%D} format specifier in a log format specification  string.  In IIS the \code{time-taken} field must be added to the log format.  If supplied, the request and response sizes are also used by the report.  For WebSphere applications, adding the JSESSIONID cookie to the log enables server-level session statistics (the server ID is parsed out of the WebSphere JSESSIONID cookie value, if the JSESSIONID cookie is not of the format \code{serverID:sessionID} the server distribution will be represented by a single server. To get session-level information without the cookie being present, it might be possible to use the client IP (depending on the structure of the network), in which case, adding

\preformatted{b$jsessionid = b$userip
b$serverid = 1
}

to the \code{config.fix.data} function, in the sample configuration file, will provide some useful information.  

The \code{config.fix.data} function is used to classify URLS as dynamic (the URL is retained), static or monitoring.  The script depends on the literals that are used and the function must use those literals to identify Static and monitoring requests.  

}

\author{
Maintainer: Greg Hunt \email{greg@firmansyah.com}
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

datd = paste0(tempdir(),"/minconfigtemp")
unlink(datd)
dir.create(paste0(tempdir(),"/minconfigtemp"))
logfile = paste0(datd,"/log.log")
fileConn = gzfile(system.file("extdata", "compressed.log", package = "WebAnalytics"))
writeLines(readLines(fileConn),con=logfile)
close(fileConn)
}
\dontrun{
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
}
\dontshow{
unlink(wkDir,recursive=TRUE)
unlink(filesDir,recursive=TRUE)
}
}