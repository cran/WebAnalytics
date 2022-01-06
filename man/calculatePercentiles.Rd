\name{calculatePercentiles}
\alias{calculatePercentiles}
\title{calculate quantile values from a column.  
}
\description{
Calculate quantile values for a supplied numeric list.  This is a wrapper around the R quantile function.
}
\usage{
calculatePercentiles(column, 
  percentileList=c(0.7, 0.8, 0.9, 0.95, 0.96, 0.97, 0.98, 0.99, 1)) 
}
\arguments{
  \item{column}{
	a vector of numeric values.  The values will be rounded to two decimal places before calculation.  
	}
  \item{percentileList}{
	a list of the quantile values that are to be calculated (as decimal values in the range 0 to 1)
	}
}
\value{
Returns a list of the quantile calculated by quantile.  
}
\author{
Greg Hunt <greg@firmansyah.com>
}
\examples{
dataValues = c(1,1,1,2,3,4,5,6,7,8,9,10,10,10,10)
calculatePercentiles(dataValues, percentileList=c(0.5))
calculatePercentiles(dataValues)
}
\keyword{ manip }
