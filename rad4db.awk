#! /usr/bin/igawk -f
# Author: Sebastian Luque
# Created: 2014-02-07T17:50:24+0000
# -------------------------------------------------------------------------
# Commentary:
#
# We prepare a table with all records from RAD files to be loaded into the
# database.
#
# We have the following file structure in 2018 (no headers):
#
# [1]  timestamp ["YYYY-MM-DD HH:MM:SS"]
# [2]  record number [D+]
# [3]  program_version ["D+"]
# [4]  battery voltage [D+]
# [5]  logger temperature [D+]
# [6]  standard deviation battery voltage [D+]
# [7]  standard deviation logger temperature [D+]
# [8]  K_down [D+]
# [9]  temperature thermopile [D+]
# [10] temperature case [D+]
# [11] temperature dome [D+]
# [12] PIR case resistance [D+]
# [13] PIR dome resistance [D+]
# [14] LW_down [D+]
# [15] PAR [D+]
# [16] temperature UV mV [D+]
# [17] UVb mV [D+]
# [18] UVa mV [D+]
# [19] temperature UV [D+]
# [20] UVb [D+]
# [21] UVa [D+]
# [22] temperature UV flag [D+]
# [23] standard deviation K_down [D+]
# [24] standard deviation temperature thermopile [D+]
# [25] standard deviation temperature case [D+]
# [26] standard deviation temperature dome [D+]
# [27] standard deviation PIR case resistance [D+]
# [28] standard deviation PIR dome resistance [D+]
# [29] standard deviation LW_down [D+]
# [30] standard deviation PAR [D+]
# [31] temperature UV mV [D+]
# [32] UVb mV [D+]
# [33] UVa mV [D+]
# [34] temperature UV [D+]
# [35] UVb [D+]
# [36] UVa [D+]
# [37] POSMV variable (1)
# [38] POSMV variable (2)
# ...
# [78] POSMV variable (44)
#
# We ignore all POSMV data here.
#
# Example call (file written in current directory):
#
# rad4db.awk *.dat > rad_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ncols=36			# number of columns
    print "time,record_no,program_version,battery_voltage",
	"logger_temperature,battery_voltage_sd,logger_temperature_sd",
	"K_down,temperature_thermopile,temperature_case,temperature_dome",
	"PIR_case_resistance,PIR_dome_resistance,LW_down,PAR",
	"temperature_UV_mV,UVb_mV,UVa_mV,temperature_UV,UVb,UVa",
	"temperature_UV_flag,K_down_sd,temperature_thermopile_sd",
	"temperature_case_sd,temperature_dome_sd,PIR_case_resistance_sd",
	"PIR_dome_resistance_sd,LW_down_sd,PAR_sd,temperature_UV_mV_sd",
	"UVb_mV_sd,UVa_mV_sd,temperature_UV_sd,UVb_sd,UVa_sd"
    fld_map
}

FNR > 4 {
    for (i=1; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
