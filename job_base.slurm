#!/bin/bash

# --- Replace text in [brackets] with the relevant information! ---
# --- TITLE and NPROCS are automatically replaced by new_job.sh ---

# --- Make sure the name of the Emu executable below matches yours ---

# Slurm options
#SBATCH --account=[ACCOUNT]
#SBATCH --mail-user=[EMAIL ADDRESS]
#SBATCH --partition=basic
#SBATCH --mail-type=ALL
#SBATCH --output=%x-%j.out
#SBATCH --job-name=TITLE
#SBATCH --mem=30gb

#SBATCH --ntasks=NPROCS
#SBATCH --time=02:00:00

echo $SLURM_JOB_NAME
echo $SLURM_JOB_ID

# Jobs are typically named name.ID - Extract ID by splitting on the period
JOBID=$(echo $SLURM_JOB_ID | cut -d '.' -f 1)
JOBDIR=${PROJECTDIR}/${SLURM_JOB_NAME}.${JOBID}

echo $PROJECTDIR
echo $JOBID
echo $JOBDIR

mkdir $JOBDIR

# Copy files to working directory
cd $JOBDIR

cp -t . ${PROJECTDIR}/base_folder/* -r
cp -vt . ${PROJECTDIR}/inputs/$SLURM_JOB_NAME.in

# System-specific setup
# e.g. for Huff:
cd ~/real/projects/emu_dev/emu/
source ./util/huff_config.bsh
cd $JOBDIR

# Run
date
mpirun -verbose -np $SLURM_NTASKS ./bin/emu ./$SLURM_JOB_NAME.in
date

# Postprocess
cd ..
./postprocess.sh ${SLURM_JOB_NAME}.${JOBID}

exit
