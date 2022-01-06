plotTransactionRateImpactOnDynamicContentResponse<-function(b)
{
  # b$one is the number of events represented by each record in b, because they are aggregated over ten minutes the rate is divided by 600
  b$one = 1/600
	c = b[b$url != "Static Content Requests" & b$url != "Monitoring"  & b$status == "Success",]
	plotByRate(c$ts, c$elapsed, b$one, 0.95, "10 mins", baseratetimes = b$ts, xlab="per second request rate (10 minute average)",ylab="difference from mean 95th percentile response (ms)",
	title="Effect of request rate on response time")
}
