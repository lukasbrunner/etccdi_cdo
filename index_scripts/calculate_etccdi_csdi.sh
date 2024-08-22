#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Cold speel duration index: Annual count of days with at least 6 consecutive days when TN < 10th percentile
index="csdiETCCDI"  
echo "Calculating $index" 

source functions.sh  # provides `process_input`
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="ann"  # only annual output for this index; overwrite
export CDO_PCTL_NBINS=302

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite

cdo etccdi_csdi $infile $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }
echo ${outfile}.nc