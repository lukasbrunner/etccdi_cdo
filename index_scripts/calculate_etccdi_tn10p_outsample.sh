#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

# TODO: check the file provieded contains the base-period

module purge
module load cdo/2.5.0-gcc-11.2.0

# Percentage of days when TN < 10th percentile
index="tn10pETCCDI" 
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmin
check_variable $infile2 10pETCCDI

cdo setcalendar,365_day -delete,month=2,day=29 $infile ${outfile}_365day.nc || { echo "ERROR"; exit 1; }

if [ "$mm" == "m" ]; then
    # NOTE: sub automatically copies time steps (direct gt does not)
    cdo chname,$tasmin,$index -setunit,"1" -monmean -ltc,0 -sub ${outfile}_365day.nc $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }
else
    cdo chname,$tasmin,$index -setunit,"1" -yearmean -ltc,0 -sub ${outfile}_365day.nc $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }    
fi

rm ${outfile}_365day.nc
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc