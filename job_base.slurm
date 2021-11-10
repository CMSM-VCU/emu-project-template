#!/bin/bash

#SBATCH --job-name=TITLE
#SBATCH --output=%x-%j.out
#SBATCH --account=[ACCOUNT]
#SBATCH --mail-type=ALL
#SBATCH --mail-user=[EMAIL ADDRESS]
#SBATCH --partition=standard
#SBATCH --mem=30gb

#SBATCH --ntasks=NPROCS
#SBATCH --time=02:00:00

echo $SLURM_JOB_NAME
echo $SLURM_JOB_ID

# Set up output directory in home
PROJECTDIR=[REPLACE THIS WITH ABSOLUTE PATH TO PROJECT FOLDER]

JOBID=$(echo $SLURM_JOB_ID | cut -d '.' -f 1)
JOBDIR=${PROJECTDIR}${SLURM_JOB_NAME}.${JOBID}

echo $PROJECTDIR
echo $JOBID
echo $JOBDIR

mkdir $JOBDIR

# Copy files to working directory
cd $JOBDIR

cp -t . ${PROJECTDIR}base_folder/* -r
cp -vt . ${PROJECTDIR}inputs/$SLURM_JOB_NAME.in

# Following section may not be necessary in the future!
cd /xdisk/guven/RH_projects/emu_dev/emu/
source ./util/puma_config.bsh
cd $JOBDIR


# Run
date
mpirun -verbose -np $SLURM_NTASKS ./bin/emu ./$SLURM_JOB_NAME.in
date

# Example:
# cd ./plotfiles
# python ../../emu_to_h5.py
# cd ..
# mkdir ../outputs/${SLURM_JOB_NAME}.${JOBID}
# cp -t ../outputs/${SLURM_JOB_NAME}.${JOBID} ./$SLURM_JOB_NAME.in ./emu.out.0.0 ./emu.his ./plotfiles/simulation.h5

exit
