#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo
export CDO_PCTL_NBINS=302

# calculate the 10th percentile threshold (helper function)
index="90pETCCDI" 
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="doy"  # set frequency to day of the year

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
# check_variable $infile $tasmax

cdo setcalendar,365_day -delete,month=2,day=29 -selyear,$startboot/$endboot $infile ${outfile}_baseperiod.nc || { echo "ERROR"; exit 1; }
cdo ydrunmin,$window,rm=c ${outfile}_baseperiod.nc ${outfile}_ydrunmin.nc || { echo "ERROR"; exit 1; }
cdo ydrunmax,$window,rm=c ${outfile}_baseperiod.nc ${outfile}_ydrunmax.nc || { echo "ERROR"; exit 1; }
# NOTE: rm=c -> set read_method “circular” which takes into account the last time steps at the begin of the time period and vise versa. 
cdo chname,$tasmax,$index -ydrunpctl,90,$window,rm=c,pm=r8 ${outfile}_baseperiod.nc ${outfile}_ydrunmin.nc ${outfile}_ydrunmax.nc ${outfile}.nc || { echo "ERROR"; exit 1; }

rm ${outfile}_baseperiod.nc ${outfile}_ydrunmin.nc ${outfile}_ydrunmax.nc
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc