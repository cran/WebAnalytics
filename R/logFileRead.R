#
# logFileRead - read access log and conmstruct data frame 
#
#     Copyright (C) 2021  Greg Hunt <greg@firmansyah.com>
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#

logFileRead <-function(fileName, columnList=c("MSTimestamp", "clientip", "url", "httpcode", "elapsed"), logTimeZone = "", timeFormat = "") 
{
	columnDefinitions = data.frame(
		name =    c("ApacheTimestamp", "MSTimestamp", "servername", "serverip",  "httpop",    "url",       "parms",     "port",    "username",  "userip",    "useragent", "httpcode", "windowscode", "windowssubcode",   "responsebytes", "requestbytes", "elapsedms", "elapsedus", "elapseds", "ignore",    "jsessionid"),
		type =    c("character",       "character",   "character",  "character", "character", "character", "character", "numeric", "character", "character", "character",   "numeric",  "character",   "character",        "numeric",       "numeric",      "numeric",   "numeric",   "numeric",  "character", "character"), 
		minimum = c(FALSE,             FALSE,         FALSE,        FALSE,       FALSE,       TRUE,        FALSE,       FALSE,     FALSE,        FALSE,      FALSE,         TRUE,       FALSE,         FALSE,              FALSE,           FALSE,          FALSE,       FALSE,       FALSE,      FALSE,        FALSE)                                                   
	)
	
	minimumColumnList = columnDefinitions[columnDefinitions$minimum,]$name
	baseColumnList = columnDefinitions$name
	
	# check that the minimum column set is present 
	if(!setequal(intersect(minimumColumnList, columnList), minimumColumnList)) {
		stop("specified column set does not include all of the minimum required columns: ",toString(intersect(setdiff(minimumColumnList, columnList), minimumColumnList)), " missing")
	}
	if(!(is.element("ApacheTimestamp", columnList) | is.element("MSTimestamp", columnList))) {
		stop("specified column set does not include a timestamp: ApacheTimestamp or MSTimestamp")
	}
	if(!(is.element("elapsedms", columnList) | is.element("elapseds", columnList)| is.element("elapsedus", columnList))) {
		stop("specified column set does not include a duration: elapsedms, elaspedus, elapseds")
	}
	
	# check that the elements outside of the minimum set are either in the extended set or have names of the format "ignore.*"
	ignores = setdiff(columnList, baseColumnList)
	for(i in ignores) {	
		if(substr(i,1,6) != "ignore")
		{
			stop("column name \"",i,"\" is neither a defined column name nor begins with the text 'ignore'")
		}
	}
	# ensure that all columns to be dropped are here
	ignores = append(ignores, grep( "ignore.*",columnList, value=TRUE))

	wkTypeList = list()
	wkColumnList = list()
	isMSTimestamp = FALSE
	isApacheTimestamp = FALSE
	for(i in columnList) 
	{
		if(i == "ApacheTimestamp") {
			wkColumnList = append(wkColumnList, c("apachetimestamp", "apachetzoffset"))
			wkTypeList = append(wkTypeList, c("character", "character"))
			isApacheTimestamp = TRUE
		}else {
			if(i == "MSTimestamp") {
				wkColumnList = append(wkColumnList, c("msdatepart", "mstimepart"))
				wkTypeList = append(wkTypeList, c("character", "character"))
				isMSTimestamp = TRUE
			}
			else {
				if(substr(i,1,6) == "ignore")
				{
					wkColumnList = append(wkColumnList, i)
					wkTypeList = append(wkTypeList, c("character"))
				}
				else
				{
					wkColumnList = append(wkColumnList, i)
					wkTypeList = append(wkTypeList, as.character(columnDefinitions[columnDefinitions$name == i,]$type))
				}
			}
		}
	}
	#message("column list being read")
	#message(wkColumnList)
	# logRecs = withCallingHandlers(read.table(fileName, 
	#                               header=FALSE, 
	#                               quote="\"'", 
	#                               col.names = wkColumnList,
	# 									            colClasses = wkTypeList,
	# 									            na.strings="-",
	# 									            stringsAsFactors = TRUE), # more minimising the memory footprint
	logRecs = withCallingHandlers(data.table::fread(file=fileName,
	                              header=FALSE,
	                              #sep=" ",
	                              # quote="\"'",
	                              col.names = unlist(wkColumnList),
										            colClasses = unlist(wkTypeList),
										            na.strings="-",
										            stringsAsFactors = TRUE), 
	
#	logRecs = withCallingHandlers(
	
	# readrcolTypeSpec = ""
	# for(typechar in wkTypeList)
	# {
	#   if(typechar == "character")
	#     thischar = "c"
	#   if(typechar == "numeric")
	#     thischar = "i"
	#   readrcolTypeSpec = paste0(readrcolTypeSpec, thischar )
	# }
	#   logRecs = readr::read_delim(fileName,
	#                                                        delim = " ",
	#                                                        quote = "\"",
	# 									                       escape_backslash = TRUE,
	# 									                       col_names = FALSE,
	# 									                       col_types = readrcolTypeSpec,
	# 									                       na = c("-"),
	# 									                       comment = "#",
	# 									                       progress=FALSE)
										                                          error=function(e)
										{
											message("")
											message("Error Trapped reading data file:")
											message(toString(e))
											message("Columns: ",toString(wkColumnList))
											message("Types: ",toString(wkTypeList))
											colCount = length(wkColumnList)
											fieldCounts = count.fields(fileName)
											distinctCountRows = which(!duplicated(fieldCounts))
											if(length(distinctCountRows) > 1)
											{
												message("Different Field Counts (", toString(unique(fieldCounts)),") found in file ", fileName, " first instances only shown")
												for(r in distinctCountRows)
												{
													message("Row: ", r)
													recs = readLines(fileName, n=r+1)
													message(recs[r])
												}
											} else {
												if(any(length(wkColumnList) != fieldCounts))
												{
													message("The number of fields in the file (", toString(unique(fieldCounts)), ") does not match the number implied by the column list (", length(wkColumnList), ")")
												}
											}
											#return()
											stop(e)
										}
				)
			
	#print(wkTypeList)
#	warning(readr::problems(logRecs))
#	readr::stop_for_problems(logRecs)
	
	logRecs = as.data.frame(logRecs)
	
	names(logRecs) = wkColumnList
	
	#print(str(logRecs))	
	
	# ensure that all columns to be dropped are here, pick them up from the dataframe columns 
	#   because the column names get modified from their original forms when they are applied to
	#   the data frame
	#
	
	ignores = append(ignores, grep( "ignore.*",names(logRecs), value=TRUE))
	
	# drop them asap to hold down the memory footprint 
	logRecs = logRecs[,!(names(logRecs) %in% ignores)]
	
	if(is.element("elapsedms",columnList)){
		logRecs$elapsed = logRecs$elapsedms
		ignores = append(ignores,"elapsedms")
	}
	if(is.element("elapsedus",columnList)){
		logRecs$elapsed = logRecs$elapsedus/1000
		ignores = append(ignores,"elapsedus")
	}
	if(is.element("elapseds",columnList)){
		logRecs$elapsed = logRecs$elapseds*1000
		ignores = append(ignores,"elapseds")
	}
	
	if(is.element("jsessionid", columnList)){
		logRecs$serverid = sub("[^:]*:(.*)","\\1", logRecs$jsessionid)
	}
	
	if(isMSTimestamp) {
		if(timeFormat == "") {
			timeFormat = "%Y-%m-%d %H:%M:%S"
		}
		
		if(logTimeZone != "") {
			logRecs["ts"] = as.POSIXct(as.POSIXlt(as.POSIXct(paste(logRecs$msdatepart,logRecs$mstimepart), tz=logTimeZone, timeFormat ),tz=""))
		}
		else {
			logRecs["ts"] = as.POSIXct(paste(logRecs$msdatepart, logRecs$mstimepart), tz="", timeFormat )
		}
		ignores = append(ignores, "msdatepart")
		ignores = append(ignores, "mstimepart")
	}
	
	if(isApacheTimestamp)
	{
		if(timeFormat == "") {
			timeFormat = "[%d/%b/%Y:%H:%M:%S"
		}

		if(logTimeZone != "") {
			logRecs["ts"] = as.POSIXct(as.POSIXlt(as.POSIXct(logRecs$apachetimestamp, tz=logTimeZone, timeFormat),tz=""))
		}
		else {
			logRecs["ts"] = as.POSIXct(logRecs$apachetimestamp, "", timeFormat)
		}
		ignores = append(ignores, "apachetimestamp")
		ignores = append(ignores, "apachetzoffset")
	}
	
	logRecs$status = "Unknown"
	logRecs[logRecs$httpcode >= 100,"status"] = "Informational"
	logRecs[logRecs$httpcode >= 200,"status"] = "Success"
	logRecs[logRecs$httpcode >= 300,"status"] = "Redirect"
	logRecs[logRecs$httpcode >= 400,"status"] = "Client Error"
	logRecs[logRecs$httpcode >= 500,"status"] = "Server Error"
	logRecs[logRecs$httpcode >= 600,"status"] = "Unknown"
	
	logRecs = logRecs[,!(names(logRecs) %in% ignores)]

	return(logRecs)
}
