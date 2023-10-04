\name{printPercentiles}
\alias{printPercentiles}
\title{calculate quantile values from a column and print as an xtable vertically  
}
\description{
Calculate quantile values for a supplied numeric list.  .
}
\usage{
printPercentiles(column, 
      dataName, 
      percentileList=c(0.7, 0.8, 0.9, 0.95, 0.96, 0.97, 0.98, 0.99, 1)) 
}
\arguments{
  \item{column}{
	a vector of numeric values.  The values will be rounded to two decimal places before calculation.  
	}
  \item{dataName}{
	the literal value to be used as the data name in the table  
	}
  \item{percentileList}{
	a list of the quantile values that are to be calculated (as decimal values in the range 0 to 1)
	}
}
\value{
Does not return a value.  It prints the xtable.  
}
\author{
Greg Hunt <greg@firmansyah.com>
}
\examples{
dataValues = c(1,1,1,2,3,4,5,6,7,8,9,10,10,10,10)
printPercentiles(dataValues, "Random Data", percentileList=c(0.5, 0.75, 0.9))
}
\keyword{ manip }
