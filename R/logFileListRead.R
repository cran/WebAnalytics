#
# logFileListRead - read list of files igven a list of names
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
logFileListRead<- function (fileNameList, readFunction=logFileRead, columnList=NULL) 
{
	adjustedColumnList = list()
	for(col in columnList)
	{
		if(col == "Apache")
		{
			col = c("userip", "ignored column 1", "username", "ApacheTimestamp", "url", "httpcode", "responsebytes")
		}
		adjustedColumnList = c(adjustedColumnList, col)
	}	
	df = data.frame()
	for(fileName in fileNameList)
	{
		df = rbind(df, readFunction(fileName, columnList=adjustedColumnList))
	}
	return(df)
}
