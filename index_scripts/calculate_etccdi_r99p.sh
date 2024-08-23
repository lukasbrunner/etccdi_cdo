#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Annual total PRCP when RR > 95p.
index="r99pETCCDI"  
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="ann"  # only annual output for this index; overwrite
export CDO_PCTL_NBINS=302

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $pr
check_pr_unit $infile $pr "$unit_pr_input"

# select only wet days (>1mm) but keep original unit in output file
cdo setrtomiss,-inf,0 -mul $infile -gtc,1 -mulc,$pr_factor $infile ${outfile}_wd.nc || { echo "ERROR"; exit 1; }

# percentile across all days in base-period
cdo selyear,$startboot/$endboot ${outfile}_wd.nc ${outfile}_wd_baseperiod.nc || { echo "ERROR"; exit 1; }
cdo timpctl,99 ${outfile}_wd_baseperiod.nc -timmin ${outfile}_wd_baseperiod.nc -timmax ${outfile}_wd_baseperiod.nc ${outfile}_wd_baseperiod_99p.nc || { echo "ERROR"; exit 1; }

# sum of days exceeding percentile
cdo chname,$pr,$index -yearsum -mul ${outfile}_wd.nc -gt ${outfile}_wd.nc ${outfile}_wd_baseperiod_99p.nc $outfile.nc || { echo "ERROR"; exit 1; }

rm ${outfile}_wd.nc ${outfile}_wd_baseperiod.nc ${outfile}_wd_baseperiod_99p.nc
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc

