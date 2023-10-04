\name{laTeXEscapeString}
\alias{laTeXEscapeString}
\title{Escapes a string to enable it to be embedded in a \LaTeX document
}
\description{
The string parameter is an R string that will have a regex applied to it so backslashes will need to be escaped before calling this.
}
\usage{
laTeXEscapeString(nameString)
}
\arguments{
  \item{nameString}{
	The string to have escapes applied.  
	}
}
\value{
Returns the escaped string
}
\author{
Greg Hunt <greg@firmansyah.com>
}

\examples{
laTeXEscapeString("a$b")
}
\keyword{ manip }
