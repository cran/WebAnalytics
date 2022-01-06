#!/bin/bash

if [[ -e $1 ]]; then
configfile=$1
nameStem=`basename $1`
elif [[ -e $1.config ]]; then
    configfile=$1.config
    nameStem=$1
else
  echo "configuration file name $1 or $1.config not found"
  return 1 2> /dev/null || exit 1 
fi 

dateTime=`date "+%Y%m%d%H%M%S"`
brewFileName="brewdriver.$dateTime"
texFileNameStem="$nameStem$dateTime"

cat > $brewFileName <<End-of-script
library(brew)
e = new.env()
with(e,{reportParameterFileName="$configfile"})
a = brew(file="sampleRfile.R", output="$texFileNameStem.tex",envir=e)
if(exists("a")) {
if(class(a) == "try-error"){
	traceback(0)
	print(a)
	quit(save="no",status=10)
}
print("normal end of R code")
}
quit(save="no",status=0)

End-of-script

rscript $brewFileName

rc=$?

if [ $rc -eq 0 ]; then
		xelatex "$texFileNameStem.tex"
		xelatex "$texFileNameStem.tex"
		xelatex "$texFileNameStem.tex"

		rc=$?
		if [ $rc -eq 0 ]; then
			rm $brewFileName
			rm $texFileNameStem.out
			rm $texFileNameStem.log
			rm $texFileNameStem.toc
			rm $texFileNameStem.aux
			rm $texFileNameStem.tex
		fi 
else
  echo "r script failed"
fi