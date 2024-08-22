#!/bin/bash
#SBATCH --job-name etccdi_mpi-esm1-2-lr
#SBATCH --account=uc1275
#SBATCH --partition=shared
#SBATCH --ntasks-per-node=32
#SBATCH --mem=40G
#SBATCH --time=02:00:00
#SBATCH --output=logfiles/%x-%j.log

module purge

./calculate_etccdi_mpi-esm1-2-lr.sh
