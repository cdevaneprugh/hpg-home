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
