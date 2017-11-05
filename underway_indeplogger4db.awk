#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-11-04T21:35:25+0000
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details on loading output.
#
# This prepares data from independent logger collecting sensor data
# associated with underway system.  External temperature is a typical
# example.
#
# For CR1000 TOA5 table output in 2017, the structure is assumed as:
#
# [1] timestamp ["YYYY-MM-DD HH:MM:SS"]
# [2] record number [D+]
# [4] battery voltage [D+]
# [4] logger temperature [D+]
# [5] water temperature [D+]
#
# Example:
#
# ./underway4db_indeplogger.awk * > output.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ncols=5			# number of columns
    print "time,record_number,battery_voltage,logger_temperature",
	"water_temperature"
}

NF > ncols || $1 !~ /[[:digit:]]/ { next } # obviously garbage

{				# skip if we have any garbage
    for (i=1; i <= NF; i++) {
	if ($i !~ /[[:alnum:]]/) next
    }
}

FNR > 4 {
    for (i=1; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
