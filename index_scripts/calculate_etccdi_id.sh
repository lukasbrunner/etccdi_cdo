#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Number of icing days: Annual count of days when TX (daily maximum temperature) < 0C
index="idETCCDI"
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmax

if [ "$mm" == "m" ]; then
    mm="month"
else
    mm="year"
fi

cdo etccdi_id,freq=year $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc