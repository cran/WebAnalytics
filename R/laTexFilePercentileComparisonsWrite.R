#
# laTexFilePercentileComparisonsWrite - write LaTeX workload comparison table for baseline and current load
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
laTexFilePercentileComparisonsWrite<-function (latest, baseline, headingLaTeX="\\section{Transaction Count Percentile Ranking}") 
{

addCumulatives<-function(summaryDf)
{
	names(summaryDf) = c("responseAt95th","tx","count","tlWait","serverErrs","clientErrs","redirects")

	summaryDf = summaryDf[!grepl("\\{Monitoring\\}",summaryDf$tx) & !grepl("\\{Static\\\\%20Content\\\\%20Requests\\}",summaryDf$tx),]
	summaryDf = summaryDf[order(summaryDf$count,decreasing=TRUE),]
	summaryDf$cumulativeCount = cumsum(summaryDf$count)
	summaryDf = summaryDf[order(summaryDf$tlWait,decreasing=TRUE),]
	summaryDf$cumulativeWait = cumsum(summaryDf$tlWait)
	summaryDf$percentCount = (summaryDf$count / sum(summaryDf$count))*100
	summaryDf$cumulativePercentCount = (summaryDf$cumulativeCount / sum(summaryDf$count))*100
	summaryDf$percentWait = (summaryDf$tlWait / sum(summaryDf$tlWait))*100
	summaryDf$cumulativePercentWait = (summaryDf$cumulativeWait / sum(summaryDf$tlWait))*100
	return(summaryDf)
}

f0<-function(n)
{
  return(format(n,digits=1,nsmall=0,big.mark=","))
}
f2<-function(n)
{
  return(format(n,digits=2,nsmall=2,big.mark=","))
}

base = addCumulatives(summaryTxDataFrameCreate(baseline))
current = addCumulatives(summaryTxDataFrameCreate(latest))

merged = merge(base,current,by=c("tx"), all=TRUE)

cat(headingLaTeX)
cat("\n\n")
cat("Excludes Static Requests and Monitoring activity (see table above for possible impact).")
cat("\n\n")

t = merged[order(merged$cumulativePercentCount.x,decreasing=TRUE),c("tx","count.x","cumulativePercentCount.x","percentCount.x", "count.y", "percentCount.y")]
t = t[order(t$percentCount.x,decreasing=TRUE),]
t$cumsum = cumsum(t$percentCount.y)
t = t[order(t$cumulativePercentCount.x,decreasing=FALSE),]
names(t) = c("Transaction", "Base\\\\Count", "Base\\\\Cum. Pct.", "Base\\\\Percent\\\\Count", "New\\\\Count", "New\\\\Percent\\\\Count", "New\\\\Cumulative\\\\Percent Count")
t2 = t[,c(1,3,2,4,5,6)]
names(t2) = names(t)[c(1,3,2,4,5,6)]
summaryTxTablePrint(t2,list(format, f2, f0, f2, f0, f2))


cat("\\section{Transaction Wait Percentile Ranking}\n\n")
t = merged[order(merged$cumulativePercentWait.x,decreasing=TRUE),c("tx","tlWait.x","cumulativePercentWait.x","percentWait.x", "tlWait.y", "percentWait.y", "responseAt95th.x", "responseAt95th.y") ]
t = t[order(t$percentWait.x,decreasing=TRUE),]
t$cumsum = cumsum(t$percentWait.y)
t = t[order(t$cumulativePercentWait.x,decreasing=FALSE),]
names(t) = c("Transaction", "Base\\\\Total\\\\Wait", "Base\\\\Cumulative\\\\Pct. Wait", "Base\\\\Percent\\\\Wait", "New\\\\Total\\\\Wait", "New\\\\Percent\\\\Wait", "Base 95th\\\\Percentile\\\\Reponse", "New 95th\\\\Percentile\\\\Reponse")
t2 = t[,c(1,3,2,4,5,6,7,8)]
names(t2) = names(t)[c(1,3,2,4,5,6,7,8)]
summaryTxTablePrint(t2,list(format, f2, f2, f2, f2, f2, f2, f2))

}
