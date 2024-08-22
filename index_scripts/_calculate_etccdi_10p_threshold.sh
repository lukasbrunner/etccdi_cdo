#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# calculate the 10th percentile threshold (helper function)
index="10pETCCDI" 
echo "Calculating $index"

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
export CDO_PCTL_NBINS=302

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite

cdo selyear,$startboot/$endboot $infile ${outfile}_baseperiod.nc || { echo "ERROR"; exit 1; }
cdo ydrunmin,$window,rm=c ${outfile}_baseperiod.nc ${outfile}_ydrunmin.nc || { echo "ERROR"; exit 1; }
cdo ydrunmax,$window,rm=c ${outfile}_baseperiod.nc ${outfile}_ydrunmax.nc || { echo "ERROR"; exit 1; }
# NOTE: rm=c -> set read_method “circular” which takes into account the last time steps at the begin of the time period and vise versa. 
# TODO: what does pm do?
cdo ydrunpctl,10,$window,rm=c,pm=r8 ${outfile}_baseperiod.nc ${outfile}_ydrunmin.nc ${outfile}_ydrunmax.nc ${outfile}.nc || { echo "ERROR"; exit 1; }

rm ${outfile}_baseperiod.nc ${outfile}_ydrunmin.nc ${outfile}_ydrunmax.nc
echo ${outfile}.nc
