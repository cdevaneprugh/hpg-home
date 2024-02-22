#!/bin/bash
#SBATCH --job-name=cime_test      	     # Job name
#SBATCH --mail-type=START,END,FAIL           # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=cdevaneprugh@ufl.edu     # Where to send mail	
#SBATCH --ntasks=1                           # Run on a single CPU
#SBATCH --mem=1gb                            # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=cime_test_%j.log   # Standard output and error log
#SBATCH --qos=gerber-b		      # Try burst

pwd; hostname; date

echo "running cime regression test"

module load gcc/12.2.0
module load gcc/12.2.0 openmpi/4.1.5
module load gcc/12.2.0 netcdf/4.7.2
module load python/3.11
module load perl/5.24.1
module load subversion/1.9.7
module load git/2.30.1
module load trilinos/14.4.0
module load lapack/3.11.0
module load cmake/3.26.4

python /blue/gerber/cdevaneprugh/my_cesm_sandbox/cime/scripts/tests/scripts_regression_tests.py	

date
