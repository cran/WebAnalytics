#
# laTeXEscapeString - escape a string so that it can be embedded in a LaTeX document 
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
laTeXEscapeString <-function (nameString) 
{
  
  characterList = strsplit(nameString, "")[[1]]
  
  escapedChars = strsplit("-_#$&%{}", "")[[1]]
  
  recordFn = function(ch){
    if(ch %in% escapedChars)
      return(paste0("\\", ch))
    if( ch == "~")
      return("\\textasciitilde{}")
    if( ch == "^")
      return("\\textasciicircum{}")
    if( ch == "\\")
      return("\\textbackslash{}")
    return(ch)
  }
  
return ( paste(unlist(lapply(characterList, FUN=recordFn)), collapse=""))

}