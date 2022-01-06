# 
#     logFileFieldsGetIIS.R - get log fields 
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

logFileFieldsGetIIS <-function(fileName) 
{
	understoodMSFields = data.frame(
		msField = 		c("date", 		"time", 		"cs-uri-stem",	"cs-method", "sc-status", "time-taken",	"cs-bytes",		"sc-bytes",		"c-ip", "cs(User-Agent)"),
		internalField = c("MSTimestamp","MSTimestamp",	"url", 			"httpop",    "httpcode",  "elapsedms", 	"requestbytes", "responsebytes","userip", "useragent"),
		stringsAsFactors=FALSE
	)
	
	sourceLines = readLines(fileName)

	if(length(grep("#Software: Microsoft Internet Information Services", sourceLines)) < 1)
	{
	  stop("log file does not appear to be an IIS log, it does not contain a #Software: line ", fileName)
	}
	
	lines = grep("#Fields:", sourceLines,value=TRUE)
	
	uniqueLineCount = length(unique(lines))
	if(uniqueLineCount < 1)
	{
	  stop("no Fields: specification in IIS log file ", fileName)
	}
	if(uniqueLineCount > 1)
	{
	  stop("more than one unique Fields: line found in log file ",fileName, " Line specifications are:\n", lines)
	}
	
	regList = gregexpr("([^ ]+)",lines[1])
	fieldList = regmatches(lines[1],regList)
	
	fieldList = fieldList[[1]]
	
	if(length(fieldList) < 2) # first entry must be "Fields:"
	{
	  stop("field list not constructed from Fields: line \n", lines[1])
	}

	dtCheck = grep("^date$|^time$", fieldList, value=FALSE)
	if(length(dtCheck) != 2)
	  stop("Fields specification does not include both date and time \n", lines[1])
	dtTimeCheck = grep("^time$", fieldList, value=FALSE)
	if(dtCheck[2] != dtTimeCheck)
	  stop("Date and Time fields are not consecutive in the file \n", lines[1])
	
	constructedFieldList = list()
	for(f in fieldList)
	{
	  if(f != "#Fields:" & f != "date")
	  {
	    internalCandidate = understoodMSFields[understoodMSFields$msField == f,"internalField"]
	    if(length(internalCandidate) == 0)
	      fieldName = paste0("ignored: ",f)
	    else
	      fieldName = internalCandidate[1]
	    constructedFieldList = append(constructedFieldList,c(fieldName)) 
	  }
	}
	return(unlist(constructedFieldList))
}
