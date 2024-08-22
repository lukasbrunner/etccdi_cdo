#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo

#  Monthly/Annual total precipitation in wet days:
index="prcptotETCCDI" 
echo "Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_pr_unit $infile $pr "$unit_pr_input"

# select only wet days (>1mm) but keep original unit in output file
cdo mul $infile -gtc,1 -mulc,$pr_factor $infile ${outfile}_wd.nc || { echo "ERROR"; exit 1; }

if [ "$mm" == "m" ]; then
    cdo chname,$pr,$index -monsum ${outfile}_wd.nc $outfile.nc || { echo "ERROR"; exit 1; }
    cdo chname,$pr,$index -monsum $infile ${outfile}_all-days.nc || { echo "ERROR"; exit 1; }
else
    cdo chname,$pr,$index -yearsum ${outfile}_wd.nc $outfile.nc || { echo "ERROR"; exit 1; }
fi

rm ${outfile}_wd.nc
echo ${outfile}.nc