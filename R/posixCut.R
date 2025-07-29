#
# posixxctCut - replace system cut.POSIXct to avoid broken round-tripping through 
#       factor/character/POSIXct when grouping by other than whoile hour/minuite etc.  
#
#     Copyright (C) 2025  Greg Hunt <greg@firmansyah.com>
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
posixctCut <- function(timeVector, interval)
{

  stringFormat = "^[[:space:]]*(([[:digit:]]*)[[:space:]]*(week|day|hour|min|sec)[s]?)[[:space:]]*$"
  count = sub(stringFormat, "\\2", interval)
  unit = sub(stringFormat, "\\3", interval)

  if(count == interval)
  {
    stop("cut specification in posixCut ", interval, " is invalid")
  }
  
  count = as.numeric(count)
  if(is.na(count))
    count = 1
  
  scaleFactor = -1
  
  if(unit == "sec")
    scaleFactor = 1 * count
  if(unit == "min")
    scaleFactor = 60 * count
  if(unit == "hour")
    scaleFactor = 60 * 60 * count
  if(unit == "day")
    scaleFactor = 24 * 60 * 60 * count
  if(unit == "week")
    scaleFactor =  7 * 24 * 60 * 60 * count
  
  if(scaleFactor == -1)
    stop("internal error: scaleFactor not set")
  
  return(as.POSIXct(floor(as.numeric(timeVector) / scaleFactor) * scaleFactor))

}