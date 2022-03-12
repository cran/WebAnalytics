#
# plotSave - wrap a plot call in device output using the supplied file name
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
plotSave<-function (thePlot, fileID, fileType = "jpg", imageQuality=90, imageDefaultWidth=600, imageDefaultHeight=400) 
{
# the weird thing here is the R evaluation rules, you cannot check the thePlot object before 
# using it after the device is assigned because that is where it gets evaluated (in this case, the 
#  function is called)
#
  if(fileType != "jpg" && fileType != "eps") 
  {
    stop("plotSave parameter fileType was neither jpg nor eps: ", fileType)
  }
	graphicName = paste0(configFilesDirectoryNameGet(), digest::digest(fileID), ".", fileType)
	if("jpg" == fileType)
	{
	  jpeg(filename = graphicName, quality=imageQuality, width=imageDefaultWidth, height=imageDefaultHeight)
	}
	else
	{
	  if("eps" == fileType)
	  {
	    postscript(file=graphicName, horizontal=FALSE)
	  }
	  else
	  {
	    stop("file type is neither eps or jpg:", fileType)
	  }
	}
	# this has to be evaluated here, after the device is set up in order for the function in 
	#   the parameter list to be called
	#
	thePlot
	dev.off()
	return(graphicName)
}

