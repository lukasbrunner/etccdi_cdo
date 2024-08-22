#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Number of summer days: Annual count of days when TX (daily maximum temperature) > 25C.
index="suETCCDI"  
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite

if [ "$mm" == "m" ]; then
    mm="month"
else
    mm="year"
fi

cdo etccdi_su,25,freq=$mm $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
echo ${outfile}.nc
