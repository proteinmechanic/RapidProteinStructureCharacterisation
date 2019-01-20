#!/usr/bin/python
# :: 2019-01-15
import os,sys
from tqdm import tqdm
import numpy as np
import subprocess


fin = sys.argv[1]
with open(fin.split('_')[0] + '_SCOP_CATH.dat','a') as f:
	f.write('PDB\tChain\tRes\tQ_score\tRMSD\tRes(Aligned)\tCATH\tSCOP\n')
d_ = np.genfromtxt(fin,dtype=str,skip_header=1)

d_0 = []
for i in d_:
	d_0.append(i[0][3:7] + '_' + i[1])
c_ = 0
for i in tqdm(d_0):
	c_str = i.split('_')[0] + i.split('_')[1]
	s_str = i.split('_')[0] + i.split('_')[1].lower()
	S_,C_ = "N/A","N/A"
	#######################################################
	res_C = subprocess.Popen(["grep",c_str,"cath-domain-list-S100.txt"],stdout=subprocess.PIPE).stdout.read()
	if len(res_C) > 0:
		# May have multiple domains. List all. 
		res_Cl = res_C.split('\n')[0:-1]
		CATH = []
		for j in res_Cl:
			j_ = j.split()
			CATH.append('.'.join(j_[1:5]))
		C_ = ';'.join(CATH)
	#######################################################
	res_S = subprocess.Popen(["grep",s_str,"dir.cla.scope.2.07-stable.txt"],stdout=subprocess.PIPE).stdout.read()
	if len(res_S) > 0:
		# May have multiple domains. List all. 
		res_Sl = res_S.split('\n')[0:-1]
		SCOP = []
		for j in res_Sl:
			j_ = j.split()
			SCOP.append(j_[3])
		S_ = ';'.join(SCOP)
	with open(fin.split('_')[0] + '_SCOP_CATH.dat','a') as f:
		f.write(d_[c_][0][3:7] + "\t" + d_[c_][1] + "\t" + d_[c_][2] + "\t" + d_[c_][3] + "\t" + d_[c_][4] + "\t" + d_[c_][5] + "\t" + C_ + "\t" + S_ + '\n')
	c_ += 1

os.system('rm ' + fin)
