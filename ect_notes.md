Following from https://www.cesm.ucar.edu/models/cesm2/python-tools

Had to load python-core/2.7.14 as python3 is not compatible wih script.

Generate three runs for CAM and one for POP

## UF-CAM-ECT

`$ cd /blue/gerber/earth_models/cesm215/cime/tools/statistical_ensemble_testing`

`$ python ensemble.py --case /blue/gerber/cdevaneprugh/earth_model_output/cime_output_root/gnu_case.cesm_tag.uf.000 --ect cam --uf --mach hipergator --compset F2000climo --res f19_f19_mg17 --compiler gnu --ns`

This generates the cases without submitting them. 

It is necessary to change some variables before submitting as this will try to use 256 cores (more than our QOS allows).

### Changing xml values to be compatible with our QOS

Do this for each of the three UF-CAM runs generated.

Go the case root.

`cd /blue/gerber/cdevaneprugh/earth_model_output/cime_output_root/gnu_case.cesm_tag.uf.000`

You can check the layout of how many cores each component is set to use and the number of nodes and cores that will be requested by the case batch files using:

`$ ./pelayout`

and

`$ ./preview_run`

We need to change the number of tasks to fit within our burst QOS. I elected to use 128 tasks at most to restrict us to only using one node.

`$ ./xmlchange NTASKS=128`

`$ ./xmlchange NTASKS_ESP=1`

We then need to clean and rebuild the case to regenerate batch scripts.

`$ ./case.setup --reset`

`$ ./case.build --clean`

`$ ./case.build`

You can view all the set variables with:

`$ ./xmlquery --listall`

Then submit the case with

`$ ./case.submit`
