#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2013-11-21T13:40:36+0000
# Last-Updated: 2015-08-26T20:46:56+0000
#           By: Sebastian P. Luque
# copyright (c) 2013-2015 Sebastian P. Luque
# -------------------------------------------------------------------------
# This program is Free Software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with GNU Emacs; see the file COPYING. If not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
# -------------------------------------------------------------------------
# Commentary:
#
# Watch shebang and make sure it matches system!
#
# This script takes a standardized pCO2 file as first argument and any
# number of standardized temperature data files.  For each pCO2 record, it
# selects the temperature data that are closest in time, up to a given
# maximum time difference.
#
# Variables required:
#
#     max_time_diff:   Maximum time difference (seconds).
#     temperature_fld: temperature field in temperature files
#
# We assume:
#
#     o pCO2 file does not have a header line.
#     o Temperature files have a single header line.
#     o Full ISO time stamp is available in both files as single field (1st).
#
# Note:
#
#     Note that if the max_time_diff specified is larger than the sampling
#     frequency in the temperature files, there will be multiple matches
#     returned per pCO2 record.
#
# Example:
#
# ./match_temperature.awk -v max_time_diff=60 -v temperature_fld=4 \
#     UW_pCO2.csv UW_water_temperature.csv
#
# -------------------------------------------------------------------------
# Code:

BEGIN { FS=OFS="," }

# Work on pCO2 file
NR == FNR {
    split($1, a, /[ :-]/)
    tstr_pCO2=sprintf("%s %s %s %s %s %s",
		      a[1], a[2], a[3], a[4], a[5], a[6])
    t_pCO2=mktime(tstr_pCO2)
    # Save full record
    pCO2[t_pCO2]=$0
    next
}

# Work on the water temperature file(s) (skip header line)
FNR > 1 {
    split($1, a, /[ :-]/)
    tstr_temperature=sprintf("%s %s %s %s %s %s",
			     a[1], a[2], a[3], a[4], a[5], a[6])
    t_temperature=mktime(tstr_temperature)
    if (t_temperature < 0) {
	printf "Faulty data %s, %s\n", FILENAME, FNR > "/dev/stderr"
	next
    }
    # Save all pCO2 data.  Just equilibration temperature for now.
    temperature[t_temperature]=$temperature_fld
}

END {
    # Loop through pCO2, compare time stamps with temperature.  Sort first.
    n=asorti(pCO2, pCO2_srt)	# now pCO2_srt contains sorted indices
    m=asorti(temperature, temperature_srt) # temperature_srt contains
					   # sorted indices
    for (i=1; i <= n; i++) {	# scan each sorted index in pCO2
    	for (j=1; j <= m; j++) { # scan each sorted index in temperature
    	    tdiff=temperature_srt[j] - pCO2_srt[i]
    	    tdiff=tdiff >= 0 ? tdiff : -tdiff
	    # If current difference is smaller than previous, or we're at
	    # first iteration, record a minimum
	    if (j == 1 || tdiff < tdiff_min) {
		tdiff_min=tdiff	     # time difference
		temperature_t=temperature_srt[j] # temperature time
		temperature_data=temperature[temperature_srt[j]]
	    }
    	}
	# We've gone through all temperature records, and we can determine
	# whether minimum is smaller than the maximum difference allowed,
	# then print record
	if (tdiff_min < max_time_diff) {
	    printf "%s,%s,%s\n",
		pCO2[pCO2_srt[i]],
		strftime("%F %T", temperature_t), temperature_data
	} else {
	    nomatch=sprintf("Non-match -> pCO2: %s | temperature: %s\n",
			    strftime("%F %T", pCO2_srt[i]),
			    strftime("%F %T", temperature_t))
	    print nomatch > "/dev/stderr"
	    printf "%s,,\n", pCO2[pCO2_srt[i]]
	}
	tdiff_min=tdiff		# reset the difference
    }
}




#_ + Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
