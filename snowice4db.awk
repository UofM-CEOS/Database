#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian P. Luque
# Created: 2014-09-25T22:01:24+0000
# Last-Updated: 2014-09-26T17:13:13+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# Snow and ice data are typically collected via the multiplexer, so many
# columns for the same variable, but measured at a different depth or some
# other reference.  We need to put them into "long" ("melted") form for
# input into database.
# 
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ncols=36
    widecols_beg=5		# wide columns begin at this index
    print "time,record_number,program_version,logger_temperature",
	"stratum_height,stratum_temperature"
}

{ gsub(/"/, "") }		# remove double quotes everywhere

FNR == 2 {			# the column header row
    for (col=widecols_beg; col <= ncols; col++) {
	sub(/cm$/, "", $col)
	split($col, hdr, /_/)
	if (hdr[1] == "TempIce") {
	    height[col]=-hdr[2]
	} else height[col]=hdr[2]
    }
}

FNR > 4 {
    date_time=$1
    record_number=$2
    program_version=sprintf("%.1f", $3)
    # Convert 1.0 to 1.4 (this was a logger program error)
    if (program_version == "1.0") program_version="1.4"
    for (i=widecols_beg; i <= ncols; i++) {
	printf "%s,%s,%s,%s,", date_time, record_number,
	    program_version, $4
	printf "%s,%s\n", height[i], $i
    }
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# snowice4db.awk ends here
