#
# calculatePercentiles - calculate percentiles based on rounded values (to limit the number of 
#   decimal places in the output)
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
calculatePercentiles <-function (column, percentileList=c(0.7, 0.8, 0.9, 0.95, 0.96, 0.97, 0.98, 0.99, 1)) 
{
	if(any(!is.numeric(column))) 	{
		stop("column supplied to calculatePercentiles is not numeric")
		return()
	}
#	columnRange = max(column,na.rm=TRUE) - min(column,na.rm=TRUE)
#	if(columnRange > 100) 	{
#		roundingDecimalPlaces = 0
#	} else if(columnRange > 10) 	{
#		roundingDecimalPlaces = 1
#	} else 
	roundingDecimalPlaces = 2
	
	return(quantile(round(column,roundingDecimalPlaces), percentileList, type=1, na.rm=TRUE))
}
