$nameStem=$Args[0]

$rscriptExecutable = "C:\Program Files\R\R-4.1.2\bin\rscript.exe"

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

Remove-Item -Path Env:R_TESTS

echo @"
options(error=function(){traceback();quit(save="no",status=10)})
e = new.env()
with(e,{reportParameterFileName="$nameStem.config"})
options(brew.extended.error = TRUE)
options(show.error.messages = TRUE)
a = brew::brew(file="sampleRfile.R", output="$texFileNameStem.tex",envir=e)
if(exists("a")) {
if(class(a) == "try-error"){
	traceback(0)
	print(a)
	quit(save="no",status=10)
}
print("normal end of R code")
}
quit(save="no",status=0)
"@ | out-file $brewFileName -encoding ascii

$exeFound = Test-Path -Path $rscriptExecutable -PathType Leaf
if($exeFound -eq $false)
{
  echo "Rscript executable not found at $rscriptExecutable"
  exit
}

& $rscriptExecutable $brewFileName

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
