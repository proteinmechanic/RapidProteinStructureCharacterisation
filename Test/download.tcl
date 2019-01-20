# This script needs to be run through VMD or through the bash shell (remove second line)

rsync -rlpt -v -z --delete --port=33444 rsync.wwpdb.org::ftp/data/structures/divided/pdb/gg/ ./data/
puts "Database download complete. Process to the next step."


