#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Annual/Monthly minimum value of daily maximum temperature
index="txnETCCDI"  
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmax

if [ "$mm" == "m" ]; then
    cdo -P 32 chname,$tasmax,$index -monmin $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
else
    cdo -P 32 chname,$tasmax,$index -yearmin $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
    
fi
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc