#!/bin/sh
#PBS -l walltime=8:00:00
#PBS -l select=1:ncpus=20:mem=360gb

module load anaconda3/personal
source activate r-mortality-process

cd $PBS_O_WORKDIR
Rscript mx_to_e0.R
