#!/bin/bash

fn_tasmax=$1
fn_tasmin=$2
fn_tas=$3
fn_pr=$4
fn_mask=$5
savepath=$6
ow=$7

echo "-----------------------"
echo "--- Input filenames ---"
echo "-----------------------"
echo

echo "tasmax: $fn_tasmax"
echo "tasmin: $fn_tasmin"
echo "tas: $fn_tas"
echo "pr: $fn_pr"
echo "mask: $fn_mask"
echo "outdir: $savepath"
echo "overwrite: $ow"

echo
echo "-------------------------"
echo "--- Running subscipts ---"
echo "-------------------------"
echo

start_time=$(date +%s)

# ----------------------------
# --- tasmax-based indices ---
# ----------------------------

if [ -f $fn_tasmax ]; then

    # --- percentile-based indices ---
    # 90 percentile threshold

    # ------------------------------------------------------------------------
    # --- simplified version without bootstrapping ---------------------------
    # ------------------------------------------------------------------------
    out=$(./index_scripts/_calculate_etccdi_tx90p_threshold.sh $fn_tasmax $savepath $ow)
    echo "${out[@]}"
    fn_tasmax_90p=$(echo "${out[@]}" | tail -n 1)  # needed for WSDI
    out=$(./index_scripts/_calculate_etccdi_tx10p_threshold.sh $fn_tasmax $savepath $ow)
    echo "${out[@]}"
    fn_tasmax_10p=$(echo "${out[@]}" | tail -n 1)

    #  Percentage of days when TX < 10th percentile.
    ./index_scripts/calculate_etccdi_tx10p_outsample.sh $fn_tasmax $fn_tasmax_10p $savepath $ow
    # Percentage of days when TX > 90th percentile
    ./index_scripts/calculate_etccdi_tx90p_outsample.sh $fn_tasmax $fn_tasmax_90p $savepath $ow
    # ------------------------------------------------------------------------
    # ------------------------------------------------------------------------
    
    #  Percentage of days when TX < 10th percentile.
    ./index_scripts/calculate_etccdi_tx10p_insample.sh $fn_tasmax $savepath $ow
    # Percentage of days when TX > 90th percentile
    ./index_scripts/calculate_etccdi_tx90p_insample.sh $fn_tasmax $savepath $ow
    # Warm speel duration index: Annual count of days with at least 6 consecutive days when TX > 90th percentile
    ./index_scripts/calculate_etccdi_wsdi.sh $fn_tasmax $fn_tasmax_90p $savepath $ow
    
    # --- absolute indices ---
    #  Monthly maximum value of daily maximum temperature.
    ./index_scripts/calculate_etccdi_txx.sh $fn_tasmax $savepath $ow
    # Monthly minimum value of daily maximum temperature.
    ./index_scripts/calculate_etccdi_txn.sh $fn_tasmax $savepath $ow
    # Number of icing days: Annual count of days when TX (daily maximum temperature) < 0C.
    ./index_scripts/calculate_etccdi_id.sh $fn_tasmax $savepath $ow
    # Number of summer days: Annual count of days when TX (daily maximum temperature) > 25C.
    ./index_scripts/calculate_etccdi_su.sh $fn_tasmax $savepath $ow

else
    echo "File not found: $fn_tasmax"
fi

# ----------------------------
# --- tasmin-based indices ---
# ----------------------------

if [ -f $fn_tasmin ]; then

    # --- percentile-based indices ---
    # 10 percentile threshold
    # ------------------------------------------------------------------------
    # --- simplified version without bootstrapping ---------------------------
    # ------------------------------------------------------------------------
    out=$(./index_scripts/_calculate_etccdi_tn10p_threshold.sh $fn_tasmin $savepath $ow)
    echo "${out[@]}"
    fn_tasmin_10p=$(echo "${out[@]}" | tail -n 1)  # needed for CSDI
    out=$(./index_scripts/_calculate_etccdi_tn90p_threshold.sh $fn_tasmin $savepath $ow)
    echo "${out[@]}"
    fn_tasmin_90p=$(echo "${out[@]}" | tail -n 1)
    #  Percentage of days when TN < 10th percentile.
    ./index_scripts/calculate_etccdi_tn90p_outsample.sh $fn_tasmin $fn_tasmin_90p $savepath $ow
    # Percentage of days when TN > 90th percentile.
    ./index_scripts/calculate_etccdi_tn10p_outsample.sh $fn_tasmin $fn_tasmin_10p $savepath $ow
    # ------------------------------------------------------------------------
    # ------------------------------------------------------------------------
    
    #  Percentage of days when TN < 10th percentile.
    ./index_scripts/calculate_etccdi_tn10p_insample.sh $fn_tasmin $savepath $ow
    # Percentage of days when TN > 90th percentile.
    ./index_scripts/calculate_etccdi_tn90p_insample.sh $fn_tasmin $savepath $ow
    # Cold speel duration index: Annual count of days with at least 6 consecutive days when TN < 10th percentile
    ./index_scripts/calculate_etccdi_csdi.sh $fn_tasmin $fn_tasmin_10p $savepath $ow
    
    # --- absolute indices ---
    # Monthly maximum value of daily minimum temperature.
    ./index_scripts/calculate_etccdi_tnx.sh $fn_tasmin $savepath $ow
    # Monthly minimum value of daily minimum temperature.
    ./index_scripts/calculate_etccdi_tnn.sh $fn_tasmin $savepath $ow
    # Number of frost days: Annual count of days when TN (daily minimum temperature) < 0C.
    ./index_scripts/calculate_etccdi_fd.sh $fn_tasmin $savepath $ow
    # Number of tropical nights: Annual count of days when TN (daily minimum temperature) > 20C.
    ./index_scripts/calculate_etccdi_tr.sh $fn_tasmin $savepath $ow

else
    echo "File not found: $fn_tasmin"
fi

# ------------------------
# --- pr-based indices ---
# ------------------------

if [ -f $fn_pr ]; then
    
    # --- percentile-based indices ---
    # Annual total PRCP when RR > 95p.
    ./index_scripts/calculate_etccdi_r95p.sh $fn_pr $savepath $ow
    # Annual total PRCP when RR > 99p.
    ./index_scripts/calculate_etccdi_r99p.sh $fn_pr $savepath $ow
    
    # --- absolute indices ---
    # Maximum length of dry spell, maximum number of consecutive days with RR < 1mm.
    ./index_scripts/calculate_etccdi_cdd.sh $fn_pr $savepath $ow
    # Maximum length of wet spell, maximum number of consecutive days with RR ≥ 1mm.
    ./index_scripts/calculate_etccdi_cwd.sh $fn_pr $savepath $ow
    #  Total precipitation in wet days:
    ./index_scripts/calculate_etccdi_prcptot.sh $fn_pr $savepath $ow
    # Annual count of days when PRCP≥ 10mm.
    ./index_scripts/calculate_etccdi_r10mm.sh $fn_pr $savepath $ow
    # Annual count of days when PRCP≥ 20mm.
    ./index_scripts/calculate_etccdi_r20mm.sh $fn_pr $savepath $ow
    # Monthly maximum 1-day precipitation.
    ./index_scripts/calculate_etccdi_rx1day.sh $fn_pr $savepath $ow
    # Monthly maximum consecutive 5-day precipitation
    # (and: number of 5 day period with precipitation totals greater than 50 mm)
    ./index_scripts/calculate_etccdi_rx5day.sh $fn_pr $savepath $ow
    # Simple pricipitation intensity index: Let RRwj be the daily precipitation amount on wet days, w (RR ≥ 1mm) in period j.
    ./index_scripts/calculate_etccdi_sdii.sh $fn_pr $savepath $ow
    
    # Optional: Annual count of days when PRCP≥ nnmm, nn is a user defined threshold

else
    echo "File not found: $fn_pr"
fi

# -------------------------
# --- tas-based indices ---
# -------------------------

if [ -f $fn_tas ]; then

    # Growing season length: Annual (1st Jan to 31st Dec in Northern Hemisphere (NH), 1st July to 30th June in Southern Hemisphere (SH)) count between first span of at least 6 days with daily mean temperature TG>5C and first span after July 1st (Jan 1st in SH) of 6 days with TG<5C.
    ./index_scripts/calculate_etccdi_gsl.sh $fn_tas $fn_mask $savepath $ow

else
    echo "File not found: $fn_tas"
fi

# --------------------------------------
# --- tasmax- & tasmin-based indices ---
# --------------------------------------

if [ -f $fn_tasmax ] && [ -f $fn_tasmin ]; then
    
    # Daily temperature range: Monthly mean difference between TX and TN.
    ./index_scripts/calculate_etccdi_dtr.sh $fn_tasmax $fn_tasmin $savepath $ow

else
    echo "At lest one file not found: $fn_tasmax $fn_tasmin"
fi

echo
echo "-----------------------------------"
echo "--- Finished running subscripts ---"
echo "-----------------------------------"
echo

# Capture the end time
end_time=$(date +%s)
# Calculate the duration in seconds
duration=$((end_time - start_time))
# Convert the duration to hh:mm:ss format
hours=$((duration / 3600))
minutes=$(( (duration % 3600) / 60 ))
seconds=$((duration % 60))

# Print the duration in hh:mm:ss format
printf "Script ran for %02d:%02d:%02d\n" $hours $minutes $seconds