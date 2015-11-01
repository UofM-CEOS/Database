#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2015-10-10T21:35:25+0000
# Last-Updated: 2015-10-11T03:08:48+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary:
#
# Prepare thermosalinograph cnv data for loading into database.
#
# Example:
#
# ./TSG4db.awk * > output.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=";"			# These files are semicolon-separated.
    OFS=","
    ncols=12			# number of columns
    print "time,time_gps,latitude,longitude,tsg_temperature,conductivity",
	"salinity,sound_velocity_TSG,water_temperature,fluorescence",
	"water_flow,sound_velocity"
}

NF > ncols || $1 !~ /[[:digit:]]/ { next } # obviously garbage

{				# skip if we have any garbage
    for (i=1; i <= NF; i++) {
	if ($i !~ /[[:alnum:]]/) next
    }
}

{
    gsub(/ +; +/, ",")
    gsub(/\//, "-", $1)
    print
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
