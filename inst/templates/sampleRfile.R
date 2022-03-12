\documentclass{webanalytics}
<%
startDate = date()
startCPU = proc.time()

library(WebAnalytics)

scipenOption = options(scipen=999)

setEPS(onefile=TRUE)

configVariablesLoad(fileName=reportParameterFileName)

%>

\author{<%=configVariableGet("config.author")%>}
\projectname{<%=configVariableGet("config.projectName")%>}
\title{<%=configVariableGet("config.documentName")%>}
\securityclass{<%=configVariableGet("config.securityClass")%>}

\begin{document}
\maketitle
\pagebreak
\tableofcontents
\pagebreak
<%
fixDataProcedure<-function(b) { return(b) }

if(configVariableIs("config.fix.data"))
{
	fixDataProcedure=configVariableGet("config.fix.data")
}

if(configVariableIs("config.fix.current.data"))
{
	fixDataProcedure=configVariableGet("config.fix.current.data")
}

fileNames = logFileNamesGetLast(dataDirectory=configVariableGet("config.current.dataDir"),directoryNames=configVariableGet("config.current.dirNames"))

b = fixDataProcedure(
		logFileListRead(
			fileNames
			,columnList=configVariableGet("config.current.columnList")
		)
	)

#str(b)
#print(b[which(is.na(b$ts)),])
#print("===========================================")
#print(b[which(is.na(b$elapsed)),])

	noRequestBytes = TRUE
	noResponseBytes = TRUE
	
	if(any(names(b) == "requestbytes"))
	{
	  noRequestBytes = FALSE
	} else {
	    b$requestbytes = 0 # not in this log, probably Apache
	    noRequestBytes = TRUE
	}
	if(any(names(b) == "responsebytes"))
	{
	  noResponseBytes = FALSE
	} else {
	    noResponseBytes = TRUE
	}
	a = b	

	baselineFileNames = NULL
	
	if(configVariableGet("config.readBaseline") == TRUE)
	{
		if(configVariableIs("config.fix.baseline.data"))
		{
			fixDataProcedure=configVariableGet("config.fix.baseline.data")
		}

	  
baselineFileNames = logFileNamesGetLast(dataDirectory=configVariableGet("config.baseline.dataDir"),directoryNames=configVariableGet("config.baseline.dirNames"))

		baseline = fixDataProcedure(
		  logFileListRead(
		    baselineFileNames
							,columnList=configVariableGet("config.baseline.columnList")
						)
					)

		if(length(baseline$responsebytes) > 0 & length(baseline$requestbytes) < 1)
		{
			baseline$requestbytes = 0 # not in this log, probably Apache
		}
		
	} else {
		baseline = data.frame()
	}

f0<-function(n)
{
	return(format(n,digits=1,nsmall=0,big.mark=","))
}
f1<-function(n)
{
	return(format(n,digits=1,nsmall=1,big.mark=","))
}
f2<-function(n)
{
	return(format(n,digits=2,nsmall=2,big.mark=","))
}
fd<-function(d)
{
	return(as.character(as.POSIXct(d,origin=as.POSIXct("1970/01/01 00:00:00",tz = "GMT"))))
}

#save(b,file="b.Rdata")

mints = min(a$ts)
maxts = max(a$ts)
%>
\chapter[Performance Overview]{Performance Overview}

\section{Log Summary}

\subsection*{Times}

\begin{tabular}{l r }
\hline \\
From  & <%= strftime(mints) %> \\
To &  <%= strftime(maxts) %> \\
 & <%= f1(difftime(maxts, mints, units="auto")) %> \\
\hline 
\end{tabular}

\vspace{\baselineskip}
\subsection*{Record Counts}

\begin{tabular}{l r r r r}
  & Total & Dynamic & Static & Monitoring \\
\hline \\
Requests & <%= f0(length(a$elapsed)) %> & <%= f0(length(a[which(a$url!="Static Content Requests" & a$url!="Monitoring"),]$elapsed)) %> & <%= f0(length(a[which(a$url=="Static Content Requests"),]$elapsed)) %> & <%= f0(length(a[which(a$url=="Monitoring"),]$responsebytes)) %> \\
Mean Elapsed (sec)& <%= f2(mean(a$elapsed)/1000) %> & <%= f2(mean(a[which(a$url!="Static Content Requests" & a$url!="Monitoring"),]$elapsed)/1000) %> & <%= f2(mean(a[which(a$url=="Static Content Requests"),]$elapsed)/1000) %> & <%= f2(mean(a[which(a$url=="Monitoring"),]$elapsed)/1000) %> \\
Total Elapsed (sec) & <%= f0(sum(a$elapsed)/1000) %> & <%= f0(sum(a[which(a$url!="Static Content Requests" & a$url!="Monitoring"),]$elapsed)/1000) %> & <%= f0(sum(a[which(a$url=="Static Content Requests"),]$elapsed)/1000) %> & <%= f0(sum(a[which(a$url=="Monitoring"),]$elapsed/1000)) %> \\
<%
if(noResponseBytes == FALSE)
{
%>
Mean kBytes Out& <%= f2(mean(a$responsebytes,na.rm=TRUE)/1000) %> & <%= f2(mean(a[which(a$url!="Static Content Requests" & a$url!="Monitoring"),]$responsebytes,na.rm=TRUE)/1000) %> & <%= f2(mean(a[which(a$url=="Static Content Requests"),]$responsebytes,na.rm=TRUE)/1000) %> & <%= f2(mean(a[which(a$url=="Monitoring"),]$responsebytes,na.rm=TRUE)/1000) %> \\
Total kBytes Out& <%= f0(sum(a$responsebytes,na.rm=TRUE)/1000) %> & <%= f0(sum(a[which(a$url!="Static Content Requests" & a$url!="Monitoring"),]$responsebytes,na.rm=TRUE)/1000) %> & <%= f0(sum(a[which(a$url=="Static Content Requests"),]$responsebytes,na.rm=TRUE)/1000) %> & <%= f0(sum(a[which(a$url=="Monitoring"),]$responsebytes,na.rm=TRUE)/1000) %> \\
<%
}
%>
\hline
\end{tabular}

\vspace{\baselineskip}
\subsection*{Response Time Percentiles}
<%
a = b[which(b$url!="Static Content Requests" & b$url!="Monitoring"),]

xtableOptions = options(xtable.latex.environments = "")
printPercentiles(a$elapsed/1000, dataName="Response Time (seconds)")
#options(xtable.latex.environments = NULL)
laTeXParagraphWrite()
%>
\section{Response Times by Time - Scatter Plots}
<%
plotWriteFilenameToLaTexFile(plotSave(plotResponseTimeScatter(a$ts, a$elapsed), "overallresponsetimescatterplot.jpg"))
laTeXParagraphWrite()
plotWriteFilenameToLaTexFile(plotSave(plotLogResponseTimeScatter(a$ts, a$elapsed), "overalllogresponsetimescatterplot.jpg"))
%>
\paragraph{}
\section{Response Time Distribution}
<%
plotWriteFilenameToLaTexFile(plotSaveGG(plotFrequencyHistogram(a),"overallresponsetimeshistogram","eps"))
laTeXParagraphWrite()
plotWriteFilenameToLaTexFile(plotSaveGG(plotFrequencyHistogramOutlierCutoff(a,0.99),"cutoverallresponsetimeshistogram","eps"))
%>
\section{Request Status by Hour}
<%
plotWriteFilenameToLaTexFile(plotSaveGG(plotErrorRateByHour(a),"errorrateoverall","eps"))

summaryTable = summaryTxDataFrameCreate(a)

savedBaseline = baseline
baseline = baseline[baseline$url!="Static Content Requests" & baseline$url!="Monitoring",]
if(length(baseline) > 0)
{
%>
\clearpage
\section{Change over baseline} 
Change over baseline includes only dynamic content requests.  If static content and monitoring transactions 
were included they would dilute the 
variation in the 
transaction response time because they are typically quick and typically outnumber the dynamic content requests.  

\begin{tabular}{l r l l l } 
& Count & From & To & Elapsed \\
\hline \\
Baseline  & <%= length(baseline$elapsed) %> & <%= strftime(min(baseline$ts)) %> & <%= strftime(max(baseline$ts)) %> & <%= f1(difftime(max(baseline$ts), min(baseline$ts), units="auto")) %> \\
Current & <%= length(a$elapsed) %>  & <%= strftime(min(a$ts)) %> & <%= strftime(max(a$ts)) %> & <%= f1(difftime(max(a$ts), min(a$ts), units="auto")) %> \\
\hline 
\end{tabular}

<%
plotWriteFilenameToLaTexFile(plotSaveGG(percentileBaselinePrint(a$elapsed/1000, baseline$elapsed/1000),"percentilebaseline","eps"))
}
%>  
\clearpage
\section{Request/Response Size Percentile Breakdown} 
<%
if(noResponseBytes == FALSE){
%>
\paragraph{}Response Sizes, Mean: <%= mean(a$responsebytes, na.rm=TRUE) %> bytes
\paragraph{}
<%
printPercentiles(a$responsebytes/1000, dataName="Response Size (kBytes)")
} else
{
%>
\paragraph{}No response size data in log
<%
}
if(noRequestBytes == FALSE){
%>
\paragraph{}Request Sizes, Mean: <%= mean(a$requestbytes, na.rm=TRUE) %> bytes
\paragraph{}
<%
printPercentiles(a$requestbytes/1000, dataName="Request Size (kBytes)")
} else
{
%>
\paragraph{}No request size data in log
<%
}

%>
\clearpage
\chapter[Top Lists]{Top Lists}
The top lists provide candidates for optimisation.  Transactions that have both high total elapsed time and high 95th percentile time should be the highest 
priority for remediation.  Not all high 95th percentile response time transactions are able to be improved easily and not all high total elapsed 
time transactions can be improved, but there are likely to be some that provide a good return on investment in these lists.  

\section{Top Transactions by 95th percentile Response Time}
<%
summaryTable = summaryTable[order(summaryTable[,1], decreasing=TRUE), ]
summaryTxTablePrint(summaryTable[1:40,c(2,1,4,3)],list(format, f2, f2, f0))
%>
\clearpage
\section{Top Transactions by Aggregate Response Time}
<%
summaryTable = summaryTable[order(summaryTable[,4], decreasing=TRUE), ]
summaryTxTablePrint(summaryTable[1:40,c(2,1,4,3)],list(format, f2, f2, f0))
%>
\clearpage
\section{Top Transactions by Error Rate}
<%
summaryTable = summaryTable[order(summaryTable[,5],summaryTable[,6],summaryTable[,7], decreasing=TRUE), ]
summaryTxTablePrint(summaryTable[1:40,c(2,5,6,7,8,3)])

if(configVariableGet("config.generateTransactionDetails") == TRUE)
{
%>
\clearpage
\chapter[Transaction Data]{Transaction Data}
<%

tnames = sort(unique(b$url))
tnames = tnames[tnames != ""]
tnames = na.omit(tnames)

for (thisName in tnames)
{
	bxdat = b[which(b[ ,"url"] == thisName),]
	if(length(baseline) > 0)
	{
		baselineTxDat = savedBaseline[which(savedBaseline[ ,"url"] == thisName),]
	}
	texname = laTeXEscapeString(thisName) 
   # --------------------------------------------------------------------------------------------------------------------------------------------------
   # --------------------------------------------------------------------------------------------------------------------------------------------------
%>
\hypertarget{<%=digest::digest(thisName,algo="sha1")%>}{}
\section[<%=texname%>]{\urlshorten{<%=texname%>}}
\urlshortenconditionaltext{Path shortened in section heading, full text is:\\\url{<%=texname%>}}

\paragraph{}Requests: <%=length(bxdat$elapsed)%> (<%=strftime(min(bxdat$ts,na.rm=TRUE))%> to <%=strftime(max(bxdat$ts,na.rm=TRUE))%>)
	<%
	printPercentiles(bxdat$elapsed/1000, dataName="Response Time (seconds)")
	if(max(bxdat$elapsed,na.rm=TRUE) > configVariableGet("config.generateGraphForTimeOver"))
	{
%>
\subsection*{Response Time Scatter Plot}
<%	
		plotWriteFilenameToLaTexFile(plotSave(plotResponseTimeScatter(bxdat$ts, bxdat$elapsed), paste0(thisName,"scatterplot.jpg")))
	  laTeXParagraphWrite()
	  plotWriteFilenameToLaTexFile(plotSave(plotLogResponseTimeScatter(bxdat$ts, bxdat$elapsed), paste0(thisName,"logscatterplot.jpg")))
	  %>
\subsection*{Response Time Frequency Distribution}
<%
		plotWriteFilenameToLaTexFile(plotSaveGG(plotFrequencyHistogram(bxdat),paste0(thisName,"responsetimeshistogram"),"eps"))
		if(max(bxdat$elapsed,na.rm=TRUE) > 10000)
		{
			laTeXParagraphWrite()
			plotWriteFilenameToLaTexFile(plotSaveGG(plotFrequencyHistogramOutlierCutoff(bxdat,0.99),paste0(thisName,"cutresponsetimeshistogram"),"eps"))
		}
		if(length(baseline) > 0)
		{
%>
\clearpage
\subsection*{Change over baseline} 
<%
			if(length(baselineTxDat$url) >1) 
			{
				plotWriteFilenameToLaTexFile(plotSaveGG(percentileBaselinePrint(bxdat$elapsed/1000, baselineTxDat$elapsed/1000),paste0(thisName,"percentilebaseline"),"eps"))
			}
			else
			{
				laTeXParagraphWrite("No Baseline Data")
			}
		}
%>
\subsection*{Request Status By Hour}
<%
		plotWriteFilenameToLaTexFile(plotSaveGG(plotErrorRateByHour(bxdat),paste0(thisName,"errorrate"),"eps"))
		laTeXParagraphWrite()
		if(length(baseline) > 0)
		{
			if(length(baselineTxDat$url) >1) 
			{
%>
\subsubsection*{Request Status By Hour in Baseline}
<%
				plotWriteFilenameToLaTexFile(plotSaveGG(plotErrorRateByHour(baselineTxDat),paste0(thisName,"baseerrorrate"),"eps"))
			}
		}
	}
%>
\subsection*{Request Sizes}

<%
if(noRequestBytes == FALSE){
%>
Mean: <%= mean(bxdat$requestbytes,na.rm=TRUE)/1000 %> kBytes
<%
	printPercentiles(bxdat$requestbytes/1000, dataName="Request Size (kBytes)")
}
else
{
%>

No request size data in logs

<%
}
%>
\subsection*{Response Sizes}

<%
if(noResponseBytes == FALSE){
%>
Mean: <%= mean(bxdat$responsebytes,na.rm=TRUE)/1000 %> kBytes
<%
 printPercentiles(bxdat$responsebytes/1000, dataName="Response Size (kBytes)")
}
else
{
%>

No response size data in logs

<%
}
%>
\clearpage
%\pagebreak
<%
}
}
if((configVariableGet("config.useragent.generateFrequencies") == TRUE))
{
%>
\clearpage
\chapter[User Agent (Browser) Frequencies]{Browser Frequencies}
<%
    if(("useragent" %in% names(b))) {
%>
  
Browser frequencies in this report are mainly useful for targeting application testing.  The objective must be to balance 
test cost (number of browsers tested) againt population coverage. For that reason, the report specifies both a
minimum browser family percentage and a cumulative percentage cutoff, for example not spending test 
resources on browsers that represent less than 2 percent of the 
population but aiming for test coverage of 95 percent of visitors.

A high occurrence of hits from User agent family "Other" is likely to indicate use of a monitoring request or heartbeat.  

<%
minPercent = configVariableGet("config.useragent.minimumPercentage")
maxPercentile = configVariableGet("config.useragent.maximumPercentile")
%>

\begin{tabular}{l r }
\hline \\
Minimum Percentage for inclusion  & <%= minPercent %> \\
Cumulative Percentage Cutoff &  <%= maxPercentile %> \\
Exclude "Other" User Agents  &  <%= configVariableGet("config.useragent.discardOther")  %> \\
\hline 
\end{tabular}

\section{User Agent Frequency by Browser Family}
<%
library(uaparserjs)
uadf = ua_parse(a$useragent)
if (configVariableGet("config.useragent.discardOther") == TRUE) 
  uadf = uadf[uadf$ua.family != "Other",]

uaFamily = aggregate(uadf$ua.family, by=list(uadf$ua.family),FUN=length)
totalFamily = sum(uaFamily$x)
uaFamily$pct = 100 * uaFamily$x/totalFamily
uaFamily = uaFamily[order(uaFamily$pct, decreasing=TRUE),]
uaFamily$cpct = cumsum(uaFamily$pct)

names(uaFamily) = c("Browser Family", "Count", "Percent", "Cumulative Percentage")

print(xtable(uaFamily[uaFamily$Percent > minPercent & uaFamily$`Cumulative Percentage`< maxPercentile,]), include.rownames=FALSE)

%>
  \section{User Agent Frequency by Browser Family and Version}
<%
uaVersion = aggregate(uadf$ua.family, by=list(uadf$ua.family, uadf$ua.major),FUN=length)
totalVersion = sum(uaVersion$x)
uaVersion$pct = 100 * uaVersion$x/totalVersion
uaVersion = uaVersion[order(uaVersion$pct, decreasing=TRUE),]
uaVersion$cpct = cumsum(uaVersion$pct)
names(uaVersion) = c("Browser","Version", "Count", "Percent", "Cumulative Percentage")

print(xtable(uaVersion[uaVersion$Percent > minPercent & uaVersion$`Cumulative Percentage`< maxPercentile,]), include.rownames=FALSE)
    } else {
%>
Browser percentage report selected but no useragent data is present.  
<%
    }
}
if(configVariableGet("config.generateDiagnosticPlots") == TRUE)
{
%>
\clearpage
\chapter[Diagnostic Plots]{Diagnostic Plots}
The graphs in this section compare aggregate measures over intervals to explore the relationships between response times, 
parallelism levels and data rates for different types of transaction.  By default the values or 95th percentiles are calculated over ten minute intervals.  

\section{Does the 95th percentile response time respond to request rate?}
<%
  b$one = 1
  if(length(baseline) > 0) 
  {
	baseline$one = 1
  savedBaseline$one = 1
	laTeXParagraphWrite("Current (black) and Baseline (red) Data")
	laTeXParagraphWrite()
  	plotWriteFilenameToLaTexFile(plotSave(plotByRate(b$ts, b$elapsed, b$one, 0.95, "10 mins", xlab="request rate (10 minutes)",ylab="variance from overall 95th percentile response time (milliseconds)",baseTimeCol=savedBaseline$ts, baseDataCol=savedBaseline$elapsed, baseBaseRateCol=savedBaseline$one ),"overallresponsetimeshistogram3","eps"))
  }
  else 
  {
  laTeXParagraphWrite("Current Data")
	laTeXParagraphWrite()
    plotWriteFilenameToLaTexFile(plotSave(plotByRate(b$ts, b$elapsed, b$one, 0.95, "10 mins", xlab="request rate (10 minutes)",ylab="variance from overall 95th percentile response time (milliseconds)"),"overallresponsetimeshistogram2","eps"))
  }
%>
\section{Does response time increase with degree of request parallelism? - Dynamic Content Requests}
<%
  laTeXParagraphWrite()
  plotWriteFilenameToLaTexFile(plotSave(plotParallelismRateImpactOnResponse(b,includeStatus="Success",excludeResponse="Static Content Requests"), "parallelismrate1","eps"))
%>
\subsection*{Excluding 95th percentile outliers}
<%
  plotWriteFilenameToLaTexFile(plotSave(plotParallelismRateImpactOnResponse(b,includeStatus="Success",excludeResponse="Static Content Requests",percentileCutoff=0.95), "parallelismrate1a","eps"))
%>
\section{Do static content redirects get slower with increasing degrees of request parallelism?}
<%
  if(length(b[which(b$url =="Static Content Requests"),"url"] > 0))
  {
    laTeXParagraphWrite("These are redirects for static content, unchanged responses and the like: they represent minimal server service demand, and negligible network time")
    laTeXParagraphWrite()
    plotWriteFilenameToLaTexFile(plotSave(plotParallelismRateImpactOnResponse(b,includeStatus="Redirect",includeResponse="Static Content Requests"), "parallelismrate2","eps"))
%>
\subsection*{Excluding 95th percentile outliers}
<%
    plotWriteFilenameToLaTexFile(plotSave(plotParallelismRateImpactOnResponse(b,includeStatus="Redirect",includeResponse="Static Content Requests",percentileCutoff=0.95), "parallelismrate2a","eps"))
  }
  else
  {
    laTeXParagraphWrite("No Static Content Requests in log data")
  }
%>
\section{Do successful static content requests get slower with increasing parallelism?}
<%
  if(length(b[which(b$url =="Static Content Requests"),"url"] > 0))
  {
    laTeXParagraphWrite("The difference between these and the redirects is mostly network time, network contention should show up here")
    laTeXParagraphWrite()
    plotWriteFilenameToLaTexFile(plotSave(plotParallelismRateImpactOnResponse(b,includeStatus="Success",includeResponse="Static Content Requests"), "parallelismrate3","eps"))
%>
\subsection*{Excluding 95th percentile outliers}
<%
    plotWriteFilenameToLaTexFile(plotSave(plotParallelismRateImpactOnResponse(b,includeStatus="Success",includeResponse="Static Content Requests",percentileCutoff=0.95), "parallelismrate3a","eps"))
  }
  else
  {
    laTeXParagraphWrite("No Static Content Requests in log data")
  }
%>
\section{Do successful static content requests get slower with increasing outbound data rate?}
<%
  if(length(b[which(b$url =="Static Content Requests"),"url"] > 0))
  {
    laTeXParagraphWrite("The difference between these and the redirects is mostly network time, network contention should show up here")
    laTeXParagraphWrite()
    plotWriteFilenameToLaTexFile(plotSave(plotDataRateImpactOnStaticResponse(b),"datastaticresponse","eps"))
  }
  else
  {
    laTeXParagraphWrite("No Static Content Requests in log data")
  }
}


if((configVariableGet("config.generatePercentileRankings") == TRUE) & (length(baseline) > 0))
{
%>
\begin{landscape}
\chapter[Percentile Comparison]{Percentile Comparison}
This chapter is chiefly useful for callibrating test workloads to ensure that the transaction mix in the test workload corresponds reasonably well 
to the mix in the baseline (usually production) workload.  The percentages never exactly match, but the percentages make it possible to see how 
close a match the workload is.  In general it is not necessary to include transactions with very low frequencies of occurrence in a performance test, provided that 
the excluded transaction's response times are examined during development to ensure that they do not have particularly high resource consumption.  

\section[Input Data]{Input Data}
\begin{tabular}{r l l l r r r r}
  & Count & Start Time & End Time & Dynamic & Static & Monitoring & Monitoring Delay\\
 \hline \\
Baseline & <%= f0(length(baseline$elapsed)) %> & <%= fd(min(baseline$ts,na.rm=TRUE)) %> & <%= fd(max(baseline$tsna)) %> &  <%= f0(length(baseline[which(baseline$url!="Static Content Requests" & baseline$url!="Monitoring"),]$elapsed)) %> & <%= f0(length(baseline[which(baseline$url=="Static Content Requests"),]$elapsed)) %> & <%= f0(length(baseline[which(baseline$url=="Monitoring"),]$responsebytes)) %>  & <%= f2((sum(baseline[which(baseline$url=="Monitoring"),]$elapsed)/sum(baseline$elapsed))*100) %>\% \\
Comparison & <%= f0(length(b$elapsed)) %> & <%= fd(min(b$ts)) %> & <%= fd(max(b$ts)) %> &  <%= f0(length(b[which(b$url!="Static Content Requests" & b$url!="Monitoring"),]$elapsed)) %> & <%= f0(length(b[which(b$url=="Static Content Requests"),]$elapsed)) %> & <%= f0(length(b[which(b$url=="Monitoring"),]$responsebytes)) %> & <%= f2((sum(b[which(b$url=="Monitoring"),]$elapsed)/sum(b$elapsed))*100) %>\% \\
\hline
\end{tabular}
<%
	laTexFilePercentileComparisonsWrite(b, baseline)
%>
\end{landscape}
<%
}

if(configVariableGet("config.generateServerSessionStats") == TRUE)
{ 
%>
\chapter[Server and Session Analysis]{Server and Session Analysis}

This chapter provides measures of server load and approximate
session counts by hour. 

<%
  if("serverid" %in% names(a)) 
	{
		t = table(a$serverid)
%>
\section[Server Request Count]{Server Request Count}
<%
		fdft = data.frame(t)
		p = ggplot(fdft, aes(x=Var1, y=Freq))
		p = p + geom_bar(stat="identity")
		#p = p + geom_bar(stat="identity",fill="#DE2D26", colour="#DE2D26")
		p = p + theme(axis.text.x=element_text(angle=60,vjust = 1.1, hjust=1.1))
		p = p + ylab("Request Count") 
		p = p + xlab("Server ID") 
		p = p + ggtitle("Request Count by load balancer server ID")

		plotWriteFilenameToLaTexFile(plotSaveGG(p, "serverreqcount","eps"))
		laTeXParagraphWrite()
		names(fdft) = c("Server ID", "Count")
		summaryTxTablePrint(fdft)
%>
\section[Session Request Counts]{Session Request Counts}
<%
		laTeXParagraphWrite()
		plotWriteFilenameToLaTexFile(plotSave(plot(sort(table(a$jsessionid)),main="Session Length Distribution",xlab="Session",ylab="Request Count"),"sessionlengths","eps"))
		
		b2 = a[order(a$ts),]
		slices = cut(b2$ts, "30 mins")
		sl = as.character(slices)
		slc = as.POSIXct(sl)
		b2$bucket = slc
		sess = (aggregate(b2$jsessionid,list(b2$bucket),  FUN=function(x){length(unique(x))}))

		p = ggplot(sess, aes(x=x)) 
		p = p + geom_bar()
		#p = p + geom_bar(fill="#DE2D26", colour="#DE2D26")
		p = p + ylab("Number of Intervals") 
		p = p + xlab("Number of Sessions") 
		p = p + ggtitle("Session concurrency (30 minute intervals) for cluster")

%>
\section[Cluster Session Concurrency]{Cluster Session Concurrency}
<%
		plotWriteFilenameToLaTexFile(plotSaveGG(p,"concurrencycluster30mins","eps"))
		
		sess$hour = as.POSIXlt(sess$Group.1)$hour
		sessbyhour = aggregate(sess$x,by=list(sess$hour),max)
		names(sessbyhour) = c("Hour", "Mean Sessions")
		summaryTxTablePrint(sessbyhour)
%>
\section[Server Session Concurrency]{Server Session Concurrency}
\subsection*{Histograms of Session Counts}

<%
		sess = (aggregate(b2$jsessionid,list(b2$bucket,b2$serverid),  FUN=function(x){length(unique(x))}))
		p = ggplot(sess, aes(x=x)) 
		p = p + geom_bar()
		#p = p + geom_bar(fill="#DE2D26", colour="#DE2D26")
		#p = p + scale_x_continuous(limits=c(0,ceiling(maxElapsed)+1),breaks=pretty_breaks(n=20))
		p = p + ylab("frequency") 
		p = p + xlab("sessions") 
		p = p + ggtitle("Session concurrency (30 minute intervals) by server ID")
		p = p +facet_wrap(~ Group.2,ncol=3)
		plotWriteFilenameToLaTexFile(plotSaveGG(p,"concurrencyserver30mins","eps"))

		sess$hour = as.POSIXlt(sess$Group.1)$hour
		sessbyhour = aggregate(sess$x,by=list(sess$hour, sess$Group.2),max)
		names(sessbyhour) = c("Hour", "Server", "Max Sessions")
		
		tdata = t(reshape2::dcast(Hour ~ Server, data=sessbyhour, value.var="Max Sessions"))
		tdata[is.na(tdata)] = 0
		attr(tdata,"dimnames")[[1]][1] = "hour"
%>
\newcommand*\rot{\multicolumn{1}{R{90}{1em}}}% 
\newcolumntype{R}[2]{%
    >{\adjustbox{angle=#1,lap=\width-(#2)}\bgroup}%
    l%
    <{\egroup}%
}
\begin{landscape}
\subsection*{Peak Sessions by Hour of Day}

<%		
		print(xtable(t(tdata),digits=1),sanitize.colnames.function = function(n){m = paste0("\\rot{",n,"}");m[n == "hour"] = n[n == "hour"];return(m)},include.rownames=FALSE)		
%>
\end{landscape}
<%		
		
		#summaryTxTablePrint(sessbyhour)
	}
	else
	{
		laTeXParagraphWrite("Server session statistics were selected, but there is no server ID data in the log")
	}
}


%>
\chapter[Report Parameters]{Report Parameters}

Processing Started at <%= startDate %> in <%= gsub("\\\\", "\\\\textbackslash{}",getwd()) %>

\noindent{}Files Processed: 

<% 
cat(gsub("\\\\","\\\\textbackslash{}",paste(format(fileNames),collapse="\n\n")))
if(length(baselineFileNames) > 1) {
  cat(gsub("\\\\","\\\\textbackslash{}",paste(format(baselineFileNames),collapse="\n\n")))
}
%>

\noindent{}Processing time (seconds):
\begin{verbatim}
<%
print(proc.time()-startCPU)
%>
\end{verbatim}

\section[Configuration Variables]{Configuration Variables}
\begin{scriptsize}
\begin{verbatim}
<%
	configVariablesSet = configVariablesAll()
	for(t in configVariablesSet)
	{
		cat(paste(t,"=", paste(format(configVariableGet(t)),collapse="\n    ")))
		cat("\n")
	}
%>
\end{verbatim}
\end{scriptsize}
\section[Package]{Package}
\begin{scriptsize}
\begin{verbatim}
<%
print(packageDescription("WebAnalytics"))
options(scipenOption)
options(xtableOptions)
%>
\end{verbatim}
\end{scriptsize}
\end{document}
