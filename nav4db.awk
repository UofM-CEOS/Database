#! /usr/bin/igawk -f
# Author: Sebastian Luque
# Created: 2014-02-10T23:24:53+0000
# Last-Updated: 2015-06-30T22:04:31+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
# 
# See the pgloader configuration file for details.
#
# This prepares the NAV files from this year for loading into database.
#
# File structure:
#
# [1] arrayID
# [2] year [YYYY]
# [3] day of year [DDD]
# [4] hour-minute [H*HMM]
# [5] seconds [S*S]
# [6] program version [D+]
# [7] acquisition date [DDMMYY]
# [8] acquisition time [HHMMSS]
# [9] latitude [D+]
# [10] longitude [D+]
# [11] speed over ground [D+]
# [12] course over ground [D+]
# [13] GPS status [A]
# [14] GPS checksum [AD+]
# [15] heading [D+]
# [16] roll [D+]
# [17] pitch [D+]
# [18] acceleration X [D+]
# [19] acceleration Y [D+]
# [20] acceleration Z [D+]
#
# Example call (file written in current directory):
#
# AWKPATH=/usr/local/src/awk nav4db_amundsen_flux.awk *.dat > NAV_all.csv
#
# NOTE: Ensure that AWKPATH is set so we can find doy2isodate.awk
# -------------------------------------------------------------------------
# Code:

@include doy2isodate.awk

BEGIN {
    FS=OFS=","
    ncols=20
    year=2010
    print "time_logger,time_gps,program_version,latitude,longitude",
	"speed_over_ground,course_over_ground,gps_status,gps_checksum",
	"heading,pitch,roll,acceleration_x,acceleration_y,acceleration_z"
}

{
    # Skip messed up rows
    gsub(/"/, "")
    # These are bad GPS date/time strings
    if ((length($7) != 6) || (length($8) != 6)) {next}
    # These are bad logger time stamps
    if ((length($4) < 3 || length($4) > 4) ||
	(length($5) < 1 || length($5) > 2)) {
	next
    } else {			# fix the rest
	$4=sprintf("%04i", $4)
	$5=sprintf("%02i", $5)
    }
    # These are bad DOY/year
    if ((length($2) != 4) || ($3 < 0 || $3 > 366)) {next}
    # Now retrieve what we need
    yyyy=sprintf("20%s", substr($7, 5, 2))
    mm=substr($7, 3, 2)
    dd=substr($7, 1, 2)
    time_gps=sprintf("%04i-%02i-%02i %02i:%02i:%02i", yyyy, mm, dd,
		     substr($8, 1, 2), substr($8, 3, 2), substr($8, 5, 2))
    time_logger=sprintf("%s %02i:%02i:%02i", doy2isodate($2, $3),
			substr($4, 1, 2), substr($4, 3, 2), $5)
    printf "%s,%s,%s,", time_logger, time_gps, $6
    for (i=9; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
