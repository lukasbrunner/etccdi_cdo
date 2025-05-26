#!/bin/bash

# A test script running all 26 indices for the first member of MPI-ESM1-2-LR
# This can be compared to the results from Frevas ClimDexCalc2 which can be found at
# /work/uc1275/LukasBrunner/data/etccdi_cdo/climdexcalc2_test

unlink settings.sh
ln -s default_settings.sh settings.sh

fn_tasmax=/work/uc1275/LukasBrunner/data/etccdi_cdo/input/tasmax_day_MPI-ESM1-2-LR_historical_r1i1p1f1_gn_18500101-20141231.nc
fn_tasmin=/work/uc1275/LukasBrunner/data/etccdi_cdo/input/tasmin_day_MPI-ESM1-2-LR_historical_r1i1p1f1_gn_18500101-20141231.nc
fn_tas=/work/uc1275/LukasBrunner/data/etccdi_cdo/input/tas_day_MPI-ESM1-2-LR_historical_r1i1p1f1_gn_18500101-20141231.nc
fn_pr=/work/uc1275/LukasBrunner/data/etccdi_cdo/input/pr_day_MPI-ESM1-2-LR_historical_r1i1p1f1_gn_18500101-20141231.nc
fn_mask=/work/uc1275/LukasBrunner/data/etccdi_cdo/input/sftlf_fx_MPI-ESM1-2-LR_historical_r1i1p1f1_gn.nc
savepath=/work/uc1275/LukasBrunner/data/etccdi_cdo/cdo_test365day_default
overwrite=''

./calculate_etccdi_all.sh $fn_tasmax $fn_tasmin $fn_tas $fn_pr $fn_mask $savepath $overwrite


