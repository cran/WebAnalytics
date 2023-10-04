#
# summaryTxTablePrint - format and print a transaction summary data frame 
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
summaryTxTablePrint <-function (dataFrame, formatFunctions=NULL) 
{
  cat("\\begingroup\\footnotesize\n")
  cat("\\begin{longtable}")
  
  formatString = ""
  for (col in dataFrame) 
  {
    if(typeof(col) == "character")
    {
      if(formatString == "")
      {
        formatString = paste0(formatString,"p{0.6\\textwidth}")
      }
      else
      {
        formatString = paste0(formatString,"l")
      }
    }
    else
    {
      formatString = paste0(formatString,"r")
    }
  }
  cat("{",formatString,"}\n")
  cat("\\hline\n")
  
  headings = names(dataFrame)
  headingStrings = sub("([^\\]*)[\\]*.*","\\1", headings)
  while(paste(headingStrings,collapse="") != "")
  {
    headingLine = paste(format(headingStrings),collapse=" & ")
    cat(headingLine, " \\\\\n")    
    headings = sub("[^\\]*[\\]*(.*)", "\\1", headings)
    headingStrings = format(sub("([^\\]*)[\\]*.*","\\1", headings))
  }
  cat("\\hline \\endhead  \\hline")
  
  for(n in 1:nrow(dataFrame)) 
  {
    if(any(!is.na(dataFrame[n,]))) 
    {
      if(is.null(formatFunctions))
        cat(paste(format(dataFrame[n,]),collapse=" & "),"\\\\")
      else
      {
        formattedColumns = list()
        for(i in 1:length(dataFrame[n,]))
        {
          formattedColumns = append(formattedColumns, formatFunctions[[i]](dataFrame[n,i]))
        }
        cat(paste(formattedColumns,collapse=" & "),"\\\\")
      }
    }
  }
  cat("\\hline")
  cat("\\hline")
  cat("\\end{longtable}")
  cat("\\endgroup")

}
