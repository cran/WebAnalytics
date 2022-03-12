#
# plotFrequencyHistogramOutlierCutoff 
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
plotFrequencyHistogramOutlierCutoff <-function (theDf, outlierCutoff) 
{
	# this is here just to suppress the warning about elapsed (in the data frame construction) being a global variable.  
	elapsed=0
	
	if(class(theDf) != "data.frame")
	{
		d = data.frame(elapsed = theDf)
	} 
	else
	{
		d = theDf
	}
	
	divisor = 1000
	if(max(d$elapsed,na.rm=TRUE) < 1000)
	{
		divisor = 1
	}

	threshold = quantile(d$elapsed, outlierCutoff, type=1,na.rm=TRUE)[1]
	d = d[d$elapsed <= threshold,]
	
	maxElapsed = max(d$elapsed/divisor,na.rm=TRUE)
	binOffset = max(floor(maxElapsed/200),0.1)
	
	d$scaledElapsed = d$elapsed/divisor
	p = ggplot(d, aes(x=scaledElapsed)) 
	p = p + geom_histogram(binwidth=binOffset)
	#p = p + geom_histogram(binwidth=binOffset,fill="#DE2D26", colour="#DE2D26")
	#	p = p + scale_x_continuous(limits=c((((maxElapsed/20)/2)*-1)-1,ceiling(maxElapsed)+1),breaks=pretty_breaks(n=20))
	p = p + scale_x_continuous(limits=c(0-binOffset,ceiling(maxElapsed)+1), breaks=pretty_breaks(n=20))
#	p = p + scale_x_continuous(breaks=pretty_breaks(n=20))
	p = p + ylab("Response Time Frequencies") 
	if(divisor == 1)
	{
		p = p + xlab("Response Time (ms)") 
	}
	else
	{
		p = p + xlab("Response Time (sec)") 
	}
	p = p + ggtitle(paste0("Number of Requests, values above ", outlierCutoff * 100, "th percentile (",threshold/1000,") excluded"))
	if(maxElapsed > 99 | binOffset < 1)
	{
		p = p + theme(axis.text.x=element_text(angle=60,vjust = 1.1, hjust=1.1))
	}
	return(p)
}
