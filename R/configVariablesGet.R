#
# configVariablesLoad - read config variables from a config file, setting defaults as necessary
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
#.configEnv <- new.env(parent=emptyenv())
.configEnv <- new.env()

configVariablesLoad<-function(fileName="report.config")
{
	requiredNames = c("config.current.dataDir","config.current.dirNames","config.projectName","config.documentName","config.current.columnList")
	optionalNames = c("config.readBaseline", "config.baseline.dataDir", "config.baseline.dirNames", "config.baseline.columnList", "config.generateGraphForTimeOver", 
						"config.generateServerSessionStats", "config.generatePercentileRankings", "config.fix.data", "config.fix.current.data", "config.fix.baseline.data",
						"config.generateTransactionDetails", "config.generateDiagnosticPlots", "config.workdir", "config.author",
						"config.securityclass")

	fn = normalizePath(fileName)
	configFileExists = file.exists(fn)
	if(!configFileExists)
	{
		stop("Config file  ", fn, " was not found")
	}
	else
	{
		sys.source(fileName,envir = .configEnv)
	}
	
	loadedNames = ls(envir=.configEnv)
	foundNames = ls(envir=.configEnv)
	items = setdiff(requiredNames,intersect(requiredNames,foundNames))

	if(length(items) > 0)
	{
		stop("Configuration file is missing variables: ", toString(items))
		return()
	}
	
	items = setdiff(foundNames,union(requiredNames,optionalNames))
	if(length(items) > 0)
	{
		warning("Configuration file contains unused variables ", toString(items))
	}
	
	if(!is.element("config.generateGraphForTimeOver", loadedNames))
	{
		assign("config.generateGraphForTimeOver", 10000, envir = .configEnv)
	}
	if(!is.element("config.generateServerSessionStats", loadedNames))
	{
		assign("config.generateServerSessionStats", TRUE, envir = .configEnv)
	}
	if(!is.element("config.generatePercentileRankings", loadedNames))
	{
		assign("config.generatePercentileRankings", FALSE, envir = .configEnv)
	}
	if(!is.element("config.readBaseline", loadedNames))
	{
		assign("config.readBaseline", FALSE, envir = .configEnv)
	}
	if(!is.element("config.generateTransactionDetails", loadedNames))
	{
		assign("config.generateTransactionDetails", TRUE, envir = .configEnv)
	}
	if(!is.element("config.generateDiagnosticPlots", loadedNames))
	{
		assign("config.generateDiagnosticPlots", TRUE, envir = .configEnv)
	}
	if(!is.element("config.author", loadedNames))
	{
	  if (requireNamespace("whoami", quietly = TRUE))
	  {
	    assign("config.author", whoami::fullname(fallback=whoami::username(fallback="Author name not found")), envir = .configEnv)
	  }
	  else
	  {
	    assign("config.author", "Author", envir = .configEnv)
	  }
	}
	if(!is.element("config.securityClass", loadedNames))
	{
	  assign("config.securityClass", "Commercial-In-Confidence", envir = .configEnv)
	}
	
	if(configFileExists)
	{
		sys.source(fileName,envir = .configEnv)
	}
	configVariablesSet = ls(envir=.configEnv, pattern="config.*")
	message("Config Variables Set",appendLF=TRUE)
	for(t in configVariablesSet)
	{
		message(paste(t, paste(format(get(t,envir=.configEnv)),collapse="\n")), appendLF=TRUE)
	}
}

configVariableGet<-function(name)
{
  return(get(name,envir=.configEnv,inherits=FALSE))
}

configVariableSet<-function(name, value)
{
  assign(name,value, envir=.configEnv,inherits=FALSE)
}

configVariableIs<-function(name)
{
  return(exists(name,envir=.configEnv))
}

configVariablesAll<-function()
{
  return(ls(envir=.configEnv))
}
