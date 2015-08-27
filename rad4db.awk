#! /usr/bin/igawk -f
# Author: Sebastian Luque
# Created: 2014-02-07T17:50:24+0000
# Last-Updated: 2015-08-27T03:00:09+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
# 
# We prepare a table with all records from RAD files to be loaded into the
# database.
#
# We have the following file structure (no headers):
#
# [1]  arrayID
# [2]  year [YYYY]
# [3]  day of year [DDD]
# [4]  hour-minute [H*HMM]
# [5]  battery voltage [D+]
# [6]  logger temperature [D+]
# [7]  standard deviation battery voltage [D+]
# [8]  standard deviation logger temperature [D+]
# [9]  K_down [D+]
# [10] temperature thermopile [D+]
# [11] temperature case [D+]
# [12] temperature dome [D+]
# [13] LW_down [D+]
# [14] PAR [D+]
# [15] UV sensor temperature [D+]
# [16] UV_b [D+]
# [17] UV_a [D+]
# [18] standard deviation K_down [D+]
# [19] standard deviation temperature thermopile [D+]
# [20] standard deviation temperature case [D+]
# [21] standard deviation temperature dome [D+]
# [22] standard deviation LW_down [D+]
# [23] standard deviation PAR [D+]
# [24] standard deviation UV sensor temperature [D+]
# [25] standard deviation UV_b [D+]
# [26] standard deviation UV_a [D+]
#
# The file contains old 2014 data, which we skip.
# 
# Example call (file written in current directory):
#
# rad4db.awk *.dat > rad_all.csv
# -------------------------------------------------------------------------
# Code:

@include doy2isodate.awk

BEGIN {
    FS=OFS=","
    ncols=26			# number of columns
}

{
    # Skip messed up rows
    gsub(/"/, "")
    # These are bad logger time stamps
    if ((length($4) < 1 || length($4) > 4)) {next}
    # These are bad DOY/year
    if ((length($2) != 4) || ($3 < 0 || $3 > 366)) {next}
    # Now retrieve what we need
    isodate=doy2isodate($2, $3)
    hhmm=sprintf("%04i", $4)
    time_logged=sprintf("%s %s %s %02i %02i 00",
			substr(isodate, 1, 4), substr(isodate, 6, 2),
			substr(isodate, 9),
			substr(hhmm, 1, 2), substr(hhmm, 3, 2))
    # This fixes stupid 2400 time stamp, correctly adjusting the date
    time_logger=strftime("%F %T", mktime(time_logged))
    printf "%s,%s,", time_logger, $5
    for (i=6; i <= (ncols - 1); i++) { printf "%s,", $i }
    print $ncols
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
