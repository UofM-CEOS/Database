#! /usr/bin/gawk -f
# Author: Sebastian P. Luque
# Created: 2017-11-30T16:08:22+0000
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# This is for converting the processed TSG (thermosalinograph) CSV table
# files obtained from U Laval to a single CSV file for input into the gases
# database.  It looks like these files were generated from the raw *.cnv
# files, and form the basis from which they calculated 1-min averages, as
# well as other major corrections including comparisons with Rosette data.
#
# The header of this input file in 2016 was:
#
# [1]  Acquisition date [yyyy/mm/dd]
# [2]  Acquisition hour [HH:MM:SS]
# [3]  Latitude [degrees N]
# [4]  Longitude [degrees E]
# [5]  Water Temperature from sensor SBE38 [deg C]
# [6]  Salinity from thermosalinograph SBE45 [psu]
# [7]  Fluorescence [ug/L]
# [8]  Sound velocity [m/s]
# [9]  Vessel speed [Knt]
# [10] Water flow rate [L/min]
#
# Simple whitespace separates each field.
#
# Example call (file written to current directory):
#
# TSG_proc4db.awk *.int > TSG_proc_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=" +"
    OFS=","
    skip_rows=21
    ncols=10
    print "time,latitude,longitude,H2O_temperature",
	"salinity,fluorescence,sound_velocity,speed_over_ground,H2O_flow_rate"
}

FNR > skip_rows {
    gsub(/\//, "-", $1)
    time_utc=sprintf("%s %s", $1, $2)
    printf "%s,", time_utc
    for (i=3; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}
