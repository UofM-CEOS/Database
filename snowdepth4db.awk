#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian Luque
# Created: 2014-10-03T21:09:06+0000
# Last-Updated: 2014-10-03T21:23:47+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# This is for converting hand-written snow depth data files from the data
# logger to a single CSV file for input into the gases database.  We assume
# that the first two columns of input file are date (YYYY-MM-DD) and time
# (HH:MM:SS), and the first row is a header.  The input variable DEPTHCOL
# is used to specify which column to use as snow depth for the output.
#
# Example call (file written to current directory):
#
# snow4db_cambridge_bay.awk -v DEPTHCOL=3 snow_depth_MET.csv \
#     > snow_depth_MET_1.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    print "time,snow_depth"
}

FNR > 1 {
    gsub(/"/, "")
    date_time=sprintf("%s %s", $1, $2)
    print date_time, $DEPTHCOL
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# snow4db_cambridge_bay.awk ends here
