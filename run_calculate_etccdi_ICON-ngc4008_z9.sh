#!/bin/bash
#SBATCH --job-name ic-et
#SBATCH --account=uc1275
#SBATCH --partition=compute
#SBATCH --constraint=1024G
#SBATCH --mem=980G  # https://docs.dkrz.de/blog/2024/how-to-get-more-memory.html
#SBATCH --time=08:00:00
#SBATCH --output=logfiles/%x-%j.log

module purge

./calculate_etccdi_ICON-ngc4008_z9.sh 
