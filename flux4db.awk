#! /usr/bin/igawk -f
# Author: Sebastian Luque
# Created: 2014-02-12T04:33:42+0000
# -------------------------------------------------------------------------
# Commentary:
#
# This is used to produce several files to be loaded onto database, which
# combines the data from the project.
#
# We assume the following file structure (2010 and perhaps other years):
#
# [1]  ArrayID [D+]
# [2]  year [YYYY]
# [3]  day-of-year [DDD]
# [4]  hour-minute [H*HMM]
# [5]  seconds [S*S(.S)*]
# [6]  program version [D+]
# [7]  acceleration x [D+]
# [8]  acceleration y [D+]
# [9]  acceleration z [D+]
# [10] rate x [D+]
# [11] rate y [D+]
# [12] rate z [D+]
# [13] wind speed u (analog) [D+]
# [14] wind speed v (analog) [D+]
# [15] wind speed w (analog) [D+]
# [16] air temperature sonic (analog) [D+]
# [17] op CO2 density [D+]
# [18] op H2O density [D+]
# [19] op CO2 absorptance [D+]
# [20] op H2O absorptance [D+]
# [21] op pressure [D+]
# [22] op temperature [D+]
# [23] op cooler voltage [D+]
# [24] op analyzer status [D+]
# [25] cp CO2 fraction [D+]
# [26] cp H2O fraction [D+]
# [27] cp pressure [D+]
# [28] cp temperature [D+]
# [29] cp analyzer status [D+]
# [30] wind speed u (serial) [D+]
# [31] wind speed v (serial) [D+]
# [32] wind speed w (serial) [D+]
# [33] air temperature sonic (serial) [D+]
# [34] sound speed (serial) [D+]
# [35] anemometer status (serial) [D+]
# [36] atmospheric pressure (fast response transducer) [D+]
# [37] op temperature base [D+]
# [38] op temperature spar [D+]
# [39] op temperature bulb [D+]
# [40] cp mode (this seems to indicate measurement type...) [D+]
# [41] op CO2 density (shroud) [D+]
# [42] op H2O density (shroud) [D+]
# [43] op pressure (shroud) [D+]
# [44] op analyzer status (shroud) [D+]
#
# Example call (output written to current directory):
#
# ec4db.awk *.dat
# -------------------------------------------------------------------------
# Code:

# @include doy2isodate.awk

BEGIN {
    FS=OFS=","
    ncols=44
    print "time,program_version,acceleration_x,acceleration_y",
	"acceleration_z,rate_x,rate_y,rate_z,wind_speed_u,wind_speed_v",
	"wind_speed_w,air_temperature_sonic,op_CO2_density,op_H2O_density",
	"op_CO2_absorptance,op_H2O_absorptance,op_pressure,op_temperature",
	"op_cooler_voltage,op_analyzer_status,cp_CO2_fraction",
	"cp_H2O_fraction,cp_pressure,cp_temperature,cp_analyzer_status",
	"wind_speed_u_ser,wind_speed_v_ser,wind_speed_w_ser",
	"air_temperature_sonic_ser,sound_speed_ser,anemometer_status_ser",
	"atmospheric_pressure_fast,op_temperature_base,op_temperature_spar",
	"op_temperature_bulb,cp_mode,op_CO2_density_sh,op_H2O_density_sh",
	"op_pressure_sh,op_analyzer_status_sh"
}

{
    # Skip messed up rows
    gsub(/"/, "")
    # These are bad logger time stamps
    if ((length($4) < 3 || length($4) > 4) ||
	(length($5) < 1 || length($5) > 4)) {
	next
    } else {			# fix the rest
	$4=sprintf("%04i", $4)
	$5=sprintf("%02.1f", $5)
    }
    # These are bad year/DOY
    if ((length($2) != 4) || ($3 < 0 || $3 > 366)) {next}
    # Now retrieve what we need
    time_logger=sprintf("%s %02i:%02i:%02.1f", doy2isodate($2, $3),
			substr($4, 1, 2), substr($4, 3, 2), $5)
    printf "%s,%s,", time_logger, $6
    for (i=7; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
