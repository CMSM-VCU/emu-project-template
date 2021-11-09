#!/bin/bash
# Input file name without extension is first argument

function yes_or_no() {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

if [ $# -eq 0 ] ; then
    echo "No argument given"
else
    for job in "$@"
    do
        yes_or_no "Submit $job for debug?" && {
        cp job_base.slurm ./job_scripts/job/job_$job.slurm

        cd ./slurm_scripts/job
        sed -i -e 's/'"TITLE"'/'"$job"'/' job_$job.slurm
        sbatch job_$job.slurm

        cd ../..
        }
    done
fi
