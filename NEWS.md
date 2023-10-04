# *News*

# WebAnalytics 0.9.9 (2023-10-04)

Package level documentation page missing - re-added.  Corrected notes that are being generated for documentation.

# WebAnalytics 0.9.8 (2023-06-25)

Allowable elapsed time of examples has been halved since 2022.  Parallelism > 2 
not allowed in examples.  Invisible changes to examples.

# WebAnalytics 0.9.7 (2023-06-25)

Rewrite of parts of the performance analysis vignette PDF.   

# WebAnalytics 0.9.6 (2022-05-17)

* Bug: URLs with uninterrupted (no spaces or punctuation) strings of more than 484 characters would crash LaTeX.  Not likely to be seen in production but not impossible.  Corrected the LaTeX document class URL truncation macros to break the line every 90 characters (punch cards are not quite dead, 132 was too wide and 80 too short).  This means that wrapping does not occur in that text now, but it is guaranteed to fit on the page.  LaTeX macros (\emph{something} or \textbf{something} for example) embedded in the string are not guaranteed to work if they fall across the split and I do not know why, but this is not an issue for the report template which only uses this for URL strings, its just something to keep in mind.  
* Bug: URLs 6k characters in length (seen in logs) crash LaTeX.  The brew/R report template has been updated to replace huge URLs with a short numeric placeholder and list the content of the URL in the log.  Huge URLs are usually an error or attack of some kind so this seems reasonable balance of usefulness, that is: removing what crashes LaTeX being more important than reporting rare giant URLs in an easily understood form.  

# WebAnalytics 0.9.5 (2022-04-24)

* New: Added a cookbook PDF vignette about how to approach dealing with performance problems using this package.  
* Bug: Fixed document formatting error identified by CRAN under the R development build.  
* Bug: Fixed escaping of windows file paths
* New; Rearranged sample data and associated tests to better fit under CRAN limitations (and still work) 

# WebAnalytics 0.9.4 (2022-04-01)

* New: Added TinyTex support to remove need for separate latex/xelatex installation.
* New: Added progress messages to report template.
* Bug: replaced readr (introduced in 0.9.2 to support nested quotes in log records) with data.table fread.  Much faster, less odd error handling behaviour and also parses nested quotes correctly  
* Bug: incorrect types being passed to readr
* KnownProblem: Extremely long URLS (not seen in the wild, but in testing) can cause the LaTeX code that abbreviates URLs to fail.  This will be fixed in a later release.  

# WebAnalytics 0.9.2 (2022-03-09)

* New: Added User Agent frequency reporting
* Bug: Fixed bug in data rate/static request response time graph 
* New: Improvements to package dependency declarations
* New: Changes to improve handling of missing data (more built-in tolerance of missing data)
* New: Added support for nested quotes in the input data file (to handle escaped JSON in log files)
* Bug: Fixed error when workingDirectoryPopulate() was called in already populated directory
* Bug: workingDirectoryPopulate() was leaving files open, fixed
* New: workingDirectoryPopulate() tests added
* Bug: Fixes to minor typographical and grammatical errors 

# WebAnalytics 0.9.1 (2022-01-05)

* **CRAN** Initial Submission

Prior to this release the package was un-published

# WebAnalytics 0.01 (2008-07-01)

Approximate date of the first version of what became this package 

