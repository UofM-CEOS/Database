#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-02-10T23:24:53+0000
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# This prepares the NAV files from this year for loading into database.
#
# Example call (file written in current directory):
#
# nav4db.awk *.dat > NAV_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ncols=20
    year=2010
    print "time_logger,time_gps,record_no,program_version,latitude",
	"longitude,speed_over_ground,course_over_ground,status_gps,gps_mode",
	"heading,pitch,roll,acceleration_x,acceleration_y,acceleration_z"
}

{
    gsub(/"/, "")
    if (length($4) != 6) next
    yyyy=sprintf("20%s", substr($4, 5, 2))
    mm=substr($4, 3, 2)
    dd=substr($4, 1, 2)
    time_gps=sprintf("%s-%s-%s %s:%s:%s", yyyy, mm, dd,
		     substr($5, 1, 2), substr($5, 3, 2), substr($5, 5, 2))
    time_logger=$1
    printf "%s,%s,%s,%s,", time_logger, time_gps, $2, $3
    for (i=6; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
