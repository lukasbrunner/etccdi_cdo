#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

# TODO: check the file provieded contains the base-period

module purge
module load cdo

# Percentage of days when TN > 90th percentile
index="tn90pETCCDI" 
echo "Calculating $index" 

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

# NOTE: rm=c -> set read_method “circular” which takes into account the last time steps at the begin of the time period and vise versa. 
cdo ydrunmin,$window,rm=c $infile ${outfile}_ydrunmin.nc || { echo "ERROR"; exit 1; }
cdo ydrunmax,$window,rm=c $infile ${outfile}_ydrunmax.nc || { echo "ERROR"; exit 1; }
cdo -P 32 etccdi_tn90p,$window,$startboot,$endboot,$mm $infile ${outfile}_ydrunmin.nc ${outfile}_ydrunmax.nc ${outfile}.nc || { echo "ERROR"; exit 1; }

# echo "Fixing time shift for monthly output!"
if [ "$mm" == "m" ]; then
    cdo -shifttime,-1month ${outfile}.nc ${outfile}_tmp.nc  || { echo "ERROR"; exit 1; }
    mv ${outfile}_tmp.nc ${outfile}.nc
fi

rm ${outfile}_ydrunmin.nc ${outfile}_ydrunmax.nc
echo ${outfile}.nc