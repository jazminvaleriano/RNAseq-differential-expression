#!/bin/bash

#SBATCH --job-name="AlignmentQC"
#SBATCH --cpus-per-task=4
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --partition=pall

##pendiente
module load UHTS/Quality_control/RSeQC/4.0.0;

