#!/bin/bash

INPUTFILENAME=/u/frsgast/s475plus/upexps/202003_s474s475p/rootfiles/s475plus_08_70Br_0497.root
TREENAME=h101
NEVENTS=700


if [ -z ${ROOTSYS+x} ]; then
  echo "ROOTSYS is unset. Aborting.";
  exit;
else
  echo "ROOTSYS is set to '$ROOTSYS'";
fi

BASEDIR="$PWD"

# Remove textual output if it already exists from previous analysis
if [ -d ${BASEDIR}/textoutput/ ]; then
  rm -fv ${BASEDIR}/textoutput/*.txt
else
  mkdir ${BASEDIR}/textoutput
fi

# Remove the graph output if it already exists from previous analysis
if [ -d ${BASEDIR}/result/ ]; then
  rm -fv ${BASEDIR}/result/*.txt
else
  mkdir ${BASEDIR}/result
fi

for number in 1 2 3
do

TEXTOUTFILE=${BASEDIR}/textoutput/out_${number}.txt
TEXTERRFILE=${BASEDIR}/textoutput/err_${number}.txt

root -l -q -b 'sigma.C('\"$INPUTFILENAME\"','\"$TREENAME\"','$NEVENTS','$number')' & #>> TEXTOUTFILE 2> TEXTERRFILE & 
root -l -q -b 'mean.C('\"$INPUTFILENAME\"','\"$TREENAME\"','$NEVENTS','$number')' & #>> TEXTOUTFILE 2> TEXTERRFILE & 

done

wait
root -l 'drawResults.C('\"$INPUTFILENAME\"','\"$TREENAME\"','$NEVENTS')'
