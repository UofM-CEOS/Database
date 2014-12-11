#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian Luque
# Created: 2014-11-08T03:49:19+0000
# Last-Updated: 2014-11-10T17:03:33+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
# 
# This prepares the observer log file for loading into database.
#
# Example call (file written in current directory):
#
# ./observer_log_4db.awk observer_log_2014.csv > observer_log_4db_2014.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    print "time_beg,time_end,diag,notes"
}

FNR > 1 {
    beg_yyyy=sprintf("%04d", $1)
    beg_mm=sprintf("%02d", $2)
    beg_dd=sprintf("%02d", $3)
    time_beg=sprintf("%s-%s-%s %02d:%02d:00", beg_yyyy, beg_mm, beg_dd,
		     $4, $5)
    end_yyyy=sprintf("%04d", $6)
    end_mm=sprintf("%02d", $7)
    end_dd=sprintf("%02d", $8)
    time_end=sprintf("%s-%s-%s %02d:%02d:00", end_yyyy, end_mm, end_dd,
		     $9, $10)
    print time_beg, time_end, $11, $12
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
