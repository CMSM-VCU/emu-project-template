# emu-project-template

## Setup

### Cloning

This repository will become your project folder. Clone it wherever you want to store your project.

``` plaintext
cd where/my/project/goes/
git clone https://github.com/CMSM-VCU/emu-project-template.git
```

Rename the repository folder to whatever you want to name your project. Then enter the folder.

``` plaintext
mv ./emu-project-template/ ./projectname/
cd ./projectname/
```

Git will not be useful once the template is in use, so delete the `.git/` folder. (Note that `.git/` will not be visible without using `ls -a` or similar.)

``` plaintext
rm -rf ./.git/
```

Place your Emu executable file in the `base_folder/bin/` folder.

``` plaintext
cp my/executable/emu ./base_folder/bin/emu
```

### Script Configuration

The template has submission scripts set up for the SGE (qsub) and Slurm job schedulers, named accordingly. Use whichever one applies to your system.

The submission scripts require certain parameters to be inserted. These are marked in brackets `[]`. Additionally, ensure that the Emu executable name used in the script matches the name of your actual executable.

**The requested job duration is in these scripts. You will need to adjust that for your own usage.**

The other job scheduler options may need further changes on a per-system basis. 

`new_job.sh` needs to know which job scheduler you are using, indicated by the `ext` and `submit_command` variables at the top of it. It defaults to Slurm. To change it to SGE/qsub, change the value of both variables to `"qsub"`.

At this point, the template is ready to use.

## Usage

In addition to the Emu executable, the template expects the grid files and input files to be stored in specific folders, shown here:

``` plaintext
project/
├─ base_folder/
│  ├─ bin/          <- emu executable(s)
│  ├─ grid_files/   <- all grid files
│  ├─ plotfiles/
│  ├─ restart/
├─ inputs/          <- all input files
├─ job_scripts/
├─ outputs/
```

> All of the grid files are copied for every case. Be careful when using very large grids.

With an input file in `./inputs/` and its grid file(s) in `./base_folder/grid_files/`, the case can now be started using `new_job.sh`. Assuming the name of the input file is `case_001.in`:

``` plaintext
./new_job.sh  case_001
```

The script will then ask for confirmation, and the job will be submitted. The script reads the number of processors requested by the input file and includes that in the confirmation prompt.

Multiple cases can be submitted at once, and the script will ask for confirmation on each one.

``` plaintext
./new_job.sh case_001 case_002 case_003
```

> The arguments of `new_job.sh` are the name of the input file *without* its extension or its folder. Accordingly, the script assumes that the extension of all input files is `.in` and that they are in the `./inputs/` folder.

The script will indicate a successful submission and show the job name.

> :exclamation: A case *submitting* successfully is separate from a case *running* successfully. Monitor your jobs after submission to ensure the simulation is actually running.

# Other Notes

## Debugging

`new_job.sh` edits the `job_base.*` script and saves it as a new script. The edited scripts, which are the actual input to the job scheduler, are stored in `./job_scripts/job/`. Each job has its terminal output written to a file. These output files are also stored in `./job_scripts/job/`.

If a job fails or ends unexpectedly, these files can be used to find the issue.
