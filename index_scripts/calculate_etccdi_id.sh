#!/bin/bash
# CC-BY Lukas Brunner (lukas.brunner@uni-hamburg.de)

module purge
module load cdo/2.5.0-gcc-11.2.0

# Number of icing days: Annual count of days when TX (daily maximum temperature) < 0C
index="idETCCDI"
echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating $index" 

source functions.sh
# check input and provide `infile`, `outdir`, and `outfile_base`
process_input $@

source settings.sh  

outfile=$(create_filename $outdir $outfile_base $index $freq $window $startboot $endboot)
skip_existing $outfile $overwrite
check_variable $infile $tasmax



unit=$(ncdump -h $infile | grep -A 1 "${tasmax}:" | grep units | awk -F\" '{print $2}')
if [ "$unit" == "K" ]; then
    thr="273.15"
else
    thr=0
fi

if [ "$mm" == "m" ]; then
    # mm="month"
    cdo chname,$tasmax,$index -chunit,$unit,day -monsum -ltc,$thr $infile ${outfile}.nc
else
    # mm="year"
    cdo chname,$tasmax,$index -chunit,$unit,day -yearsum -ltc,$thr $infile ${outfile}.nc
    
fi

# DEBUG: outputs wrong time-steps -> calculate manually for now
# cdo etccdi_id,freq=$mm $infile ${outfile}.nc || { echo "ERROR"; exit 1; }

echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated $index"
echo ${outfile}.nc