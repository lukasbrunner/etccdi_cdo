#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Number of frost days: Monthly/Annual count of days when TN (daily minimum temperature) < 0oC.
index="fdETCCDI"  
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite

if [ "$mm" == "m" ]; then
    mm=month  # NOTE: accepted frequency string differs from percentile-based indices
else
    mm=year
fi

cdo etccdi_fd,freq=$mm $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
echo ${outfile}.nc