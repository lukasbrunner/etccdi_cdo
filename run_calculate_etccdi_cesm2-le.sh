#!/bin/bash
#SBATCH --job-name etccdi_cesm2-le
#SBATCH --account=uc1275
#SBATCH --partition=shared
#SBATCH --ntasks-per-node=32
#SBATCH --mem=40G
#SBATCH --time=48:00:00
#SBATCH --output=logfiles/%x-%j.log

module purge

./calculate_etccdi_cesm2-le.sh
