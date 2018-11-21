#! /usr/local/bin/igawk -f
# Author: Sebastian Luque
# Created: 2014-02-07T17:50:24+0000
# -------------------------------------------------------------------------
# Commentary:
#
# We prepare a table with all records from RAD files to be loaded into the
# database.
#
# We have the following file structure (no headers):
#
# [1]  timestamp ["YYYY-MM-DD HH:MM:SS"]
# [2]  record number [D+]
# [3]  program_version ["D+"]
# [4]  battery voltage [D+]
# [5]  logger temperature [D+]
# [6]  K_down [D+]
# [7]  temperature thermopile [D+]
# [8]  temperature case [D+]
# [9]  temperature dome [D+]
# [10] PIR case resistance [D+]
# [11] PIR dome resistance [D+]
# [12] LW_down [D+]
# [13] PAR [D+]
# [14] standard deviation battery voltage [D+]
# [15] standard deviation logger temperature [D+]
# [16] standard deviation K_down [D+]
# [17] standard deviation temperature thermopile [D+]
# [18] standard deviation temperature case [D+]
# [19] standard deviation temperature dome [D+]
# [20] standard deviation PIR case resistance [D+]
# [21] standard deviation PIR dome resistance [D+]
# [22] standard deviation LW_down [D+]
# [23] standard deviation PAR [D+]
# [24] POSMV variable (1)
# [25] POSMV variable (2)
# ...
# [67] POSMV variable (44)
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
    ncols=23			# number of columns
    print "time,record_no,program_version,battery_voltage",
	"logger_temperature,K_down,temperature_thermopile",
	"temperature_case,temperature_dome,PIR_case_resistance",
	"PIR_dome_resistance,LW_down,PAR,battery_voltage_sd",
	"logger_temperature_sd,K_down_sd,temperature_thermopile_sd",
	"temperature_case_sd,temperature_dome_sd,PIR_case_resistance_sd",
	"PIR_dome_resistance_sd,LW_down_sd,PAR_sd"
}

FNR > 4 {
    for (i=1; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
