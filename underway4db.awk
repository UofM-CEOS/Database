#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-01-09T21:39:59+0000
# Last-Updated: 2015-06-30T18:48:19+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# We have the following file structure (2010):
#
# [1]  record_type [string]
# [2]  uw_diag [integer]
# [3]  date [DD/MM/YY]
# [4]  time [HH:MM:SS]
# [5]  equ temperature [D+]
# [6]  std value [D+]
# [7]  "uw CO2 (millivolts)" [D+]
# [8]  "uw CO2 fraction (um/m)" [D+]
# [9]  "uw H2O (millivolts)" [D+]
# [10] "uw H2O fraction (mm/m)" [D+]
# [11] uw temperature analyzer [D+]
# [12] uw pressure analyzer [D+]
# [13] equ pressure [D+]
# [14] "H2O flow" [D+]
# [15] air flow analyzer [D+]
# [16] equ speed pump [D+]
# [17] ventilation flow [D+]
# [18] condensation_atm [D+]
# [19] condensation equ [D+]
# [20] drip 1 [D+]
# [21] drip 2 [D+]
# [22] condenser temperature [D+]
# [23] temperature dry box [D+]
# [24] ctd pressure [D+]
# [25] ctd temperature [D+]
# [26] ctd conductivity [D+]
# [27] "ctd O2 saturation" [D+]
# [28] "ctd O2 concentration" [D+]
# [29] "uw pH" [D+]
# [30] uw redox potential [D+]
# [31] temperature external [D+]
# [32] temperature_in
# 
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS="\t"
    OFS=","
    ncols=32			# number of columns
    year=2010
}

NF > ncols || $1 !~ /[[:alpha:]]/ { next } # obviously garbage

{				# skip if we have any garbage
    for (i=1; i <= NF; i++) {
	if ($i !~ /[[:alnum:]]/) next
    }
}

FNR > 1 {
    split($4, hms, ":")
    dtime=sprintf("20%s-%s-%s %02i:%02i:%02i", substr($3, 7, 2),
		  substr($3, 4, 2), substr($3, 1, 2),
		  hms[1], hms[2], hms[3])
    if (substr(dtime, 1, 4) != year) next # we still got garbage
    printf "%s,%s,%s,", dtime, $1, $2
    # Print commas to get the same number of (ncols) fields always
    for (i=5; i <= (ncols - 1); i++) { printf "%s,", $i }
    printf "%s\n", $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
