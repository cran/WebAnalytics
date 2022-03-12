#
# plotParallelismRateImpactOnResponse 
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
plotParallelismRateImpactOnResponse<-function(b, intervalLength = 600, 
											excludeURLOverall="", includeURLOverall="",
											excludeResponse="",includeResponse="", 
											excludeStatus="",includeStatus="",
											percentileCutoff = 1,
											title="Degree of Parallelism and Response Time", subtitle="")
{
	workingSubtitle = ""
	if(excludeURLOverall != "")
	{
		b = b[which(b$url != excludeURLOverall),]
		workingSubtitle = paste("excluding all", excludeURLOverall)
	}
	if(includeURLOverall != "")
	{
		b = b[which(b$url == includeURLOverall),]
		if(workingSubtitle != "")
		{
			workingSubtitle= paste0(workingSubtitle,", ")
		}
		workingSubtitle = paste0(workingSubtitle,"including only ", includeURLOverall)
	}
	breaksString = paste(intervalLength, "secs")
	o = ISOdatetime(1970,1,1,0,0,0)
	# sequence by seconds
	intervalbase = min(b$ts):max(b$ts)
	intervals = sort(unique(cut(as.POSIXct(intervalbase,origin=o),breaks=breaksString)))
	intervalStart = as.POSIXct(intervals[1],origin=o)
	meanResponse = list()
	meanParallelism = list()
	for( numericInterval in intervals[2:length(intervals)])
	{
		intervalEnd = as.POSIXct(numericInterval,origin=o)
		# end time after start of interval and begin time before end of interval - everything that overlaps the interval 
		c = b[which((b$ts < intervalEnd) & ((b$ts + (b$elapsed/1000)) >= intervalStart)),]
		# there is data
		if(length(c$elapsed) > 0)
		{
			c$startTimeLong = as.numeric(c$ts)
			c[which(c$ts < intervalStart), "startTimeLong"] = as.numeric(intervalStart) 

			c$endTimeLong = as.numeric(c$ts) + (c$elapsed/1000)
			c[which((c$ts + (c$elapsed/1000)) > intervalEnd), "endTimeLong"] = as.numeric(intervalEnd) 

			c$elapsed = (c$endTimeLong - c$startTimeLong)*1000
			
			intervalStart = as.POSIXct(intervalEnd)
		
			workingSet = c
			if(includeResponse != "")
			{
				workingSet = workingSet[which(workingSet$url == includeResponse),]
			}
			if(excludeResponse != "")
			{
				workingSet = workingSet[which(workingSet$url != excludeResponse),]
			}
			if(excludeStatus != "")
			{
				workingSet = workingSet[which(workingSet$status != excludeStatus),]
			}
			if(includeStatus != "")
			{
				workingSet = workingSet[which(workingSet$status == includeStatus),]
			}
			
			meanResponse = append(meanResponse, sum(workingSet$elapsed)/length(workingSet$elapsed))
			# parallelism is number of milliseconds of elapsed time in the interval divided by the duration of the interval in seconds (1000 1ms tx in one second is parallelism degree 1)
			# parallelism is not filtered by status or response type, the response time is plotted varying against the overall parallelism
			#
			meanParallelism = append(meanParallelism,sum(c$elapsed)/(intervalLength * 1000))
		}
	}
	if(percentileCutoff < 1)
	{
		cutoff = quantile(as.numeric(meanResponse), percentileCutoff, type=1, na.rm=TRUE)
		meanParallelism = unlist(meanParallelism[meanResponse < cutoff])
		meanResponse = unlist(meanResponse[meanResponse < cutoff])
	}
	if(includeResponse != "")
	{
		if(workingSubtitle != "")
		{
			workingSubtitle= paste0(workingSubtitle,", ")
		}
		workingSubtitle = paste0(workingSubtitle,"including only response of ", includeResponse)
	}
	if(excludeResponse != "")
	{
		if(workingSubtitle != "")
		{
			workingSubtitle= paste0(workingSubtitle,", ")
		}
		workingSubtitle = paste0(workingSubtitle,"excluding response of ", excludeResponse)
	}
	if(excludeStatus != "")
	{
		if(workingSubtitle != "")
		{
			workingSubtitle= paste0(workingSubtitle,", ")
		}
		workingSubtitle = paste0(workingSubtitle,"excluding status ", excludeStatus)
	}
	if(includeStatus != "")
	{
		if(workingSubtitle != "")
		{
			workingSubtitle= paste0(workingSubtitle,", ")
		}
		workingSubtitle = paste0(workingSubtitle,"including status ", includeStatus)
	}
	if(subtitle != "")
	{
		workingSubtitle = subtitle
	}
	if(length(meanParallelism) < 2 | length(meanResponse) < 2)
	{
		plot(c(1),c(1),  main="insufficient data to plot", sub=workingSubtitle, xlab="Mean Degree of Parallelism", ylab="Mean Response Time (ms)")
	}
	else
	{
		plot(unlist(meanParallelism), unlist(meanResponse),  main=title, sub=workingSubtitle, xlab="Mean Degree of Parallelism", ylab="Mean Response Time (ms)")
	}
}
