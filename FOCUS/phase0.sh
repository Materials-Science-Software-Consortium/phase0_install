#!/bin/bash
#SBATCH -p h006m
#SBATCH -t 0:06:00
#SBATCH -n 16
#SBATCH -N 2
#SBATCH -J PHASE0
#SBATCH -o stdout.%J.log
#SBATCH -e stderr.%J.log

source /home1/share/x86_64/el8/intel/oneapi-2024.1.0/setvars.sh

PHASE=~/phase0_2025/bin/phase

mpirun -n 16 $PHASE # ne=1 nk=16
