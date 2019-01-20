#!/usr/bin/python
# :: 2019-01-15
import os,sys
from tqdm import tqdm
import numpy as np
import subprocess

fin = sys.argv[1]

print "Comparing :: " + fin + " :: with everything. Running on a single core. This step may take several hours ..."
print "Please refer to the accompanying README for suggestions on making this faster."

os.system('vmd -dispdev text -eofexit -args < s1.tcl ' + fin + ' > /dev/null 2>&1')

os.system('./s2.py ' + fin.split('.')[0] + '_detailed.log' )
