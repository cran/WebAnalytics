#
# plotDataRateImpactOnResponse 
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
plotDataRateImpactOnResponse<-function(dataFrame, filterURL, status)
{
	c = dataFrame[which(dataFrame$url == filterURL & dataFrame$status == status),]
	if(nrow(c) < 1)
	{
	  warning("In plotDataRateImpactOnResponse the filters ", filterURL, " and ", status , " excluded all rows")
	}
	# data rate is divided by 600 to get from 10 minute rate to 1 second rate
	plotByRate(c$posixtimes, c$elapsed, ((dataFrame$responsebytes + dataFrame$requestbytes)/1000)/600, 0.95, "10 mins",baseratetimes = dataFrame$posixtimes, 
	xlab="Data Rate (kB/sec, 10 minute average)", ylab="Difference from overall 95th percentile (milliseconds)", title=paste0("Effect of overall data rate on ",filterURL," response time"))
}
