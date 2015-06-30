#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2014-09-17T17:07:20+0000
# Last-Updated: 2015-06-30T18:47:45+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
# 
# Split large tables from the database into daily files, provided the first
# column is ISO date (YYYY-MM-DD and optional time stamp).
#
# Example call (writing file in current directory):
#
# gawk -f split_daily.awk navigation_1min_2013.csv
#
# Or piping from psql:
#
# \copy (SELECT * FROM navigation_1min_2013) TO PROGRAM 'awk -f split_daily.awk -' CSV
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    if (! fprefix) fprefix="NAV"
}

FNR > 1 {
    split($1, dt, /[: -]/)
    fn=sprintf("%s_%s%s%s.csv", fprefix, dt[1], dt[2], dt[3])
    print > fn
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
