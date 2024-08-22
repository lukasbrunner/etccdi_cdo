#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Growing season length: Annual (1st Jan to 31st Dec in Northern Hemisphere (NH), 1st July to 30th June in Southern Hemisphere (SH)) count between first span of at least 6 days with daily mean temperature TG>5oC and first span after July 1st (Jan 1st in SH) of 6 days with TG<5oC. 
index="gslETCCDI"  
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="ann"  # only annual output for this index; overwrite

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite

cdo chname,thermal_growing_season_length,$index -eca_gsl $infile $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }
echo ${outfile}.nc