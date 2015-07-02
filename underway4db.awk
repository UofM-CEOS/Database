#! /opt/local/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-01-09T21:39:59+0000
# Last-Updated: 2015-06-30T18:48:14+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# 
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS="\t"
    OFS=","
}

FNR > 1 {
    split($4, hms, ":")
    dtime=sprintf("20%s-%s-%s %02i:%02i:%02i", substr($3, 7, 2),
		  substr($3, 4, 2), substr($3, 1, 2),
		  hms[1], hms[2], hms[3])
    printf "24,%s,%s,%s,", dtime, $1, $2
    for (i=5; i <= (NF - 1); i++) {printf "%s,", $i}
    print $NF
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
