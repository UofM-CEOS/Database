#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian Luque
# Created: 2014-01-09T21:39:59+0000
# Last-Updated: 2014-08-28T21:53:36+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS="\t"
    OFS=","
    ncols=33			# number of columns
    year=2014
}

NF > ncols || $1 !~ /[[:alpha:]]/ { next } # obviously garbage

{				# skip if we have any garbage
    for (i=1; i <= NF; i++) {
	if ($i !~ /[[:alnum:]]/) next
    }
}

FNR > 1 {
    split($4, hms, ":")
    dtime=sprintf("20%s-%s-%s %02i:%02i:%02i", substr($3, 7, 2),
		  substr($3, 4, 2), substr($3, 1, 2),
		  hms[1], hms[2], hms[3])
    if (substr(dtime, 1, 4) != year) next # we still got garbage
    printf "%s,%s,%s,", dtime, $1, $2
    # Print commas to get the same number of (ncols) fields always
    for (i=5; i <= (ncols - 1); i++) { printf "%s,", $i }
    printf "%s\n", $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# underway4db.awk ends here
