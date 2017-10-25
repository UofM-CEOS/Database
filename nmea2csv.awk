#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-01-30T21:50:04+0000
# copyright (c) 2014-2017 Sebastian P. Luque
#
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
# Extracts NMEA(0183)-like data from GPS navigation systems such as the
# POSMV and C-NAV instruments onboard the Amundsen, and converts them to
# CSV form.  We obtain heading, position, speed and course over ground.
#
# The apparent order of sentences in POSMV seems to be:
#
# $INZDA
# $ECZDA
# $PASHR
# $INGGA
# $INHDT
# $INVTG
#
# While for C-NAV, this is:
#
# $GPGGA
# $GPVTG
# $GPZDA
# $GPDTM
#
# See pgloader configuration on net82 computer to load the output flat file
# onto the navigation_series table of our gases database.
#
# Example call (file written to current directory):
#
# nmea2csv.awk *.13E > nav_full.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    printf "date_time,longitude,latitude,altitude,heading,roll,pitch,"
    printf "heave,cog,sog_knots,sog_kmh,nsatellites,dilution_precision\n"
}

{$1=toupper($1)}

$1 ~ /\$INZDA/ || $1 ~ /\$GPZDA/ {
    # Block counter
    nblock++
    yyyymmdd=sprintf("%s-%s-%s", $5, $4, $3)
    # Make sure we print as in BEGIN.  This is the last sentence for C-NAV,
    # so we have collected all the data from the rules below
    if ($1 ~ /\$GPZDA/) {
	printf "%s %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
	    yyyymmdd, hhmmss, lon, lat, altitude, heading, roll, pitch,
	    heave, cog, sog_knots, sog_kmh, nsatellites, dilution_precision
    }
    next
}

$1 ~ /\$PASHR/ || $1 ~ /\$GPGGA/ {
    hh=substr($2, 1, 2)
    mm=substr($2, 3, 2)
    ss=substr($2, 5)
    hhmmss=sprintf("%s:%s:%s", hh, mm, ss)
    if ($1 ~ /\$PASHR/) {
	heading=$3
	roll=$5
	pitch=$6
	heave=$7
	next
    }
}

# Both sentences have the required data in the same positions.  Always
# verify this is the case.
$1 ~ /\$INGGA/ || $1 ~ /\$GPGGA/ {
    lat_deg=substr($3, 1, 2)
    lat_dec=substr($3, 3) / 60
    lat=lat_deg + lat_dec
    lat=($4 == "N") ? lat : sprintf("-%s", lat)
    lon_deg=substr($5, 1, 3)
    lon_dec=substr($5, 4) / 60
    lon=lon_deg + lon_dec
    lon=($6 == "E") ? lon : sprintf("-%s", lon)
    nsatellites=$8
    dilution_precision=$9
    altitude=$10
    next
}

# Both sentences have the required data in the same positions.  Always
# verify this is the case.
$1 ~ /\$INVTG/ || $1 ~ /\$GPVTG/ {
    cog=$2
    sog_knots=$6
    sog_kmh=$8
    # Make sure we print as in BEGIN.  This is the last sentence for POSMV,
    # but make sure we're at the end of the block
    if ($1 ~ /\$INVTG/ && nblock) {
	printf "%s %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
	    yyyymmdd, hhmmss, lon, lat, altitude, heading, roll, pitch,
	    heave, cog, sog_knots, sog_kmh, nsatellites, dilution_precision
    }
}




#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
