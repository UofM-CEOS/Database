#! /opt/local/bin/gawk -f
# $Id: $
# Author: Sebastian Luque
# Created: 2014-01-30T21:50:04+0000
# Last-Updated: 2014-02-01T00:21:44+0000
#           By: Sebastian Luque
# copyright (c) 2014 Sebastian P. Luque
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
# Extracts NMEA(0183)-like data from the Applanix instrument ran by Ocean
# Mapping Group to CSV form.  We obtain heading, position, speed and course
# over ground.
#
# The apparent order of the sentences in 2013 files is:
#
# $INZDA
# $ECZDA
# $PASHR
# $INGGA
# $INHDT
# $INVTG
#
# See pgloader configuration on net82 computer to load the output flat file
# onto the navigation_series table of our gases database.
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    printf "date_time,longitude,latitude,altitude,heading,roll,pitch,"
    printf "heave,cog,sog_knots,sog_km\n"
}

{$1=toupper($1)}

$1 ~ /\$INZDA/ {
    yyyymmdd=sprintf("%s-%s-%s", $5, $4, $3)
    next
}

$1 ~ /\$PASHR/ {
    hh=substr($2, 1, 2)
    mm=substr($2, 3, 2)
    ss=substr($2, 5)
    hhmmss=sprintf("%s:%s:%s", hh, mm, ss)
    heading=$3
    roll=$5
    pitch=$6
    heave=$7
    next
}

$1 ~ /\$INGGA/ {
    lat_deg=substr($3, 1, 2)
    lat_dec=substr($3, 3) / 60
    lat=lat_deg + lat_dec
    lat=($4="N") ? lat : sprintf("-%s", lat)
    lon_deg=substr($5, 1, 3)
    lon_dec=substr($5, 4)
    lon=lon_deg + lon_dec
    lon=($6="E") ? sprintf("-%s", lon) : lon
    altitude=$10
    next
}

$1 ~ /\$INVTG/ {
    cog=$2
    sog_knots=$6
    sog_km=$8
    # Make sure we print as in BEGIN
    printf "%s %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", yyyymmdd, hhmmss,
	lon, lat, altitude, heading, roll, pitch, heave, cog,
	sog_knots, sog_km
}




#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
# 
# nmea2csv_omg.awk ends here
