#
# pdfGenerate - use Tinytex to generate the PDF
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
pdfGenerate<-function(configFile, templateFile="sampleRfile.R", workDir = ".")
{
  if(!dir.exists(workDir))
  {
    stop(paste("Work directory", workDir, "not found"))
  }
  
  oldwkdir = setwd(workDir)
  if(missing(configFile))
  {
    configFileList = list.files(pattern=".*\\.config",no..=TRUE,ignore.case = TRUE)
    if(length(configFileList) > 1)
    {
      setwd(oldwkdir)
      str(configFileList)
      
      stop(paste("Multiple config files:", paste(configFileList,collapse=","),"in directory", getwd()))
    }
    if(length(configFileList) < 1)
    {
      setwd(oldwkdir)
      stop(paste("no config file in directory", getwd()))
    }
    configFile = configFileList[1]
  }
  if(!file.exists(configFile))
  {
    setwd(oldwkdir)
    stop(paste("Config file", configFile, "not found"))
  }

  if(!file.exists(templateFile))
  {
    setwd(oldwkdir)
    stop(paste("Template file", templateFile, "not found"))
  }

  dateString = format(Sys.time(), format="%Y%m%d%H%M%S")
  
  nameStem = sub("(.*)+\\.config","\\1",configFile, ignore.case = TRUE)
  fileNamePrefix = paste0(nameStem, dateString)
  texFileName = paste0(fileNamePrefix,".tex")

  options(brew.extended.error = TRUE)
  options(show.error.messages = TRUE)
  
  e = new.env()
  with(e,{reportParameterFileName=configFile})
  a = brew::brew(file=templateFile, output=texFileName,envir=e)
  if(exists("a")) 
  {
    if(inherits(a,"try-error"))
    {
      setwd(oldwkdir)
      signalCondition(a)
      return(NULL)
    }
  }
  outputFile = xelatex(texFileName)
  setwd(oldwkdir)
  return(outputFile)
}

