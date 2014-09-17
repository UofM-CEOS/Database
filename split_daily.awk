#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian P. Luque
# Created: 2014-09-17T17:07:20+0000
# Last-Updated: 2014-09-17T17:12:08+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
# 
# Split large tables from the database into daily files, provided the first
# column is ISO timestamp.
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
    fprefix="NAV"
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
# 
# split_daily.awk ends here
