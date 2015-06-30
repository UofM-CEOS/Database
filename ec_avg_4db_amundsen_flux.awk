#! /usr/bin/igawk -f
# Author: Sebastian Luque
# Created: 2014-02-12T04:33:42+0000
# Last-Updated: 2015-06-01T18:46:21+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This is used to produce several files to be loaded onto database, which
# combines the data from the project.
#
# We assume the following file structure (2010 and possibly other years):
#
# [1]  ArrayID [D+]
# [2]  year [YYYY]
# [3]  day-of-year [DDD]
# [4]  hour-minute [H*HMM]
# [5]  seconds [S*S]
# [6]  program version [D+]
# [7]  cp CO2 fraction [D+]
# [8]  cp H2O fraction [D+]
# [9]  cp pressure [D+]
# [10] cp temperature [D+]
# [11] air temperature sonic [D+]
# [12] op CO2 density [D+]
# [13] op H2O density [D+]
# [14] op pressure [D+]
# [15] op temperature [D+]
# [16] op CO2 fraction [D+]
# [17] op H2O fraction [D+]
# [18] atmospheric pressure [D+]
# [19] op temperature base [D+]
# [20] op temperature spar [D+]
# [21] op temperature bulb [D+]
#
# Example call (output written to current directory):
#
# ec_avg_4db.awk *.dat
# -------------------------------------------------------------------------
# Code:

@include doy2isodate.awk

BEGIN {
    FS=OFS=","
    ncols=21
    print "time,program_version,cp_CO2_fraction,cp_H2O_fraction",
	"cp_pressure,cp_temperature,air_temperature_sonic",
	"op_CO2_density,op_H2O_density,op_pressure,op_temperature",
	"op_CO2_fraction,op_H2O_fraction,atmospheric_pressure",
	"op_temperature_base,op_temperature_spar,op_temperature_bulb"
}

{
    # Skip messed up rows
    gsub(/"/, "")
    # These are bad logger time stamps
    if ((length($4) < 3 || length($4) > 4) ||
	(length($5) < 1 || length($5) > 2)) {
	next
    } else {			# fix the rest
	$4=sprintf("%04i", $4)
	$5=sprintf("%02i", $5)
    }
    # These are bad year/DOY
    if ((length($2) != 4) || ($3 < 0 || $3 > 366)) {next}
    # Now retrieve what we need
    time_logger=sprintf("%s %02i:%02i:%02i", doy2isodate($2, $3),
			substr($4, 1, 2), substr($4, 3, 2), $5)
    printf "%s,%s,", time_logger, $6
    for (i=7; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# ec_avg_4db.awk ends here
