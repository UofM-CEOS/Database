#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-01-09T21:39:59+0000
# -------------------------------------------------------------------------
# Commentary:
#
# See the pgloader configuration file for details.
#
# We have the following file structure (2018):
#
# [1]  record_type [string]
# [2]  uw_diag [integer]
# [3]  date [DD/MM/YY]
# [4]  time [HH:MM:SS]
# [5]  equ temperature [D+]
# [6]  std value [D+]
# [7]  "uw CO2 cell A (raw value)" [D+]
# [8]  "uw CO2 cell B (raw value)" [D+]
# [9]  "uw CO2 fraction (um/m)" [D+]
# [10] "uw H2O cell A (raw value)" [D+]
# [11] "uw H2O cell B (raw value)" [D+]
# [12] "uw H2O fraction (mm/m)" [D+]
# [13] "uw temperature analyzer" [D+]
# [14] "uw pressure analyzer" [D+]
# [15] "uw analyzer diag" [D+]
# [16] "uw relative humidity" [D+]
# [17] "C AGC" [D+]
# [18] "H AGC" [D+]
# [19] "Flow V" [D+]
# [20] equ pressure [D+]
# [21] "H2O flow" [D+]
# [22] air flow analyzer [D+]
# [23] equ speed pump [D+]
# [24] ventilation flow [D+]
# [25] condensation_atm [D+]
# [26] condensation_equ [D+]
# [27] drip 1 [D+]
# [28] drip 2 [D+]
# [29] condenser temperature [D+]
# [30] temperature dry box [D+]
# [31] ctd pressure [D+]
# [32] ctd temperature [D+]
# [33] ctd conductivity [D+]
# [34] "ctd O2 saturation" [D+]
# [35] "ctd O2 concentration" [D+]
# [36] "uw pH" [D+]
# [37] uw redox potential [D+]
# [38] temperature external [D+]
# [39] turbidity [D+]
# [40] fluorometer [D+]
#
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS="\t"
    OFS=","
    ncols=40			# number of columns
    year=2018
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
    print $ncols
}


##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
