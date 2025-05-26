#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo/2.5.0-gcc-11.2.0

#  Annual count of days when PRCP≥ 10mm:
index="r20mmETCCDI"  
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $pr
check_pr_unit $infile $pr "$unit_pr_input"

if [ "$mm" == "m" ]; then
    mm="month"
else
    mm="year"
fi

cdo etccdi_r20mm,freq=$mm -mulc,$pr_factor $infile $outfile.nc || { echo "ERROR"; exit 1; }
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc