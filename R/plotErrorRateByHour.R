#
# plotErrorRateByHour - bar graph of http code categories by hour 
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
if(getRversion() >= "2.15.1") utils::globalVariables(c("ts","status"))

plotErrorRateByHour <-function (dataFrame) 
{
	
  nhoursperbreak = 1
  nhours = difftime(max(dataFrame$ts,na.rm=TRUE), min(dataFrame$ts, na.rm=TRUE), units = "hours")
  if(nhours > 24)
  {
    nhoursperbreak = as.integer(nhours/24)+1
  }
  
  p = ggplot(dataFrame,aes(as.POSIXct(cut(ts,breaks="hour")),fill=status)) 
	p = p + geom_histogram(binwidth=3600) 
	p = p + scale_x_datetime(breaks = date_breaks(paste(nhoursperbreak,"hour")))
	p = p + theme(axis.text.x = element_text(angle=60,vjust = 1.1, hjust=1.1))
	p = p + ylab("Request Rate and Status by Hour") 
	p = p + xlab("Hour of day") 
	p = p + ggtitle("Count")
	return(p)
}
