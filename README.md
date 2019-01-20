## Rapid protein structure categorization

This simple VMD plugin will take an input 3D structure of a protein comprising
standard amino acids and compare it to all structures available in the RCSB
PDB. The final output will list results with comparison statistics and their SCOP
and CATH classifications where available. 

## Getting Started

These instructions will get you up and running on your local machine.

## Prerequisites

VMD can be downloaded from:

https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD

After installing VMD make it available in terminal under the command

"vmd".

Superpose library. This is available here: 

https://launchpad.net/ubuntu/+source/ssm/1.4.0-1)

Alternatively, the program "Superpose" can also be found in the CCP4 suite of programs available here: 

https://www.ccp4.ac.uk/

Once installed from whichever source make it available in terminal under the command

"superpose". 

Python2.7, numpy, tqdm and rsync are also required.

## Characterizing a structure

Multiple steps in this program are hardcoded. Certain things that are assumed
include that the current working directory holds the entire PDB dowloaded from: 

ftp://ftp.wwpdb.org/pub/pdb/data/structures/divided/pdb/

Use any suitable means to download the database. 

A small script included here, download.tcl, can do this as well.

Run the script from the working directory using:

```
vmd -dispdev text -eofexit < download.tcl 
```

The above script makes use of rsync to create a local copy of the RCSB PDB. 

Later parts of the program do not check if the database is complete or not. So
ensure that the entire database has been downloaded.  The test folder includes
a small subset of the entire database which is used to reproduce results in
Test_result_1qys_SCOP_CATH.dat

The latest version of SCOP and CATH annotations (as of 15 Jan, 2019) are
included here. These should be updated quaterly or upon every SCOP/CATH update.
Since the scripts are hardcoded, keep the file names the same as those of the
files included. 

Once everything is installed and the database has been copied, from the working
directory (which holds the database broken into folders and all the scripts)
run the Master script passing it the query structure, as shown below for the test
case.

To run a test case to ensure correct installation, a structure "1qys.pdb" is
included here (Test) with its results (do not download the database in the test
folder - a subset is already present). To run it, first change the permissions
on the python files making them executable:

```
chmod +x *.py
``` 

Then run the Master script, passing it the test query:

```
./Master.py 1qys.pdb
```

This will compare 1qys.pdb to every structure available in the subset of the
database present in the test folder. 

In the case of 1qys.pdb, 1qys_SCOP_CATH.dat will be generated containing all
the hits, Q-score, RMSD, Number of residues aligned, SCOP and CATH.

Note that a single PDB structure can comprise multiple chains. The query
structure must be a single chain. The program internally converts compressed
PDB files into chains and compares the query to each of these. The code is not
tested for multi-chain query structures. It should work but the conclusions
from our work cannot be extended to these results. Furthermore, the comparisons
will take longer. 

## Benchmark

In its current state this program uses only a single core. Based on our tests
using a single core of Intel® Core™ i7-8700 CPU, the comparisons for an average
sized query structure (100 residues) should finish in 11 hours. 

Using multiple cores, the run time can be easily decreased.

While there are many different possibilities to increase the run speed, the
simplest is to divide the 1060 directories in the RCSB PDB database amongst 10
parent directories (with ~106 folders each, assuming 10 cores are available)
and run Master.py within each folder.  This should reduce the run time to close
to one hour. 

## Authors

**Ashar J. Malik**
 
asharjm@bii.a-star.edu.sg

**Jane R. Allison**

j.allison@auckland.ac.nz
## License

Several resources (i.e. SCOP and CATH annotations, VMD, superpose) were used to arrive at results in this program. 
Please consult their respective licences. 
The remainder of this work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

Read about the licence here:

https://creativecommons.org/licenses/by-nc-sa/4.0/

