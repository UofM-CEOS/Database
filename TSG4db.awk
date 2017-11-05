#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2015-10-10T21:35:25+0000
# -------------------------------------------------------------------------
# Commentary:
#
# Prepare thermosalinograph cnv data for loading into database.
#
# The file format (semicolon separated) is documented as:
#
# [1]  time_pc [YYYY/MM/DD HH:MM:SS]
# [2]  time_gps [HH:MM:SS]
# [3]  latitude [D+] (deg N)
# [4]  longitude [D+] (deg E)
# [5]  tsg_instrument_temperature [D+] (deg C)
# [6]  tsg_conductivity [D+] (S/m)
# [7]  tsg_salinity [D+] (psu)
# [8]  tsg_sound_velocity [D+] (m/s)
# [9]  tsg temperature [D+] (deg C)
# [10] tsg_fluorescence [D+] (V)
# [11] tsg_H2O_flow [D+] (V)
# [12] tsg_sound_velocity_measured [D+] (m/s)
#
# Example:
#
# ./TSG4db.awk * > output.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=";"			# These files are semicolon-separated.
    OFS=","
    ncols=12			# number of columns
    print "time_utc,time_pc,latitude,longitude,tsg_instrument_temperature",
	"tsg_conductivity,tsg_salinity,tsg_sound_velocity,tsg_temperature",
	"tsg_fluorescence,tsg_H2O_flow,tsg_sound_velocity_measured"
}

NF > ncols || $1 !~ /[[:digit:]]/ { next } # obviously garbage

{				# skip if we have any garbage
    for (i=1; i <= NF; i++) {
	if ($i !~ /[[:alnum:]]/) next
    }
}

{
    gsub(/ +; +/, ";")
    gsub(/\//, "-", $1)		# fix date string to ISO
    tstr=sprintf("%s %s %s %s %s %s",
		 substr($1, 1, 4),
		 substr($1, 6, 2),
		 substr($1, 9, 2),
		 substr($1, 12, 2),
		 substr($1, 15, 2),
		 substr($1, 18, 2))
    utc_now=mktime(tstr)
    # TSG instrument tends to make errors writing timestamp, whereby the
    # timestamp is repeated once consecutively, so must be manually
    # corrected
    if (utc_now == utc_next - 1) utc_now++
    time_utc=strftime("%F %T", utc_now)
    time_gps=sprintf("%s %s", substr($1, 1, 10), $2)
    printf "%s,%s,", time_utc, time_gps
    for (i=3; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
    utc_next=utc_now + 1
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
