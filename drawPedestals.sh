#!/bin/bash

INPUTFILENAME=/media/ivan/data/gsi_2020/data/s475plus_08_70Br_0497.root
TREENAME=h101
NEVENTS=500

OUTPUTFILENAME=$(basename "$INPUTFILENAME")
OUTPUTFILENAME="./result/"${OUTPUTFILENAME//".root"/}"_subtr.root"


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

# Remove figures if it already exists from previous analysis
if [ -d ${BASEDIR}/figures/ ]; then
  rm -fv ${BASEDIR}/figures/*
else
  mkdir ${BASEDIR}/figures
fi


root -l -q -b 'pedAnalyse.C('\"$INPUTFILENAME\"','\"$OUTPUTFILENAME\"','\"$TREENAME\"','$NEVENTS')'

for number in 1 2 3
do

TEXTOUTFILE=${BASEDIR}/textoutput/out_${number}.txt
TEXTERRFILE=${BASEDIR}/textoutput/err_${number}.txt

root -l -q -b 'sigma.C('\"$OUTPUTFILENAME\"','\"$TREENAME\"','$NEVENTS','$number')' & #>> TEXTOUTFILE 2> TEXTERRFILE & 
root -l -q -b 'mean.C('\"$OUTPUTFILENAME\"','\"$TREENAME\"','$NEVENTS','$number')' & #>> TEXTOUTFILE 2> TEXTERRFILE & 

done

wait
root -l 'drawResults.C('\"$OUTPUTFILENAME\"','\"$TREENAME\"','$NEVENTS')'
