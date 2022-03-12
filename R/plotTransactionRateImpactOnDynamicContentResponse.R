#
# plotTransactionRateImpactOnDynamicContentResponse
#
#     Copyright (C) 2021  Greg Hunt <greg@firmansyah.com>
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#
plotTransactionRateImpactOnDynamicContentResponse<-function(b)
{
  # b$one is the number of events represented by each record in b, because they are aggregated over ten minutes the rate is divided by 600
  b$one = 1/600
	c = b[which(b$url != "Static Content Requests" & b$url != "Monitoring"  & b$status == "Success"),]
	plotByRate(c$ts, c$elapsed, b$one, 0.95, "10 mins", baseratetimes = b$ts, xlab="per second request rate (10 minute average)",ylab="difference from mean 95th percentile response (ms)",
	title="Effect of request rate on response time")
}
