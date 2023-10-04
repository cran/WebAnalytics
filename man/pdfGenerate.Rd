\name{pdfGenerate}
\alias{pdfGenerate}
\title{Generate a PDF using the R API for TinyTeX  
}
\description{
This function calls \CRANpkg{brew} to generate a TeX document and then calls the TinyTeX API to generate a PDF from the \LaTeX document in the specified work directory.  

The function does not attempt to install TinyTex itself, this must be done by the user calling the \code{tinytex::install_tinytex()} function. The first time that this function is called to generate a report, provided that TinyTeX is has been installed with default settings, it will install the required LaTeX packages for the report.  This may take some time.

Tinytex has been observed to run glacially slowly on Windows.  For some users it may be preferable (and far quicker) to install some version of xelatex and run it with it set to automatically download packages.   

}
\usage{
pdfGenerate(configFile, templateFile="sampleRfile.R", workDir=".") 
}
\arguments{ 
  \item{configFile}{
The name of the config file to use.  If this parameter is omitted, the work directory is searched for a file whose name ends, case insensitively, in \code{.config}.  If there is only one file with the extnsion \code{.config} it is used.  If there is no config file or multiple config files an error is signalled.  The leading part of the config file name, before \code{.config}, is used as the prefix for the gemerated PDF name}
  \item{templateFile}{
This defaults to \code{sampleRfile.R} which is the default name of the template.
	}
  \item{workDir}{
The directory to use for document generation.  This directory must contain the template and any associated support files, such as the \LaTeX document class. \code{\link{workingDirectoryPopulate}} will populate this directory correctly and create a temporary files directory under it.
}
}
\value{
Returns the name of the generated PDF.  
}
\author{
Greg Hunt <greg@firmansyah.com>
}
\examples{
\dontrun{
filesDir =  paste0(tempdir(),"/ex")
wkDir = paste0(tempdir(),"/ey")
configVariableSet("config.workdir", filesDir)
# setup the work directory 
workingDirectoryPopulate(wkDir)

pdfGenerate(workDir=wkDir) 

}
\dontshow{
\dontrun{
unlink(filesDir,recursive=TRUE)
unlink(wkDir,recursive=TRUE)

}
}

}
\keyword{ manip }
