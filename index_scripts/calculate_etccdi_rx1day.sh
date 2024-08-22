#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Monthly/Annual maximum 1-day precipitation
index="rx1dayETCCDI"  
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_pr_unit $infile $pr "$unit_pr_input"

if [ "$mm" == "m" ]; then
    mm="month"
else
    mm="year"
fi

cdo etccdi_rx1day,freq=$mm -mulc,$pr_factor $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
echo ${outfile}.nc