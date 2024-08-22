#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Maximum length of wet spell, maximum number of consecutive days with RR ≥ 1mm
index="cwdETCCDI"  
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="ann"  # only annual output for this index; overwrite

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_pr_unit $infile $pr "$unit_pr_input"

cdo etccdi_cwd -mulc,$pr_factor $infile ${outfile}.nc || { echo "ERROR"; exit 1; }
echo ${outfile}.nc