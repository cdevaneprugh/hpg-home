# hpg-home
Notes for the install of CESM on HPG.

1. Clone the repo - 2.1.5 is current supported production version
$ git clone -b release-cesm2.1.5 https://github.com/ESCOMP/CESM.git cesm_215


2. Checkout version 2.1.5
$ git checkout release-cesm2.1.5

3. Download all externals and CIME
* downloads to /path/to/cesm_215
* need to load `subversion v1.9.7` module first
$ module load subversion/1.9.7

Now, in the cesm_215 directory
$ ./manage_externals/checkout_externals

Verify externals install
$ ./manage_externals/checkout_externals -S

4. Test MPI environment
* use scripts in mpi_testing/ 
* check to make sure compilers, & bindings work properly

5. Machine config file for HPG

6. Defining libraries and program paths in the config file
* I'm going to use the environment variables instead of full path in case the hpg changes locations in the future.
* Process is to load needed modules, view the set environment variables, set them in the config file.
* Additionally, I'll save them in a list in my lmod directory to load in a slurm environment.

Problems:
* Filling out the config file is a bit confusing, there are several conventions and variables that don't make sense.
* One is the 'init_path' variable, it seems to be unique to module systems.
	- I found the path where HPG has it set up '/apps/lmod/lmod/init'
	- There are also libexec and other directories that are specific to lmod in there.
* I'm also getting some regex issue when running the regression tests. I'll come back to this after I figure out the config more.
* CIME seems to want to have control of the modules rather than letting our module system load it.
	- going to try a few variations, loading all modules ourselves, loading then purging and reloading with the config file, etc 

7. Going to delete the cesm repo and try downloading it again. Will leave the default config as simple as possible.

8. Step 7 didn't work, support ticket opened with HPG. Going to try their suggestion.

9. HPG support suggestion failed, going to install different versions of cesm in parallel and compare their test folders.

10. Fixed by adjusting nodename regex. Different errors show up depending on depth of the regex error.

11. Found similar machines to build our config files off of.

12. Ran the regression test again, had some failures. There's still a bunch of
config options I don't quite understand. Going to try some things.

13. Was getting an error in the regression tests for a "cori-haswell" not found.
Found a potential fix in the cesm forums. 

https://bb.cgd.ucar.edu/cesm/threads/porting-cesm-to-a-new-machine-configuration-problem-not-using-module.9355/#post-54053

Trying this out to see how it goes. I wonder if cesm checks out an alpha branch
of cime rather than a maint branch

It worked! No more weird cori-haswell error.

14. At the end of the regression test it lists many failures in the phase HAREDLIB_BUILD

Possible issue with new gnu compiler. Trying this:

https://bb.cgd.ucar.edu/cesm/threads/questions-on-ntasks-rootpe-and-submission.9264/#post-53985

15. Looks like cmake macro errors have vanished. Still working on issue in 14, will keep trying things.

16. Added config_batch xml file to work towards getting cesm to interact with slurm. Certainly not ready for testing yet

17. Got batch system configured. Model runs almost all regression tests. Seems to just be failing at building some shared library.

Possible causes:
* fortran compiler flag (issues with newer gcc version)
* netcdf issue (maybe wrong versions are loaded)
* lapack issue
* hd5f issue (maybe I don't need to point to it separately from netcdf)

18. Going to rework all .cime files. (go over them again and see if I missed anything)
19. Also noticed a perl error. Going to maybe not load a perl module and see if default location covers it. There was also something in the default configs to define the perl location, maybe look at what that variable is.
* this solved itself somewhow. not sure what happened. I checked and all perl libraries needed for cesm and e3sm are present.

20. Had call with HPG support, they requested I submit a ticket so we could dig in to the problem in depth. They also suggested I try a conda environment to see if I could get things to play nicely together.
I also tried updating the config files with the absolute paths, rather than relative ones. Still had no luck.
21. After talking with Jim at the CESM discussion forum, he confirmed it is a fortran compiler and netcdf issue.
22. Tried building an environment around gcc/8.2.0 with dedicated netcdf-c and netcdf-f libraries but had no luck.
Got an error while loading a shared library libpmix.so.2. HPG site says it is no longer supported on current version of red hat.
Hit the error when trying to compile a hello world fortran program with openmpi/4.0.1
Their site suggests using gcc 12 and openmpi 4.1.5
23. I think the best thing to do is actually ask the HPG support team to build current versions of netcdf-c and netcdf-f specifically with the gcc/12.2.0 compiler and openmpi/4.1.5.
This would give us an environment that has all the needed netcdf libraries, lapack, blas, trilinos, and esmf if needed.
Also gcc/12.2.0 is fully supported by e3sm. Having the same environment for both would simplify things greatly. 
24. Just took another shot at setting up intel compiles. Got a library to build for the first time. It found netcdf-c and netcdf-f just fine. This might actually work going forward.
25. Running full regression test, there seems to be an issue with the cprnc tool not being present. I may just have to specify a path in the configs.
I may also have to clone the repo and build it manually.
26. Added cprnc path in config_machine.
27. Cloned cprnc github repo and built from source. Regression tests now pass all but one test.
* Test passed when run individually.
28. Moved on to building cesm in a shared group folder. Keeping more detailed instructions in a file in that directory.
* Goal is to have a shared folder for all earth models cesm and e3sm
29. With the regression scripts passed I can move on to verification of the port by running the ect tests.
* Had issues with the tests. The POP test seems to fail somewhere in the compute node. Additionally, the nco tool can't seem to add metadata to the .nc files after the runs are completed.
* Going to check to see if our netcdf versions are compatible with our nco version
* I should take another look at seeing if the lapack libraries need to be linked in the compiler config files.
30. Set up a conda environment with a newer version of nco and python 3.8 and was able to add metadata to the .nc files.

Following from https://www.cesm.ucar.edu/models/cesm2/python-tools

Had to load python-core/2.7.14 as python3 is not compatible wih script.

Generate three runs for CAM and one for POP

UF-CAM-ECT

python ensemble.py --case /blue/gerber/cdevaneprugh/earth_model_output/cime_output_root/case.cesm_tag.uf.000 --ect cam --uf --mach hipergator --compset F2000climo --res f19_f19_mg17 --compiler intel

POP-ECT

python ensemble.py --case /blue/gerber/cdevaneprugh/earth_model_output/cime_output_root/popcase.cesm_tag.000 --ect pop --mach hipergator --compset G --res T62_g17 --compiler intel

Add metadata to files

./addmetadata.sh --caseroot /blue/gerber/cdevaneprugh/earth_model_output/cime_output_root/case.esm_tag.uf.000 --histfile /blue/gerber/cdevaneprugh/earth_model_output/cime_output_root/case.cesm_tag.uf.000/run/case.cesm_tag.uf.000.cam.h0.0001-01-01-00000.nc

Had issues with the case not being submitted due to QOS limits. Lowered max tasks to 10 in the machine config files.

This seemed to work for the ECT tests, but the POP tests still failed on the compute node.

* They were not able to be verified by the cesm tool as it said v2.1.5 was not supported. I wonder if that tool is still only set up to go to v2.1.3

31. I notified the CESM people of this and they said this was an issue on their end, they're looking to fix it now.
32. CESM team fixed the verification tool, it appears that our UF-ECT tests passed even though some of the components were out of spec.
33. With netcdf-f support added with gcc, we can proceed with gnu support.
* Initial tests look promising. Still need to run the full regression tests.
34. Full regression tests are passed. I ran the UF-CAM-ECT tests and just need to verify them on the website or with the local tool. Havent ran the POP-ECT test yet as it takes awhile to complete (~6 hrs).
35. Max tasks/core usage issue. Currently having an issue with CIME trying to request way too many cores from the scheduler. 
Ideally it should be set up so that in config_machines.xml, max tasks per node should be set at the number of cores on the hpg-default compute node (128 cores per node). 
Then in config_batch.xml jobmax for the default queue should be set at our max number of cores in the qos. The burst queue should then have jobmax equal the number of max cores in our burst qos.

The issue that's happening is that CIME keeps asking for 128 cores (or sometimes two full nodes of 128 cores) to run the regression and ECT tests.
I don't know if this is just the testing suite that will do this, and when we build our own experiments we won't have any issues, or if this will be a constant problem.

The temporary solution I have now is to set the max tasks tag in h config_machines.xml to be half of our default qos (10 cores).
This lets CIME ask for 2 nodes of 10 cores and the tests will run just fine.

Someting I should try is to change the config files to the way they should be set up (128 cores/node in config_machines) and then manually change the amount of cores & nodes using ./xmlchange before running the case.
Running the regression tests should go something like:

`$ ./script_regression_tests --no-batch`

`$ cd cime_output_root`

`$ ./xmlchange cores nodes etc`

`$ ./case.submit`

For the ECT tests I may have to scancel the tests as they automatically get submitted. Then I can adjust the number of nodes and resubmit.
