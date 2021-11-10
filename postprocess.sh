#!/bin/bash


if [ $# -eq 0 ] ; then
    echo "No argument given"
else
    for job in "$@"
    do
        # This is just an example:
        # mkdir ./outputs/$job
        # cd ./$job/plotfiles
        # python ../../emu_to_h5.py

        # cd ..
        # cp -t ../outputs/$job ./emu.out.0.0 ./*.in ./emu.his ./plotfiles/simulation.h5

        # cd ..
    done
fi
