#!/bin/bash

echo "Setting environment variables for SCM-CCPP on Cheyenne with icc/ifort"

#load the modules in order to compile the GMTB SCM
echo "Loading intel and netcdf modules..."
module purge
module load ncarenv/1.2
module load intel/17.0.1
module load ncarcompilers/0.4.1
module load netcdf/4.4.1.1

#set the FC environment variable to ifort
echo "Setting the FC environment variable to use ifort"
export FC=ifort

#install f90nml for the local user

#check to see if f90nml is installed locally
echo "Checking if f90nml python module is installed"
python -c "import f90nml"

if [ $? -ne 0 ]; then
	echo "Not found; installing f90nml"
	cd scripts/f90nml-0.19
	python setup.py install --user
	cd ../..
else
	echo "f90nml is installed"
fi
