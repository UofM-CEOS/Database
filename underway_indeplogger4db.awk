#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-11-04T21:35:25+0000
# Last-Updated: 2016-03-26T02:09:17+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details on loading output.
#
# This prepares data from independent logger collecting sensor data
# associated with underway system.  External temperature is a typical
# example.
#
# Example:
#
# ./underway4db_indeplogger.awk * > output.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ncols=10			# number of columns
    print "time,battery_voltage,logger_temperature,water_temperature",
	"battery_voltage_sd,logger_temperature_sd,water_temperature_sd"
}

NF > ncols || $1 !~ /[[:digit:]]/ { next } # obviously garbage

{				# skip if we have any garbage
    for (i=1; i <= NF; i++) {
	if ($i !~ /[[:alnum:]]/) next
    }
}

{
    hms=sprintf("%04d00", $4)
    if (hms == "240000") {
	$3++
	hms="000000"
    }
    yyyymmdd=strftime("%F", mktime($2 " 1 " $3 " 0 0 0"))
    dtime=sprintf("%s %02d:%02d:%02d", yyyymmdd,
		  substr(hms, 1, 2),
		  substr(hms, 3, 2), substr(hms, 5, 2))
    printf "%s,", dtime		# ignore first useless column constant
    # Print commas to get the same number of (ncols) fields always
    for (i=5; i <= (ncols - 1); i++) { printf "%s,", $i }
    printf "%s\n", $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
