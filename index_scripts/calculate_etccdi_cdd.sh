#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Maximum length of dry spell, maximum number of consecutive days with RR < 1mm
index="cddETCCDI" 
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="full"  # only annual output for this index; overwrite

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $pr
check_pr_unit $infile $pr "$unit_pr_input"

cdo etccdi_cdd -mulc,$pr_factor $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc
