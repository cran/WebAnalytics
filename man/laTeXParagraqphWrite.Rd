\name{laTeXParagraphWrite}
\alias{laTeXParagraphWrite}
\title{Writes a LaTex paragraph on stdout
}
\description{
A convenience function to write a paragraph (with optional text) on stdout.  This is useful in code blocks in Brew files, for example between 
graphics.  
}
\usage{
laTeXParagraphWrite(string="")
}
\arguments{
  \item{string}{
	Text to be inserted into the paragraph
	}
}
\value{
Does not return any value
}
\author{
Greg Hunt <greg@firmansyah.com>
}

\examples{
laTeXParagraphWrite()
laTeXParagraphWrite("blah blah")
}
\keyword{ manip }
