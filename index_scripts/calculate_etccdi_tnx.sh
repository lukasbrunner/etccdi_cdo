#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Annual/Monthly maximum value of daily minimum temperature
index="tnxETCCDI"  
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmin

if [ "$mm" == "m" ]; then
    cdo -P 32 chname,$tasmin,$index -monmax $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
else
    cdo -P 32 chname,$tasmin,$index -yearmax $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
    
fi
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc