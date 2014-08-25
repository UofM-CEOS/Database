#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian P. Luque
# Created: 2014-05-02T03:01:07+0000
# Last-Updated: 2014-08-25T21:40:30+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# Split large flux table into each period.
#
# Example call (writing file in current directory):
#
# gawk -f split_flux.awk flux_10hz_2013.csv
#
# Or piping from psql:
#
# \copy (SELECT * FROM flux_10h_2011) TO PROGRAM 'awk -f split_flux.awk -' CSV
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
}

# FNR == 1 {
#     hdr=$0
#     next
# }

FNR > 1 {
    split($1, dt, /[: -]/)
    fn=sprintf("EC_%s%s%s%s%s%s.csv", dt[1], dt[2], dt[3],
	       dt[4], dt[5], dt[6])
    print > fn
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# split_flux.awk ends here
