#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2015-07-14T16:08:22+0000
# Last-Updated: 2017-09-06T18:32:40+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# This is for converting the un-processed AAVOS RTE CSV table files
# obtained from U Laval or the CCGS Amundsen to a single CSV file for input
# into the gases database.  The structure of the text is described in "AVOS
# Data file explained.doc", having fields:
#
# [1] Acquisition date [mm/dd/yyyy]
# [2] Acquisition hour [HH:MM:SS.DDD]
# [3] NMEA string [$AVRTE]
# [4] Reception date [ddmmyy]
# [5] Reception hour [HHMMSS]
# [6] Unknown [DDDDD]
# [7] Unknown [CGDT]
# [8] Wind speed [Knt]
# [9] True wind direction [degrees N]
# [10] Relative wind direction [degrees N]
# [11] Unknown
# [12] Unknown
# [13] Unknown
# [14] Barometric pressure uncorrected (mBar)
# [15] Unknown
# [16] Air temperature [deg C]
# [17] Relative Humidity [%]
# [18] Unknown
# [19] Unknown
# [20] Sea surface temperature [deg C]
# [21] Unknown [DD]
# [22] Unknown
# [23] Heading [degrees N]
# [24] Heading (alternative, not used) [degrees N]
# [25] Battery voltage [DD*DD]
#
# Example call (file written to current directory):
#
# AAVOS_rte4db.awk *.csv > AAVOS_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ncols=9
    print "time,wind_speed,true_wind_direction,relative_wind_direction",
	"barometric_pressure,air_temperature,humidity,sea_surface_temperature"
}

{
    split($1, datearr, "/")
    time_utc=sprintf("%s-%s-%s %s", datearr[3], datearr[1], datearr[2], $2)
    printf "%s,%s,%s,%s,%s,%s,%s,%s\n", time_utc, $8, $9, $10, $14, $16,
	$17, $20
}
