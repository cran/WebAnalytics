#
# plotByRate - plot a data column against a rate column for specified times - specified as individual columns  
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
plotByRate<-function(timecol, datacol, baseratecol, percentile, breaksString, baseratetimes = timecol, xlab = "Rate", ylab="Variation from overall 95th percentile", title="", baseTimeCol = NULL, baseDataCol=NULL, baseBaseRateCol = NULL, outlierPercentile=NULL ) 
{
	summariseDf<-function(tcol, brtcol, brcol, dcol, pctile, brkstring)
	{
		ddf = data.frame(time=tcol,data=dcol,type="dataofinterest")
		bdf = data.frame(time=brtcol,data=brcol,type="background")
		
		overalldf = rbind(ddf,bdf)
		
		# intervals
		tens = cut(overalldf$time,breaks=brkstring)
		# work out the baseline percentile in the data values of interest 
		baseline = quantile(dcol,c(pctile),type=1,na.rm=TRUE)[1]
		# aggregate the variation using the time base that corresponds with the data set and sum the background value over the interval
		variancedf = aggregate(overalldf[,"data"] - baseline, by=list(tens,overalldf$type), FUN=function(a) {return(quantile(a,c(pctile),type=1,na.rm=TRUE)) } )
		ratedf = aggregate(overalldf[,"data"],by=list(tens,overalldf$type),FUN=sum) 
#		???????????????????? filter by type after aggregation to get intervals to match 
		d = merge(variancedf[which(variancedf$Group.2 == "dataofinterest"),], ratedf[which(ratedf$Group.2 == "background"),], by="Group.1")
		d2 = d[,c(1,3,5)]
		names(d2) = c("time", "variation", "rate")
		return(d2[order(d2$rate),])
	}

	if(length(timecol) < 2)
	{
		plot(1,1,main="Insufficient time data to plot in plotByRate")
		return()
	}

	if(length(baseratecol) < 2)
	{
	  plot(1,1,main="Insufficient rate data to plot in plotByRate")
	  return()
	}
	
	d = summariseDf(timecol, baseratetimes, baseratecol, datacol, percentile, breaksString)
	if(length(d$rate) < 2)
	{
		plot(1,1,main="Insufficient data to plot in plotByRate")
		print(xtable(d))
		return()
	}
	
	if(!is.null(outlierPercentile))
	{
		offsetVariation = abs(min(d$variation))
		# move up to make everything positive
		workingVariation = d$variation + offsetVariation
		# calculate percentile and then move down again 
		cutoff = (quantile(workingVariation, c(outlierPercentile), type=1,na.rm=TRUE)[1])-offsetVariation
		# discard the uninteresting data
		d = d[d$variation <= cutoff,]
	}
	
	if(!is.null(baseTimeCol))
	{
		dbase = summariseDf(baseTimeCol, baseTimeCol, baseBaseRateCol, baseDataCol, percentile, breaksString)

		if(!is.null(outlierPercentile))
		{
			if(1/(1-outlierPercentile) < length(dbase$variation))
			{
				offsetVariation = abs(min(dbase$variation))
				workingVariation = dbase$variation + offsetVariation
				cutoff = (quantile(workingVariation, c(outlierPercentile), type=1,na.rm=TRUE)[1])-offsetVariation
				dbase = dbase[which(dbase$variation < cutoff),]
			}
		}
		plot(d$rate, d$variation, type="p", xlab=xlab, ylab=ylab, main=title, ylim=c(min(dbase$variation, d$variation), max(dbase$variation, d$variation)))
		lines(dbase$rate, dbase$variation, type="p", col="red")
	}
	else
	{
		plot(d$rate, d$variation, type="p", xlab=xlab, ylab=ylab, main=title)
	}
	
#	if(!is.null(baseTimeCol))
#	{
#		tens = cut(baseTimeCol,breaks=breaksString)
#		basetens = cut(baseTimeCol,breaks=breaksString)
#		baseline = quantile(baseDataCol,c(percentile),type=1,na.rm=TRUE)[1]
#	
#		variancedf = aggregate(baseDataCol - baseline, by=list(tens), FUN=function(a) {return(quantile(a,c(percentile),type=1,na.rm=TRUE)) } )
#		d = merge(variancedf, ratedf, by="Group.1")
#		names(d) = c("time", "variation", "rate")
#		d = d[order(d$rate),]
#		lines(dbase$rate, dbase$variation, type="l", col="red")
#	}
}
