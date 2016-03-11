#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-09-03T17:58:13+0000
# Last-Updated: 2016-03-11T20:45:08+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# This is meant to split the files generated by the *4db.awk scripts into
# subsets based on program version.  The program expects the variable
# PROGCOL, indicating in what column the program version is found.
#
# Example call:
#
# split_on_progversion.awk -v PROGCOL=3 *.csv
# -------------------------------------------------------------------------
# Code:

BEGIN { FS=OFS="," }

FNR == 1 {
    header=$0
    fnn=split(FILENAME, prefix_arr, /\./)
    prefix=prefix_arr[1]
    for (i=2; i < fnn; i++) {
	prefix=prefix "_" prefix_arr[i]
    }
    next
}

FNR > 1 {
    prog_version=sprintf("%.1f", gensub(/"/, "", "g", $PROGCOL))
    fn=prefix "_" prog_version ".csv"
    if ((newprog != prog_version) && !(prog_version in versions)) {
	print header > fn
    }
    versions[prog_version]++	# tally versions seen
    newprog=prog_version
}

{ print > fn }



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
