#!/bin/bash
#SBATCH -p a024h
#SBATCH -n 12
#SBATCH -t 0:10:00
#SBATCH -N 1
#SBATCH -J PHASE0
#SBATCH -o stdout.%J.log
#SBATCH -e stderr.%J.log

source /home1/share/opt/intel-2023.0.0/setvars.sh

PHASE=~/phase0_2024.01/bin/phase

mpirun -n 12 $PHASE # ne=1 nk=12
