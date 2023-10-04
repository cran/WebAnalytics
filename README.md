# WebAnalytics
WebAnalytics - web log performance, scalability and workload analysis - [https://CRAN.R-project.org/package=WebAnalytics](https://CRAN.R-project.org/package=WebAnalytics)

The WebAnalytics package is a simple, low-impact way of getting detailed insights into the performance of a web application and of identifying opportunities for remediation. It generates detailed analytical reports on application response time from web server logs.

The objective of the package is to extract the maximum value from web server log data and to use that information to identify problems and potential areas for remediation. It enables you to easily read web server log files; generate histograms, scatter plots and tabular reports of response times, overall and per URL; to generate some diagnostic plots; and to generate a LATEX document that can then be formatted as a PDF. The package supplies scripts and templates to do that document generation.

It is not a debugging tool, it indicates where problems are and where there are behaviours that are unexpected: the tables and histograms identifying multiple code paths that developers may not be aware of, the diagnostic plots indicating contention, the scatter plots indicating short term variations in response time that are indicative of some kind of problem. All these enable potential fixes to be worked on, and once those fixes are developed, enabling direct measurement of the impact using the baselining graphs and tables.
