#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-02-09T03:05:41+0000
# Last-Updated: 2015-06-30T18:46:02+0000
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
# TIMESTAMP     -> time 
# Patm_Avg      -> atmospheric_pressure
# T_hmp_Avg     -> air_temperature
# RH_hmp_Avg    -> relative_humidity
# Tsurface_Avg  -> surface_temperature
# W_s_WVc(1)    -> Mean horizontal wind speed
# W_s_WVc(2)    -> Unit vector mean wind direction
# W_s_WVc(3)    -> Standard deviation of wind direction
#
# In 2010 (perhaps others too), it was:
#
# [1]  arrayID
# [2]  year [YYYY]
# [3]  day of year [DDD]
# [4]  hour-minute [HHMM]
# [5]  seconds [SS]
# [6]  program version [D+]
# [7]  battery voltage [D+]
# [8]  panel temperature [D+]
# [9]  atmospheric pressure [D+]
# [10] air temperature [D+]
# [11] relative humidity [D+]
# [12] surface temperature [D+]
# [13] W_s_WVc(1) [D+] -> mean horizontal wind speed
# [14] W_s_WVc(2) [D+] -> unit vector mean wind direction
# [15] W_s_WVc(3) [D+] -> standard deviation of wind direction
# [16] PAR [D+]
# [17] pitch [D+]
# [18] roll [D+]
# [19] standard deviation battery voltage [D+]
# [20] standard deviation panel temperature [D+]
# [21] standard deviation atmospheric pressure [D+]
# [22] standard deviation air temperature [D+]
# [23] standard deviation relative humidity [D+]
# [24] standard deviation surface temperature [D+]
# [25] standard deviation PAR [D+]
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
	"relative_humidity,surface_temperature,cp_CO2_fraction",
	"cp_H2O_fraction,cp_pressure,cp_temperature,wind_speed,wind_direction",
	"wind_direction_sd,battery_voltage_sd,logger_temperature_sd",
	"atmospheric_pressure_sd,air_temperature_sd,relative_humidity_sd",
	"surface_temperature_sd,cp_CO2_fraction_sd,cp_H2O_fraction_sd",
	"cp_pressure_sd,cp_temperature_sd"
}

FNR > 4


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
