#!/bin/bash
#SBATCH -p a024h
#SBATCH -n 12
#SBATCH -t 0:10:00
#SBATCH -N 1
#SBATCH -J PHASE0
#SBATCH -o stdout.%J.log
#SBATCH -e stderr.%J.log

module load MPI-impi-18.3.222

PHASE=~/phase0_2021.02/bin/phase

mpirun -n 12 $PHASE # ne=1 nk=12
