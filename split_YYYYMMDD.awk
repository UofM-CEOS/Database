#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2014-09-17T17:07:20+0000
# Last-Updated: 2018-11-21T19:59:19+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# Split large tables from the database into daily files, provided the first
# column is ISO date (YYYY-MM-DD and optional time stamp).
#
# Make sure to set FS and OFS as desired.
#
# Example call (writing file in current directory):
#
# gawk -f split_YYYYMMDD.awk navigation_1min_2013.csv
#
# Or piping from psql:
#
# \copy (SELECT * FROM navigation_1min_2013) TO PROGRAM 'awk -f split_YYYYMMDD.awk -' CSV HEADER
# -------------------------------------------------------------------------
# Code:

BEGIN {
    if (! fprefix) fprefix="NAV"
}

NR == 1 {
    hdr=$0
    next
}

{
    split($1, dt, /[: -]/)
    fn=sprintf("%s_%s%s%s.csv", fprefix, dt[1], dt[2], dt[3])
    if (!fns[fn]++) {
	print hdr > fn
    }
    print > fn
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
