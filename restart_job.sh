#!/bin/bash
# Input file name without extension is first argument
scheduler="slurm"

case $scheduler in
    "slurm")
        ext="slurm"
        submit_command="sbatch --export=ALL,PROJECTDIR=$PWD"
        ;;
    "qsub")
        ext="qsub"
        submit_command="qsub -v PROJECTDIR=$PWD"
        ;;
    *)
        echo Unkown scheduler $scheduler
        exit 1
        ;;
esac

function yes_or_no() {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

function processors_needed() {
    # Get the line after the 'processors' keyword in the input file
    # Extract the first three whitespace-separated things (They /should/ be numbers!)
    # Make SURE there is no more whitespace, and multiply the numbers together
    var="$(tail -1 <<< "$("grep" -A 1 -hi "processors" ./inputs/$1.in)")"
    var2="$(tr -d '\r' <<< $(echo $var | xargs))"
    x=$(cut -d ' ' -f 1 <<< $var2)
    y=$(cut -d ' ' -f 2 <<< $var2)
    z=$(cut -d ' ' -f 3 <<< $var2)
    x="$(echo $x | xargs)"
    y="$(echo $y | xargs)"
    z="$(echo $z | xargs)"
    ((t=x*y,np=t*z))
    echo "$np"
}

if [ $# -lt 3 ] ; then
    echo "Need case name, timestep, and previous job number"
else
    job=$1
    timestep=$2
    prevjob=$3
    num_procs="$(processors_needed $job)"

    yes_or_no "Submit $job ($num_procs processors) for restart?" && {
    cp restart_base.$ext ./job_scripts/restart/restart_$job.$ext

    cd ./job_scripts/restart
    sed -i -e 's/'"TITLE"'/'"$job"'/' restart_$job.$ext
    sed -i -e 's/'"__TIMESTEP"'/'"$timestep"'/' restart_$job.$ext
    sed -i -e 's/'"__PREVJOB"'/'"$prevjob"'/' restart_$job.$ext
    sed -i -e 's/'"NPROCS"'/'"$num_procs"'/' job_$job.$ext
    $submit_command job_$job.$ext

    cd ../..
    }
fi
