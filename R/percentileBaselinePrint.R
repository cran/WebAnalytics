#
# percentileBaselinePrint - print the percentile change over the baseline data and return a variance graph
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
if(getRversion() >= "2.15.1") utils::globalVariables(c("Delta","Percentile"))

percentileBaselinePrint <-function (column, baselineColumn, columnNames = c("Delta", "Current", "Baseline", "Percentile")) 
{
	percentileList=c(0.05, 0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8, 0.85, 0.9, 0.95, 0.96, 0.97, 0.98, 0.99, 1)
	listLen = length(percentileList)
	p = calculatePercentiles(column, percentileList)
	q = calculatePercentiles(baselineColumn, percentileList)
	deltapq = p-q
	d = data.frame(delta = deltapq, current=p, baseline=q, percentile = names(deltapq))
	d$percentile = reorder(d$percentile, 1:length(percentileList))
	names(d) = columnNames
	
	print(xtable(d[,c(4,1,2,3)]),include.rownames=FALSE)

		names(d) = c("Delta", "Current", "Baseline", "Percentile")
	# discard outliers (down to 95th percentile)
	if(abs(deltapq[listLen]) > abs(deltapq[listLen-1]*4))
	{
		listLen = listLen-1
	}
	if(abs(deltapq[listLen]) > abs(deltapq[listLen-1]*4))
	{
		listLen = listLen-1
	}
	if(abs(deltapq[listLen]) > abs(deltapq[listLen-1]*4))
	{
		listLen = listLen-1
	}
	if(abs(deltapq[listLen]) > abs(deltapq[listLen-1]*4))
	{
		listLen = listLen-1
	}
	if(abs(deltapq[listLen]) > abs(deltapq[listLen-1]*4))
	{
		listLen = listLen-1
	}

	thePlot = ggplot(data=d[1:listLen,], aes(y=Delta, x=Percentile)) +
		geom_bar( stat="identity") +
		guides(fill="none")+
		theme(axis.text.x=element_text(angle=60,vjust = 1.1, hjust=1.1))
		
	if(listLen < length(percentileList))
	{
		thePlot = thePlot + ggtitle(paste0("outliers excluded, percentiles above ",names(deltapq[listLen])[1], " not shown"))
	}
	return (thePlot)
}
