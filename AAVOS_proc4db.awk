#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2015-07-14T16:08:22+0000
# Last-Updated: 2016-03-08T21:08:16+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# This is for converting the processed AAVOS CSV table files obtained from
# U Laval to a single CSV file for input into the gases database.  It looks
# like these files were generated from the raw *.log files, and form the
# basis from which they calculated the hourly averages.
#
# The header of this input file in 2015 was:
#
# [1] Acquisition date [yyyy/mm/dd]
# [2] Acquisition hour [HH:MM:SS]
# [3] Wind speed [Knt]
# [4] True wind direction [degrees N]
# [5] Relative wind direction [degrees N]
# [6] Barometric pressure (mBar)
# [7] Air temperature [deg C]
# [8] Humidity [%]
# [9] Sea surface temperature [deg C]
#
# Semicolon and simple whitespace separates each field.
#
# Example call (file written to current directory):
#
# AAVOS_csv4db.awk *.csv > AAVOS_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=" +; +"
    OFS=","
    ncols=9
    print "time,wind_speed,true_wind_direction,relative_wind_direction",
	"barometric_pressure,air_temperature,humidity,sea_surface_temperature"
}

FNR > 1 {
    gsub(/\//, "-", $1)
    time_utc=sprintf("%s %s", $1, $2)
    printf "%s,", time_utc
    for (i=3; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}
