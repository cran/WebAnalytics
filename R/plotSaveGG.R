#
# plotSaveGG - save a ggplot to a file name
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
plotSaveGG <-function (thePlot, fileID, fileType = "jpg") 
{
  if(fileType != "jpg" && fileType!= "eps") 
  {
    stop("plotSaveGG parameter fileType was neither jpg nor eps: ", fileType)
  }
  if(any(class(thePlot) == "ggplot"))
  {
  	newFileNameString = paste0(configFilesDirectoryNameGet(), digest::digest(fileID),".",fileType )
	  ggsave(filename = newFileNameString, plot=thePlot, width=7,height=(7*2/3))
	  return(newFileNameString)
  }
  else
  {
    stop("plotSaveGG parameter thePlot was not a ggplot object", print(str(thePlot)))
  }
}

