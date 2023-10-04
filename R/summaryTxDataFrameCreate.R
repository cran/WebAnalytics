#
# summaryTxDataFrameCreate - create a summary data frame with embedded LaTeX formatting 
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
summaryTxDataFrameCreate <-function (logDataframe) 
{
	tnames = sort(unique(logDataframe$url))
	tnames = tnames[which(tnames != "")]
	tnames = na.omit(tnames)

	d = data.frame()

	for (thisName in tnames)
	{
		bxdat = logDataframe[which(logDataframe[ ,"url"] == thisName),]
		texName = laTeXEscapeString(thisName)
		d = rbind(d, data.frame(seconds = quantile(round(bxdat$elapsed/1000, 2), 0.95, type = 1, na.rm=TRUE), 
							ref=paste0("\\hyperlink{",digest::digest(thisName,algo="sha1"),"}{\\urlshorten{",texName,"}}"), 
							count=length(bxdat$elapsed), 
							userImpact=sum(bxdat$elapsed)/1000, 
							serverErrors=length(bxdat[bxdat$status=="Server Error",1]), 
							clientErrors=length(bxdat[bxdat$status=="Client Error",1]),
							redirects=length(bxdat[bxdat$status=="Redirect",1]),
							success=length(bxdat[bxdat$status=="Success",1])))
	}
	colnames(d) = c("Response\\\\Time\\\\(95th pctl sec)", "Transaction", "Count", "Total Wait\\\\(sec)", "Server\\\\Errors", "Client\\\\Errors", "Redirect", "Success")
	return(d)
}
