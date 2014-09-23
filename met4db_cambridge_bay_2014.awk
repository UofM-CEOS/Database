#! /usr/bin/gawk -f
# $Id$
# Author: Sebastian Luque
# Created: 2014-09-16T21:23:03+0000
# Last-Updated: 2014-09-17T22:10:40+0000
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
# Example call (file written to current directory):
#
# met4db.awk *.dat > MET_RAD_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ncols=27
    print "time,record_no,program_version,battery_voltage",
    	"logger_temperature,air_temperature,relative_humidity",
    	"atmospheric_pressure,surface_temperature,wind_speed",
    	"wind_direction,wind_direction_sd,K_down_voltage,PAR",
	"K_down,K_up,LW_down_raw,LW_up_raw,temperature_instrument",
    	"temperature_instrument_kelvin,LW_down,LW_up,K_net,LW_net",
    	"albedo,radiation_net,heat_ctl"
}

FNR > 4 {
    gsub(/"/, "")
    date_time=$1
    record_number=$2
    program_version=sprintf("%.1f", $3)
    # Convert 1.0 to 1.4 (this was a logger program error)
    if (program_version == "1.0") program_version="1.4"
    printf "%s,%s,%s,%s,", date_time, record_number,
	program_version, $4
    for (i=5; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# met4db.awk ends here
