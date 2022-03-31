#
#     LogFileNamesGet.R - base file acccess function 
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
logFileNamesGet <-
  function (dataDirectory = getwd(),
            directoryNames = c("."),
            fileNamePattern = ".*[.]log",
            allNamesMustMatch = TRUE,
            getLastFileName = TRUE)
  {
    dataDirectory = normalizePath(dataDirectory, mustWork = FALSE)
    if(allNamesMustMatch==TRUE && getLastFileName != TRUE)
    {
      stop("allNamesmustMatch=TRUE requires getLastFileName=TRUE")
    }
    if (!file.exists(dataDirectory))
    {
      stop("Cannot find directory ", dataDirectory)
    }
    fileNames = list()
    for (n in directoryNames)
    {
      nPath = normalizePath(paste(dataDirectory, n, sep = "/" ), mustWork=FALSE)
      if (!file.exists(nPath))
      {
        stop("Directory ",
             n,
             " was not found under ",
             dataDirectory,
             " (\"",
             nPath,
             "\")")
      }
      
      candidateFileNames = as.vector(list.files(nPath, pattern = fileNamePattern, full.names =
                                                  TRUE))
      if (length(candidateFileNames) < 1)
      {
        stop("no files found in directory \"", nPath, "\"")
      }
      if (getLastFileName == TRUE)
      {
        thisName = sort(candidateFileNames, decreasing = TRUE)[1]
        if (allNamesMustMatch)
        {
          for (fn in fileNames)
          {
            if (basename(fn) != basename(thisName))
            {
              stop(
                "File names must be the same in all directories (parameter allNamesMustMatch=TRUE), first name found:",
                fn,
                " is different to the latest name found:",
                thisName
              )
            }
          }
        }
      }
      else {
        thisName = candidateFileNames
      }
      
      fileNames = append(fileNames, thisName)
    }
    return(unlist(fileNames))
  }
