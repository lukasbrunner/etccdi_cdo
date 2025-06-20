#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo/2.5.0-gcc-11.2.0

#  Monthly/Annual total precipitation in wet days:
index="wdETCCDI" 
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $pr
check_pr_unit $infile $pr "$unit_pr_input"

# select only wet days (>1mm) but keep original unit in output file
cdo chname,$pr,$index -setrtomiss,-inf,0 -mul $infile -gtc,1 -mulc,$pr_factor $infile ${outfile}.nc || { echo "ERROR"; exit 1; }

# change unit
# cdo chname,$pr,$index -setrtomiss,-inf,1 -mulc,$pr_factor $infile ${outfile}.nc || { echo "ERROR"; exit 1; }

echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc