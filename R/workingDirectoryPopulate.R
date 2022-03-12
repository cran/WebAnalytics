#
# workingDirectoryPopulate - write report files to local directory and create temp directory 
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
workingDirectoryPopulate <- function (directoryName=".") 
{
	directoryName = sub("(.*)/$","\\1",directoryName)
	if(!file.exists(c(directoryName))[1]){
		dir.create(directoryName,recursive=TRUE)
	}
	
	wkdir = configFilesDirectoryNameGet()
	if(fs::is_absolute_path(wkdir))
	{
    if(!file.exists(wkdir))
      dir.create(wkdir, recursive=TRUE)
	}
	else
	{
	  txdir = paste0(directoryName,"/",configFilesDirectoryNameGet())
	  if(!file.exists(c(txdir))) {
	    # must not require recursion at this point
	    dir.create(txdir,recursive=TRUE)
	  }
	}
	
	localCopy<-function(n, fileType="text") {
		thisFile = paste0(directoryName,"/",n)
		if(file.exists(thisFile))
		{
			timeLt = as.POSIXlt(Sys.time())
			expandedName = paste0(thisFile,".",as.character(julian(Sys.Date())),as.character(timeLt$hour),as.character(timeLt$min),as.character(timeLt$sec))
			if(!file.exists(expandedName))
			{
			  targetFile = file(thisFile, open="rb")
			  sourceFile = file(system.file("templates", n, package=packageName(),mustWork=TRUE),open="rb")
			  
			  if(!all.equal(readBin(targetFile,"raw"), readBin(sourceFile,"raw")))
			  {
			    file.copy(thisFile,expandedName,overwrite=TRUE)
			    warning("existing file ", thisFile, " saved as ", expandedName)
			  }
			  close(sourceFile)
			  close(targetFile)
			}
			else
			{
				warning("file ", thisFile, " could not be saved as ", expandedName, " because it already exists, file overwritten")
			}
		}
		print(paste("file to be copied ", n))
		file.copy(system.file("templates", n, package=packageName(),mustWork=TRUE), directoryName)
	}
	localCopy("makerpt.ps1")
	localCopy("makerpt.sh")
	localCopy("logo.eps")
	localCopy("webanalytics.cls")
	localCopy("sampleRfile.R")
	localCopy("sample.config")
}
