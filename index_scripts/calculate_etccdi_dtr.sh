#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo/2.5.0-gcc-11.2.0

# Daily temperature range: Monthly mean difference between TX and TN
index="dtrETCCDI"  
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmax
check_variable $infile2 $tasmin

if [ "$mm" == "m" ]; then
    cdo -P 32 chname,$tasmax,$index -monmean -sub $infile $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }
else
    cdo -P 32 chname,$tasmax,$index -yearmean -sub $infile $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }
fi

echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc