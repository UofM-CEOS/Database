#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2015-07-14T16:08:22+0000
# Last-Updated: 2015-07-15T14:58:05+0000
#           By: Sebastian P. Luque
# copyright (c) 2015 Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# This is for converting the processed AAVOS table files obtained from U
# Laval to a single CSV file for input into the gases database.
#
# The header of this input file in 2015 was:
#
# [1] Acquisition date [yyyymmdd]
# [2] Acquisition hour [HHMMSS]
# [3] Latitude [degrees N]
# [4] Longitude [degrees E]
# [5] True wind direction [degre
# [6] True wind speed [Knt]
# [7] Air temperature [deg C]
# [8] Dew point [deg C]
# [9] Atmospheric pressure (hPa)
#
# Simple whitespace separates each field.
#
# Example call (file written to current directory):
#
# AAVOS_proc4db.awk *.int > AAVOS_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    OFS=","
    ncols=9
    print "time,latitude,longitude,wind_direction,wind_speed",
	"air_temperature,dew_point,atmospheric_pressure"
}

FNR > 20 {
    gsub(/\//, "-", $1)
    time_utc=sprintf("%s %s", $1, $2)
    printf "%s,", time_utc
    for (i=3; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}
