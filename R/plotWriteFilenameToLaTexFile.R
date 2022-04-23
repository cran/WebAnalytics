#
# plotWriteFilenameToLaTexFile - base file acccess function 
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
plotWriteFilenameToLaTexFile <-function (graphicFileName) 
{
  fn = gsub("\\\\","/",graphicFileName)
#	cat(paste0("\\includegraphics[width=0.95\\textwidth,height=0.95\\textwidth]{", graphicFileName, "}\n"))
  cat(paste0("\\includegraphics[width=0.95\\textwidth,height=0.63\\textwidth]{", fn, "}\n"))
}

