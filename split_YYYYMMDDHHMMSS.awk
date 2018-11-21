#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2014-05-02T03:01:07+0000
# Last-Updated: 2018-11-21T20:00:44+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# Split large flux table into each period.  A file prefix string is
# prepended to construct the output file name.  Default is "EC".
#
# Make sure to set FS and OFS as desired.
#
# Example call (writing file in current directory):
#
# gawk -f split_YYYYMMDDHHMMSS.awk flux_10hz_2013.csv
#
# Or piping from psql:
#
# \copy (SELECT * FROM flux_10hz_2011) TO PROGRAM 'split_YYYYMMDDHHMMSS.awk -v fprefix=EC -' CSV HEADER
# -------------------------------------------------------------------------
# Code:

BEGIN {
    if (! fprefix) fprefix="EC"
}

NR == 1 {
    hdr=$0
    next
}

FNR > 1 {
    split($1, dt, /[: -]/)
    fn=sprintf("%s_%s%s%s%s%s%s.csv", fprefix, dt[1], dt[2], dt[3],
	       dt[4], dt[5], dt[6])
    if (!fns[fn]++) {
	print hdr > fn
    }
    print > fn
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
