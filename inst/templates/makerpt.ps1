$nameStem=$Args[0]

$ErrorActionPreference='silentlycontinue'

$f = get-item -path "$nameStem.config"
if (! $f.exists) 
{
	echo "filename $nameStem.config does not exist"
	exit
}

$dateTime = get-date -uformat "%Y%m%d%H%m%S"
$brewFileName="brewdriver.$dateTime"
$texFileNameStem = "$nameStem$dateTime"

echo @"
options(error=function(){traceback()})
library(brew)
e = new.env()
with(e,{reportParameterFileName="$nameStem.config"})
a = brew(file="sampleRfile.R", output="$texFileNameStem.tex",envir=e)
if(exists("a")) {
if(class(a) == "try-error"){
	traceback()
	print(a)
	quit(save="no",status=10)
}
print("normal end of R code")
}
quit(save="no",status=0)
"@ | out-file $brewFileName -encoding ascii

D:\"Program Files"\R\R-3.0.3\bin\rscript.exe $brewFileName

if ($LastExitCode -eq 0)
{
	$f = get-item -path "$texFileNameStem.tex"
	if ($f.exists) 
	{

		xelatex "$texFileNameStem.tex"
		xelatex "$texFileNameStem.tex"
		xelatex "$texFileNameStem.tex"

		remove-item -path "$texFileNameStem.aux"
		remove-item -path "$texFileNameStem.toc"
		remove-item -path "$brewFileName"
	}
	else
	{
		echo "R code failed ($LastExitCode) - initial parse failed"
	}
}
else
{
	echo "R code failed ($LastExitCode) - script execution error"
}
