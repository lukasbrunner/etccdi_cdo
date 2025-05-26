#!/bin/bash
#SBATCH --job-name et-km
#SBATCH --account=uc1275
#SBATCH --partition=shared
#SBATCH --ntasks-per-node=32
#SBATCH --mem=50G
#SBATCH --time=12:00:00
#SBATCH --output=logfiles/%x-%j.log

module purge

./calculate_etccdi_IFS-c4.sh 
