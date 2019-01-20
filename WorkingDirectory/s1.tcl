# Before running this you should have downloaded all PDB files from RCSB.
# These will be compressed files arranged into folders contain second and third 
# character of their ID. E.g. PDB 1hv4 will be in folder hv.
# Note, this body of code doesn't verify if the entire PDB database has been download.
# Entire PDB content requires ~20GB (June, 2018)

##########################################
# function to capture details
proc get_stuff {filename} {
	set fp [open $filename r]
	set i 0
	set j 1
	set mx []
	set Q -1
	set R -1
	set N -1
	while { [gets $fp data] >= 0 } {
		if {[lindex [split $data " "] 4] eq "Q:"} {
			set Q [lindex [split $data " "] 6]
		}
		if {[lindex [split $data " "] 5] eq "r.m.s.d:"} {
			set R [lindex [split $data " "] 7]
		}
		if {[lindex [split $data " "] 6] eq "Nalign:"} {
			set N [lindex [split $data " "] 8]
		}
		if {[lindex [split $data " "] 8] eq "Rx"} {
			incr i
		}		
	}
	close $fp
	return [list $Q $R $N]
}
##########################################

#set fp [open s1.supp1 r]
# Generate a list of directories.
set dirs [glob -types d *]

set und_ _

set fmt "%8s %8s %8s %8s %8s %8s"

set ref [lindex $argv 0]

set refid [lindex [split $ref .] 0]_detailed

set file3_ [open $refid.log a]
puts $file3_ [format $fmt Name Chain Residues Qscore RMSD R_align Rx(0_0) Ry(0_1) Rz(0_2) Tx(0_3) Rx(1_0) Ry(1_1) Rz(1_2) Ty(1_3) Rx(2_0) Ry(2_1) Rz(2_2) Tz(2_3)]
close $file3_
foreach data $dirs {
	puts $data
	# make directory by the name of content of $data
	# file mkdir $data
	# package require ftp
	# download content of $data online
	# for each file unzip file
	cd $data
	set list_gz [glob -nocomplain *.gz]
	puts $data
	if {[llength $list_gz] > 0} {
		foreach gz $list_gz {
			set id_ [lindex [split $gz .] 0]
			set pipeline [open "| zcat $gz"]
			set data [read $pipeline]
			set file_ [open $id_.pdb a]
			set file3_ [open ../$refid.log a]
			puts $file_ $data
			close $file_
			close $pipeline
			# parse pdb files and log ID/CHAIN/Protein_LENGTH
			mol load pdb $id_.pdb
			set all [atomselect top all]
			set chains [lsort -unique -dict [$all get chain]]
			foreach ch_ $chains {
				if { $ch_ ne "x" && $ch_ ne "y" && $ch_ ne "z" } {
					puts $ch_
					set chx_ [atomselect top "protein and chain $ch_"]
					set resid [llength [lsort -dict -unique [$chx_ get resid]]]
					# If protein present compare to reference structure and log result
					# else pass
					# delete unzipped file
					if {$resid > 0} {
						$chx_ writepdb $id_$und_$ch_.pdb
						exec superpose $id_$und_$ch_.pdb ../$ref > $id_$und_$ch_.mx
						set out [get_stuff $id_$und_$ch_.mx]
						puts $file3_ [format $fmt $id_ $ch_ $resid [lindex $out 0] [lindex $out 1] [lindex $out 2]]
						file delete -force $id_$und_$ch_.pdb
						file delete -force $id_$und_$ch_.mx
					}
					$chx_ delete
				} else {
					puts $file2_ $id_\t$ch_\t-1
				}
			}
			$all delete
			file delete -force $id_.pdb
			#close $file2_
			close $file3_
		}
	}
	cd ..
}
