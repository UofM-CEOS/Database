#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2015-07-14T16:08:22+0000
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
# [1]  NMEA string [$AVRTE]
# [2]  Acquisition date [yymmdd]
# [3]  Acquisition hour [HHMMSS]
# [4]  Serial [DDDDD]
# [5]  Call [CGDT]
# [6]  Apparent wind speed [Knt]
# [7]  Apparent wind direction [degrees N]
# [8]  Relative wind direction [degrees N]
# [9]  Apparent wind speed 2 [knt]
# [10] Apparent wind direction 2 [degrees N]
# [11] Relative wind direction 2 [degrees N]
# [12] Barometric pressure uncorrected [mBar]
# [13] Barometric pressure uncorrected 2 [mBar]
# [14] Air temperature [deg C]
# [15] Relative Humidity [%]
# [16] Air temperature 2 [deg C]
# [17] Relative humidity 2 [%]
# [18] Sea surface temperature [deg C]
# [19] Apparent wind gust [knt]
# [20] Apparent wind gust 2 [knt]
# [21] Heading [degrees N]
# [22] Heading (alternative, not used) [degrees N]
# [23] Battery voltage [DD*DD]
#
# Example call (file written to current directory):
#
# AAVOS_rte4db.awk *.csv > AAVOS_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ctry=20			# first 2 digits of year
    ncols=23
    print "time,wind_speed,wind_direction,relative_wind_direction",
	"barometric_pressure,air_temperature,humidity,sea_surface_temperature"
}

$1 ~ /^\$AVRTE/ && NF == ncols {
    if (length($2) != 6) next
    yyyy=sprintf("%s%s", ctry, substr($2, 1, 2))
    mnth=substr($2, 3, 2)
    dd=substr($2, 5, 2)
    hh=substr($3, 1, 2)
    mm=substr($3, 3, 2)
    ss=substr($3, 5, 2)
    time_utc=sprintf("%s-%s-%s %s:%s:%s", yyyy, mnth, dd, hh, mm, ss)
    printf "%s,%s,%s,%s,%s,%s,%s,%s\n", time_utc, $6, $7, $8, $12, $14,
	$15, $18
}
