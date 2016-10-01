#! /usr/bin/igawk -f
# Author: Sebastian Luque
# Created: 2014-02-12T04:33:42+0000
# Last-Updated: 2016-09-28T18:33:16+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# This is used to produce several files to be loaded onto database, which
# combines the data from the project.
#
# We assume the following file structure (2016):
#
# [1]  timestamp [YYYY-mm-dd HH:MM:SS]
# [2]  record number [D+]
# [3]  program version [D+]
# [4]  acceleration x [D+]
# [5]  acceleration y [D+]
# [6]  acceleration z [D+]
# [7]  rate x [D+]
# [8]  rate y [D+]
# [9]  rate z [D+]
# [10] wind speed u (analog) [D+]
# [11] wind speed v (analog) [D+]
# [12] wind speed w (analog) [D+]
# [13] air temperature sonic (analog) [D+]
# [14] wind speed u (serial) [D+]
# [15] wind speed v (serial) [D+]
# [16] wind speed w (serial) [D+]
# [17] air temperature sonic (serial) [D+]
# [18] sound speed (serial) [D+]
# [19] anemometer status (serial) [D+]
# [20] op CO2 density [D+]
# [21] op H2O density [D+]
# [22] op pressure [D+]
# [23] op temperature [D+]
# [24] op cooler voltage [D+]
# [25] op analyzer status [D+]
# [26] cp CO2 fraction [D+]
# [27] cp H2O fraction [D+]
# [28] cp pressure [D+]
# [29] cp temperature [D+]
# [30] cp analyzer status [D+]
#
# Example call (output written to current directory):
#
# flux4db.awk *.dat
# -------------------------------------------------------------------------
# Code:

@include doy2isodate.awk

BEGIN {
    FS=OFS=","
    print "time,program_version,acceleration_x,acceleration_y",
	"acceleration_z,rate_x,rate_y,rate_z",
	"wind_speed_u_ana,wind_speed_v_ana,wind_speed_w_ana",
	"air_temperature_sonic_ana,wind_speed_u_ser,wind_speed_v_ser",
	"wind_speed_w_ser,air_temperature_sonic_ser,sound_speed_ser",
	"anemometer_status_ser,op_CO2_density,op_H2O_density",
	"op_pressure,op_temperature,op_cooler_voltage,op_analyzer_status",
	"cp_CO2_fraction,cp_H2O_fraction,cp_pressure,cp_temperature",
	"cp_analyzer_status"
}

# First 5 lines are metadata
FNR > 4 {
    printf "%s,%s,", $1, $3
    for (i=4; i <= (NF - 1); i++) { printf "%s,", $i }
    print $NF
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
