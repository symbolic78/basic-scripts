#!/opt/local/bin/tclsh
# Report Toggl csv Data into a more useful format
#
# Usage: toggl-reporter.tcl <toggl-csv-file>
#

# HMS2seconds
# Convert a hours:mins:seconds string to seconds

proc HMS2seconds {s} {
   set hours [string trimleft [lindex [split $s :] 0] 0]
   if {$hours == ""} {  set hours 0  }
   set mins [string trimleft [lindex [split $s :] 1] 0]
   if {$mins == ""} {  set mins 0  }
   set secs [string trimleft [lindex [split $s :] 2] 0]
   if {$secs == ""} {  set secs 0  }
   return [expr ($hours*3600)+($mins*60)+$secs]
}

# SEC2HMS
# Convert seconds to hr, min, seconds

proc sec2hms s {
   set hours [expr $s / 3600]
   set time  [expr $s - ($hours * 3600)]
   set mins  [expr $time/60]
   set secs  [expr $time - ($mins * 60)]

   return [format "%dh %2dm %02ds" $hours $mins $secs]
}

# MAIN starts here

if {$argc != 1} {
   puts stderr "usage: toggl-reporter.tcl <csv-input-file>"
   exit 1
}

# try to open input file

if {[catch {open [lindex $argv 0]} csv] != 0} {
   puts stderr $csv
   exit 2
}

# read data and create a cache
# format is client, project, registered-time, billable-time, amount

# create list of projects with time

set ignorefirst 1		;# ignore the first line
while {[gets $csv line] != -1} {
   if {$ignorefirst} {
      set ignorefirst 0
      continue
   }
   set fields [split $line ,]
   lappend projectList [list [lindex $fields 1] [HMS2seconds [lindex $fields 2]]]
   incr totalSeconds [HMS2seconds [lindex $fields 2]]
   incr clientTime([lindex $fields 0]) [HMS2seconds [lindex $fields 2]]
 }

# print projects, ordered from highest to lowest, showing percentage time spent

puts "Time Spent by Individual Item, highest first:"

foreach project [lsort -decreasing -integer -index 1 $projectList] {
   puts [format "%25s %12s (%3.1f%%)" \
	   [lindex $project 0] \
           [sec2hms [lindex $project 1]] \
	   [expr [lindex $project 1]*100.0/$totalSeconds ] \
        ]
}

# Now print the percentage of time spent in each category (aka client)

# first, create a client list

foreach client [array names clientTime] {
   lappend clientList [list $client $clientTime($client)]
}

puts {}
puts "Time Spent by Category, highest first:"
foreach client [lsort -decreasing -integer -index 1 $clientList] {
   puts [format "%25s %12s (%3.1f%%)" \
	   [lindex $client 0] \
           [sec2hms [lindex $client 1]] \
	   [expr [lindex $client 1]*100.0/$totalSeconds ] \
        ]
}

