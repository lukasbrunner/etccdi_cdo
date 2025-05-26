#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo/2.5.0-gcc-11.2.0
export CDO_PCTL_NBINS=302

# Cold speel duration index: Annual count of days with at least 6 consecutive days when TN < 10th percentile
index="csdiETCCDI"  
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh 
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="ann"  # only annual output for this index; overwrite

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmin
check_variable $infile2 10pETCCDI

cdo setcalendar,365_day -delete,month=2,day=29 $infile ${outfile}_365day.nc || { echo "ERROR"; exit 1; }

cdo etccdi_csdi ${outfile}_365day.nc $infile2 ${outfile}.nc || { echo "ERROR"; exit 1; }

rm ${outfile}_365day.nc
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc