#!/opt/local/bin/tclsh
#
# script to take a csv file as input which has usernames in the first
# column, and to output every userid to stdout

# MAIN starts here

if {$argc != 1} {
   puts stderr "usage: grab-csv.tcl <csv-input-file>"
   exit 1
}

# try to open input file

if {[catch {open [lindex $argv 0]} csv] != 0} {
   puts stderr $csv
   exit 2
}

# read data and create a cache
# user id should be the first column in the csv

set ignorefirst 1	;#ignore the first line
while {[gets $csv line] != -1} {
   if {$ignorefirst} {
      set ignorefirst 0
      continue
   }
   set userid [lindex [split $line ,] 0]
   puts "/udb/recep/bin/updateudb -L - <<EOF"
   puts "LOGNAME=$userid"
   puts "FLAGS=+P_EXCHMAILBX,+P_EXCHADDRBK"
   puts "MFWDADDR=$userid@nt.city.ac.uk"
   puts "EOF"
}
