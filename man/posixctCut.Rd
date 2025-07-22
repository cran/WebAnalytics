\name{posixctCut}
\alias{posixctCut}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Replacement For cut.POSIXct 
}
\description{
Cut replacementthat Returns POSUIXct type to avoid the lack of round-trip support 
in POSIXt types between Cut, as character and as.POSIXXct
}
\usage{
posixctCut(timeVector, interval)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{timeVector}{
  vector of POSIXt type
}
  \item{interval}{
  a character string consisting of zero or one digits (a count), an optional 
  space, a word identifying the units to be grouped:sec, secs, min, mins, hour, hours, day, days, week, weeks.  
  For example: "1 hour", "3 weeks" or "17 seconds".  
}
}
\value{
Returns a vector of POSIXct types, cut to the intervals specified.   
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\author{
Greg Hunt <greg@firmansyah.com>
}
%% ~Make other sections like Warning with \section{Warning }{....} ~
\examples{
d = as.POSIXct(c("2025-07-16 23:00:00", "2023-07-02 16:34:03", "2025-02-11 13:24:24"))
posixctCut(d, "17 mins")
posixctCut(d, "1 hour")
posixctCut(d, "1 week")

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
