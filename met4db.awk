#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-02-09T03:05:41+0000
# Last-Updated: 2015-07-13T21:17:23+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# This is for converting the MET table files from the data logger to a
# single CSV file for input into the gases database.  This file is the
# source of data for several different tables in the database.  For the
# meteorology_series table this means the following fields (based on the
# TOA5 header therein):
#
# In 2015, it was:
#
# [1]  timestamp [YYYY-MM-DD HH:MM:SS]
# [2]  record number [D+]
# [3]  program version [D+]
# [4]  battery voltage [D+]
# [5]  panel temperature [D+]
# [6]  atmospheric pressure [D+]
# [7]  air temperature [D+]
# [8]  relative humidity [D+]
# [9]  surface temperature [D+]
# [10] W_s_WVc(1) [D+] -> mean horizontal wind speed
# [11] W_s_WVc(2) [D+] -> unit vector mean wind direction
# [12] W_s_WVc(3) [D+] -> standard deviation of wind direction
# [13] standard deviation battery voltage [D+]
# [14] standard deviation panel temperature [D+]
# [15] standard deviation atmospheric pressure [D+]
# [16] standard deviation air temperature [D+]
# [17] standard deviation relative humidity [D+]
# [18] standard deviation surface temperature [D+]
#
# Example call (file written to current directory):
#
# met4db.awk *.dat > met_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    print "time,record_no,program_version,battery_voltage",
	"logger_temperature,atmospheric_pressure,air_temperature",
	"relative_humidity,surface_temperature",
	"wind_speed,wind_direction,wind_direction_sd,battery_voltage_sd",
	"logger_temperature_sd,atmospheric_pressure_sd,air_temperature_sd",
	"relative_humidity_sd,surface_temperature_sd"
}

FNR > 4


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
