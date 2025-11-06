# LASSONDE HARDWARE DESIGN CLUB (HDC) WORKSHOP REPO

## Getting started
Note that the below steps assume a linux environment with ModelSim installed.

### Step 0: Setup your workstation
You will need a workstation (duh). You may either use your personal computer with [ModelSim](https://www.intel.com/content/www/us/en/software-kit/750368/modelsim-intel-fpgas-standard-edition-software-version-18-1.html) with [gtkwave](https://gtkwave.sourceforge.net/) to view the VCD waveforms or use one of the linux remote machines [EA machines](https://remotelab.eecs.yorku.ca/#/) provided by the department.

The below steps have been tested on a EA linux machine provided by the department and on a personal linux workstation. If you would like to develop on a windows system, then you will have to develop your own scripts and methodologies to load and test your designs.

### Step 1: Clone the repository
------------------------------------
Open a terminal and execute the following command:
```
git clone git@github.com:IEEEYorkU/hdc-workshops.git
```
You should see a directory named `hdc-workshops` in your current working directory.

### Step 2: Setup the environment
------------------------------------
```
source env.sh
```
This will setup the working environment by setting up the paths to the simulator (ModelSim) and project root directory.
An expected output after executing this command should look like this:
```
===== EECS 4201 Course Environment Setup =====
Location of project:  /cs/home/kaushika/EECS-4201-project
VSIM version:  Model Technology ModelSim - INTEL FPGA STARTER EDITION vsim 2020.1 Simulator 2020.02 Feb 28 2020
```
