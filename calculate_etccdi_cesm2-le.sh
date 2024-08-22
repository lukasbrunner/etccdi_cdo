#!/bin/bash

unlink settings.sh
ln -s settings_cesm2-le.sh settings.sh

path=/work/uc1275/LukasBrunner/data/SarahKang/CESM2-LE/

fn_tasmax=$path/raw/TREFHTMX/b.e21.BHIST-SSP370cmip6.f09_g17.LE2-1001.001.cam.h1.TREFHTMX.nc
fn_tasmin=$path/raw/TREFHTMN/b.e21.BHISTcmip6.f09_g17.LE2-1001.001.cam.h1.TREFHTMN.nc
fn_tas='-'  # not available for SOPACE, calculate as mean of min and max?
fn_pr=$path/raw/PRECT/b.e21.BHISTcmip6.f09_g17.LE2-1001.001.cam.h1.PRECT.nc
fn_mask='-'  # not found, add pseudo mask?
savepath=$path/ETCCDI
overwrite=''

./calculate_etccdi_all.sh $fn_tasmax $fn_tasmin $fn_tas $fn_pr $fn_mask $savepath $overwrite


