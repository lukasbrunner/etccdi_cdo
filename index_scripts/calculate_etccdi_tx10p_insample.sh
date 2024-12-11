#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

# TODO: check the file provieded contains the base-period

module purge
module load cdo

# Percentage of days when TX < 10th percentile
index="tx10pETCCDI" 
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
# ensure there is enougth memory for value-sorted histograms
# https://data-infrastructure-services.gitlab-pages.dkrz.de/tutorials-and-use-cases/use-case_climate-extremes-indices_cdo.html
nbins="$(($window*($endboot-$startboot+1)*2+2))"
export CDO_PCTL_NBINS=$nbins

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmax

# NOTE: rm=c -> set read_method “circular” which takes into account the last time steps at the begin of the time period and vise versa. 
cdo setcalendar,365_day -delete,month=2,day=29 $infile ${outfile}_365day.nc
cdo ydrunmin,$window,rm=c ${outfile}_365day.nc ${outfile}_365day_ydrunmin.nc || { echo "ERROR"; exit 1; }
cdo ydrunmax,$window,rm=c ${outfile}_365day.nc ${outfile}_365day_ydrunmax.nc || { echo "ERROR"; exit 1; }

cdo -P 32 etccdi_tx10p,$window,$startboot,$endboot,$mm ${outfile}_365day.nc ${outfile}_365day_ydrunmin.nc ${outfile}_365day_ydrunmax.nc ${outfile}.nc || { echo "ERROR"; exit 1; }

# echo "Fixing time shift for monthly output!"
if [ "$mm" == "m" ]; then
    cdo -shifttime,-1month ${outfile}.nc ${outfile}_tmp.nc
    mv ${outfile}_tmp.nc ${outfile}.nc
fi

rm ${outfile}_365day.nc ${outfile}_365day_ydrunmin.nc ${outfile}_365day_ydrunmax.nc
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc