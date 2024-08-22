#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Daily temperature range: Monthly mean difference between TX and TN
index="dtrETCCDI"  
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="mon"  # only monthly output for this index; overwrite

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite

cdo -P 32 chname,$tasmax,$index -monmean -sub $infile $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }
echo ${outfile}.nc