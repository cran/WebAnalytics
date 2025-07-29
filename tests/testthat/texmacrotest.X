\documentclass{webanalytics}
<%
message(Sys.time(), " start of report processing ")	

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

  \section[/aaaa/bbbb/cccc/dddd/eeee/ffff]{\urlshorten{/aaaa/bbbb/cccc/dddd/eeee/ffff}}
  
%  \urldef{\webanalyticsurl}\protect\url{/aaaa/bbbb/cccc/dddd/eeee/ffff}
  \urlshortenconditionaltext{Path shortened in section heading, full text is: /aaaa/bbbb/cccc/dddd/eeee/ffff}

  \section[/aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbbbbbbb/cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc/ddddddd/eeee/ffff]{\urlshorten{/aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbbbbbbb/cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc/ddddddd/eeee/ffff}}
  
  \urlshortenconditionaltext{Path shortened in section heading, full text is: /aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbbbbbbb/cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc/ddddddd/eeee/ffff}
<%

urlCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOP{QRSTUVWXYZ0123456789.-_~!$&'()*+,;=:@\\%/?///"

for (i in 1:10)
{
  selectedChars = round(runif(9, 0,nchar(urlCharacters)))
  thisName = paste(lapply(selectedChars, FUN=function(charindex){substr(urlCharacters, charindex, charindex)}),collapse="")
  texname = laTeXEscapeString(thisName) 
  # --------------------------------------------------------------------------------------------------------------------------------------------------
  # --------------------------------------------------------------------------------------------------------------------------------------------------
%>
  \section[<%=texname%>]{\urlshorten{<%=texname%>}}
  
  \urlshortenconditionaltext{Path shortened in section heading, full text is: <%=texname%>}
  
  x
  
<%      
}

for (i in 1:100)
{
  selectedChars = round(runif(999, 0,nchar(urlCharacters)))
  thisName = paste(lapply(selectedChars, FUN=function(charindex){substr(urlCharacters, charindex, charindex)}),collapse="")
  texname = laTeXEscapeString(thisName) 
    # --------------------------------------------------------------------------------------------------------------------------------------------------
    # --------------------------------------------------------------------------------------------------------------------------------------------------
%>
\section[<%=texname%>]{\urlshorten{<%=texname%>}}
  
\urlshortenconditionaltext{Path shortened in section heading, full text is <%=texname%>}

x

<%      
}
print(packageDescription("WebAnalytics"))
options(scipenOption)

message(Sys.time(), " end of report")	

%>
\end{document}
