# *News*

# WebAnalytics 0.9.4 (2022)

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

