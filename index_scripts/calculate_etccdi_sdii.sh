#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

# Simple pricipitation intensity index (mean precipitation amount at wet day)
index="sdiiETCCDI" 
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  
freq="ann"  # ClimDexCalc2 only has annual output for this index (even though it would work monthly?) -> restricting if for now
mm='y'

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_pr_unit $infile $pr "$unit_pr_input"

# select only wet days (>1mm) but keep original unit in output file
cdo mul $infile -gtc,1 -mulc,$pr_factor $infile ${outfile}_wd.nc || { echo "ERROR"; exit 1; }
cdo nec,0 ${outfile}_wd.nc ${outfile}_wd_count.nc || { echo "ERROR"; exit 1; }

if [ "$mm" == "m" ]; then
    cdo chname,$pr,$index -div -monsum ${outfile}_wd.nc -monsum ${outfile}_wd_count.nc ${outfile}.nc || { echo "ERROR"; exit 1; }
else
    cdo chname,$pr,$index -div -yearsum ${outfile}_wd.nc -yearsum ${outfile}_wd_count.nc ${outfile}.nc || { echo "ERROR"; exit 1; }    
fi

rm ${outfile}_wd.nc ${outfile}_wd_count.nc
echo ${outfile}.nc
