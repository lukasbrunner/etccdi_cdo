#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo/2.5.0-gcc-11.2.0

# Growing season length: Annual (1st Jan to 31st Dec in Northern Hemisphere (NH), 1st July to 30th June in Southern Hemisphere (SH)) count between first span of at least 6 days with daily mean temperature TG>5oC and first span after July 1st (Jan 1st in SH) of 6 days with TG<5oC. 
index="gslETCCDI"  
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="ann"  # only annual output for this index; overwrite

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tas

if [ -f $infile2 ]; then  # create a pseudo mask with only True if no mask is given
    echo "    $(date +"%Y-%m-%d %H:%M:%S") - Calculating pseudo mask" 
    infile2=${outfile}_mask.nc
    cdo addc,1 -mulc,0 -seltimestep,1 $infile $infile2
    echo "    $(date +"%Y-%m-%d %H:%M:%S") - Calculated pseudo mask" 
fi

cdo chname,thermal_growing_season_length,$index -eca_gsl $infile $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }

rm -f ${outfile}_mask.nc  # delete if existing

echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index" 
echo ${outfile}.nc