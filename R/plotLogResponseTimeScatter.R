plotLogResponseTimeScatter <-function (times, elapsed,timeDivisor = 1000, ylabText = "Time (log sec)") 
{
	plot(times, elapsed/timeDivisor,log="y", axes=TRUE, main="Log10 Scale Transaction Response Time by Time of Day", ylab=ylabText, xlab="Time of Day")
}
