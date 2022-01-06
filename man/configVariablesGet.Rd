\name{configVariablesLoad}
\alias{configVariablesLoad}
\alias{configVariableGet}
\alias{configVariableIs}
\alias{configVariablesAll}
\alias{configVariableSet}
\alias{sample.config}
\title{Read a configuration file and store the variables
}
\description{
These are functions to read, validate and execute a report configuration file placing its output as a series of variables in a hidden scope; they also access and check existence of the variables.  Variables whose names begin 'config.' will be printed at load time along with their values.  
}
\usage{
configVariablesLoad(fileName="report.config")
configVariableGet(name)
configVariableIs(name)
configVariablesAll()
configVariableSet(name, value)
}
\arguments{
  \item{fileName}{
	The name of the configuration file
	}
  \item{name}{
	The name of a variable from the config file. 
	}
  \item{value}{
	The value to be assigned to the config variable name.  
	}
}
\details{
The configuration file is an R script that is intended to be used to define the variables and helper functions that control the supplied sample report script.  The config file may be executed more than once as part of validating its content.  

String values in the config file should be quoted using double quote characters. Lists of values are written using the R \code{c()} function, for example \code{c("a","b")} 

Switches controlling behaviour 
\describe{
\item{\code{config.projectName}}{

The Project name for the cover page of the document.  This is also printed on the internal page headers.
\itemize{ 
\item Required
\item No Default Value
}
}
\item{\code{config.documentName}}{

The name to be printed on the document cover page.
\itemize{ 
\item Required
\item No Default value
}
}
\item{\code{config.current.dataDir}}{
Data is assumed to be stored in a directory hierarchy, with a root directory and a series of child directories corresponding with the individual web servers, this variable specifies the root directory of that hierarchy.  For example a directory structure might be a series of server specific logs under \code{/var/logs/apache}, with the individual servers' logs being located in \code{/var/logs/apache/server1}, \code{/var/logs/apache/server2} and \code{/var/logs/apache/server3}.  the data dir in this case is \code{/var/logs/apache} with the \code{config.current.dirNames} being specified as \code{c("server1", "server2", "server3")}.
\itemize{ 
\item Required
\item No Default Value
}
}
\item{\code{config.current.dirNames}}{
This is the list of child directory paths, often corresponding with a list of server names, it must be a concatenation of strings, for example \code{c("PRODMAW1","PRODMAW2")}.  
Multiple directory names can be coded here: \code{c("PRODMAW1/app1","PRODMAW2/app1")}.
\itemize{ 
\item Required
\item No Default Value
}
}
\item{\code{config.current.columnList}}{
The list of column names in the log file, for example \code{c("Apache", "elapsedus", "jsessionid")}.  See \code{\link{logFileRead}} for the list of valid column names.  The name \code{Apache} is an abbreviation for the Apache common log format: \code{c("userip", "ignored column 1", "username", "ApacheTimestamp", "url", "httpcode", "responsebytes")}
\itemize{
\item Required 
\item No Default Value
}
}
\item{\code{config.readBaseline}}{ 
Read a baseline log to be compared with current behaviour. Valid values are either \code{TRUE} or \code{FALSE}. 
\itemize{
\item Optional 
\item Default value: \code{FALSE}
}
}
\item{\code{config.baseline.dataDir}}{
The root directory for the baseline data files 
\itemize{
\item Must be supplied if \code{config.readBaseline=TRUE} 
\item No Default Value
}
}
\item{\code{config.baseline.dirNames}}{ 
The list of baseline log server-specific directories, usually a list of server names, it must be a concatenation of strings, for example \code{c("PRODMAW1","PRODMAW2")} 
\itemize{
\item Must be specified if \code{config.readBaseline=TRUE} 
\item No Default Value, 
}
}
\item{\code{config.baseline.columnList}}{
The list of columns to be read.  It is the baseline version of \code{config.current.columnList} 
\itemize{
\item Must be specified if \code{config.readBaseline=TRUE}
\item No Default Value
}
}
\item{\code{config.generateGraphForTimeOver}}{
Response time graphs and histograms are generated for URLs whose maximum elapsed time exceeds this number of milliseconds 
\itemize{
\item Optional 
\item Default Value: 10000
}
}
\item{\code{config.generateServerSessionStats}}{
Generate histograms and counts of requests by server.  These are only generated if \code{jsessionid} is also one of the column names in the current data 
\itemize{
\item Optional 
\item Default Value: \code{TRUE}
}
}
\item{\code{config.generatePercentileRankings}}{
Generate tables that compare frequencies and total elapsed times of URLs in the baseline and current data.  Intended to be used for calibrating performance test workloads 
\itemize{
\item Optional 
\item Default Value: \code{FALSE}
}
}
\item{\code{config.fix.data}}{
An R function definition that is used to adjust the data read from the log files.  This is provided in the sample report configuration file.  The function must categorise records using the literals \code{"Static Content Requests"} and \code{"Monitoring"}.  The function supplied in the sample.config file created by \code{\link{workingDirectoryPopulate}} is a good starting point and can be used to subset or correct the log data as it is read to focus on a smaller subset of records.   
\itemize{
\item Optional 
\item No Default Value 
}
}
\item{\code{config.fix.current.data}}{
The function to be used to adjust baseline data if different cleaning functions are to be applied to current and baseline data 
\itemize{
\item Optional
\item No Default Value
}
}
\item{\code{config.fix.baseline.data}}{
The function to use if different functions are to be applied to current and baseline data
\itemize{
\item Optional
\item Default value: \code{config.fix.current.data}
}
}
\item{\code{config.tempdir}}{
The name of the temp dir to be used for storage of generated graphics.
\itemize{
\item Optional
\item Default Value: ./txdata/
}
}
\item{\code{config.author}}{
Name of the author of the report.  Displayed on the default first page and in the page footer.   
\itemize{
\item Optional
\item Default Value: Author
}
}
\item{\code{config.securityClass}}{
The security classification of the document.  Displayed on the default first page and in the page footer.
\itemize{
\item Optional
\item Default Value: Commercial-In-Confidence
}
}
}
}
\value{
configVariableIs returns a boolean to indicate existence of a named variable
configVariableGet returns the value of the variable
configVariableAll returns a list of all variables
configVariableSet does not return a value
}
\author{
Greg Hunt <greg@firmansyah.com>
}
\examples{
\dontshow{
# setup for build environment 
configVariableSet("config.workdir", paste0(tempdir(),"/","txdata"))
workingDirectoryPopulate(paste0(tempdir(),"/xx"))
}
configVariablesLoad(fileName=paste0(tempdir(),"/xx/sample.config"))
if(configVariableIs("config.documentName"))
{
  print(configVariableGet("config.documentName"))
}
allvars = configVariablesAll()
\dontshow{
# clean up after example
unlink(paste0(tempdir(),"/xx"),recursive=TRUE)
}
}
\seealso{
\code{\link{workingDirectoryPopulate}}
\code{\link{logFileRead}}
\code{\link{logFileListRead}}
}
\keyword{ manip }
