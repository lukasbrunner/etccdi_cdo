#!/bin/bash

unlink settings.sh
ln -s settings_cesm2-le.sh settings.sh

path=/work/uc1275/LukasBrunner/data/SarahKang/CESM2-LE

# 1001.001 already done
for member in 1021.002 1041.003 1061.004 1081.005 1101.006 1121.007 1141.008 1161.009 1181.010 1231.001 1231.002 1231.003 1231.004 1231.005 1231.006 1231.007 1231.008 1231.009 1231.010 1251.001 1251.002 1251.003 1251.004 1251.005 1251.006 1251.007 1251.008 1251.009 1251.010 1281.001 1281.002 1281.003 1281.004 1281.005 1281.006 1281.007 1281.008 1281.009 1281.010 1301.001 1301.002 1301.003 1301.004 1301.005 1301.006 1301.007 1301.008 1301.009 1301.010; do
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculating indices for $member"

    fn_tasmax=$path/raw/TREFHTMX/b.e21.BHIST-SSP370cmip6.f09_g17.LE2-${member}.cam.h1.TREFHTMX.nc
    fn_tasmin=$path/raw/TREFHTMN/b.e21.BHISTcmip6.f09_g17.LE2-${member}.cam.h1.TREFHTMN.nc
    fn_tas='-'  # not available for SOPACE, calculate as mean of min and max?
    fn_pr=$path/raw/PRECT/b.e21.BHISTcmip6.f09_g17.LE2-${member}.cam.h1.PRECT.nc
    fn_mask='-'  
    savepath=$path/ETCCDI/$member
    overwrite=''

    mkdir -p $savepath

    ./calculate_etccdi_all.sh $fn_tasmax $fn_tasmin $fn_tas $fn_pr $fn_mask $savepath $overwrite
    
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Calculated indices for $member"
done

