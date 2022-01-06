plotResponseTimeScatter <-function (times, elapsed,timeDivisor = 1000, ylabText = "Time (sec)") 
{
	plot(times, elapsed/timeDivisor,axes=TRUE, main="Transaction Response Time by Time of Day", ylab=ylabText, xlab="Time of Day")
}
